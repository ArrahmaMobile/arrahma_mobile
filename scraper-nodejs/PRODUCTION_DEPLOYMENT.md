# Production Deployment Guide

This guide covers deploying the auto-scraper API to production with maximum reliability.

## Pre-Deployment Checklist

- [ ] All tests passing: `./test-api-setup.sh`
- [ ] Build successful: `npm run build`
- [ ] Dependencies installed: `npm install`
- [ ] Data directory writable
- [ ] Port 8888 available (or configure different port)

## Deployment Options

### Option 1: PM2 Process Manager (Recommended)

PM2 is a production process manager for Node.js with built-in monitoring and auto-restart.

#### Install PM2
```bash
npm install -g pm2
```

#### Start the API
```bash
# Start the server
pm2 start npm --name "arrahmah-api" -- run api

# Or with custom port
PORT=8888 pm2 start npm --name "arrahmah-api" -- run api
```

#### PM2 Commands
```bash
# Monitor the server
pm2 monit

# View logs
pm2 logs arrahmah-api

# View status
pm2 status

# Restart the server
pm2 restart arrahmah-api

# Stop the server
pm2 stop arrahmah-api

# View detailed info
pm2 info arrahmah-api
```

#### Save PM2 Configuration
```bash
# Save current process list
pm2 save

# Generate startup script (run on boot)
pm2 startup

# Follow the instructions printed by the command above
```

#### PM2 Ecosystem File (Optional)
Create `ecosystem.config.js` for advanced configuration:

```javascript
module.exports = {
  apps: [{
    name: 'arrahmah-api',
    script: 'npm',
    args: 'run api',
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: '500M',
    env: {
      NODE_ENV: 'production',
      PORT: 8888
    },
    error_file: './logs/err.log',
    out_file: './logs/out.log',
    log_file: './logs/combined.log',
    time: true
  }]
};
```

Then start with:
```bash
pm2 start ecosystem.config.js
```

### Option 2: systemd Service (Linux)

Create a systemd service for automatic start on boot.

#### Create Service File
Create `/etc/systemd/system/arrahmah-api.service`:

```ini
[Unit]
Description=Arrahmah Auto-Scraper API
After=network.target

[Service]
Type=simple
User=your-username
WorkingDirectory=/path/to/scraper-nodejs
ExecStart=/usr/bin/npm run api
Restart=always
RestartSec=10
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=arrahmah-api
Environment=NODE_ENV=production
Environment=PORT=8888

[Install]
WantedBy=multi-user.target
```

#### Enable and Start Service
```bash
# Reload systemd
sudo systemctl daemon-reload

# Enable service (start on boot)
sudo systemctl enable arrahmah-api

# Start service
sudo systemctl start arrahmah-api

# Check status
sudo systemctl status arrahmah-api

# View logs
sudo journalctl -u arrahmah-api -f
```

### Option 3: Docker (Container)

Create a Dockerfile for containerized deployment.

#### Create Dockerfile
```dockerfile
FROM node:20-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy source code
COPY . .

# Build TypeScript
RUN npm run build

# Create data directory
RUN mkdir -p data

# Expose port
EXPOSE 8888

# Start server
CMD ["npm", "run", "api"]
```

#### Build and Run
```bash
# Build image
docker build -t arrahmah-api .

# Run container
docker run -d \
  --name arrahmah-api \
  -p 8888:8888 \
  -v $(pwd)/data:/app/data \
  --restart unless-stopped \
  arrahmah-api

# View logs
docker logs -f arrahmah-api

# Stop container
docker stop arrahmah-api

# Start container
docker start arrahmah-api
```

## Environment Variables

Configure the API using environment variables:

```bash
# Port (default: 8888)
export PORT=8888

# Node environment
export NODE_ENV=production
```

## Monitoring

### Health Checks

Set up periodic health checks:

```bash
# Simple health check
curl http://localhost:8888/health

# Check scraper status
curl http://localhost:8888/api/scraper-status

# Check data freshness
curl http://localhost:8888/api/status
```

### Automated Monitoring Script

Create `monitor.sh`:

```bash
#!/bin/bash

API_URL="http://localhost:8888"
ALERT_EMAIL="admin@example.com"

# Check health
if ! curl -sf "$API_URL/health" > /dev/null; then
    echo "API is down!" | mail -s "Arrahmah API Alert" $ALERT_EMAIL
    exit 1
fi

# Check scraper status
status=$(curl -sf "$API_URL/api/scraper-status" | jq -r '.isRunning')
last_success=$(curl -sf "$API_URL/api/scraper-status" | jq -r '.lastSuccessTime')

# Alert if no successful scrape in 6 hours
six_hours_ago=$(date -u -d '6 hours ago' +%s)
last_success_timestamp=$(date -u -d "$last_success" +%s)

if [ $last_success_timestamp -lt $six_hours_ago ]; then
    echo "No successful scrape in 6 hours!" | mail -s "Arrahmah Scraper Alert" $ALERT_EMAIL
fi
```

### Log Rotation

Set up log rotation to prevent disk space issues:

Create `/etc/logrotate.d/arrahmah-api`:

```
/path/to/scraper-nodejs/logs/*.log {
    daily
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 your-username your-username
    sharedscripts
    postrotate
        pm2 reloadLogs
    endscript
}
```

## Reverse Proxy (Nginx)

Set up Nginx as a reverse proxy for better security and SSL support.

### Install Nginx
```bash
sudo apt install nginx  # Ubuntu/Debian
sudo yum install nginx  # CentOS/RHEL
```

### Configure Nginx
Create `/etc/nginx/sites-available/arrahmah-api`:

```nginx
server {
    listen 80;
    server_name api.yourdomain.com;

    location / {
        proxy_pass http://localhost:8888;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

### Enable Site
```bash
sudo ln -s /etc/nginx/sites-available/arrahmah-api /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### SSL with Let's Encrypt
```bash
# Install certbot
sudo apt install certbot python3-certbot-nginx

# Get certificate
sudo certbot --nginx -d api.yourdomain.com

# Auto-renewal is set up automatically
```

## Performance Optimization

### Memory Limits
Monitor and set memory limits to prevent crashes:

```bash
# With PM2
pm2 start npm --name "arrahmah-api" --max-memory-restart 500M -- run api

# With Node directly
node --max-old-space-size=512 dist/api/server.js
```

### CPU/Resource Monitoring
```bash
# With PM2
pm2 monit

# System resources
htop
```

## Backup Strategy

### Data Backup
```bash
#!/bin/bash
# backup-data.sh

BACKUP_DIR="/backups/arrahmah"
DATA_FILE="/path/to/scraper-nodejs/data/scraped_data.json"
DATE=$(date +%Y%m%d_%H%M%S)

# Create backup directory
mkdir -p $BACKUP_DIR

# Backup data file
cp $DATA_FILE "$BACKUP_DIR/scraped_data_$DATE.json"

# Keep only last 30 days of backups
find $BACKUP_DIR -name "scraped_data_*.json" -mtime +30 -delete
```

Add to crontab:
```bash
# Backup every 6 hours
0 */6 * * * /path/to/backup-data.sh
```

## Troubleshooting

### Server Won't Start
```bash
# Check if port is in use
lsof -i :8888

# Check permissions
ls -la data/

# Check logs
pm2 logs arrahmah-api
```

### Scraper Failures
```bash
# Check scraper status
curl http://localhost:8888/api/scraper-status

# Manually trigger scrape
curl -X POST http://localhost:8888/api/trigger-scrape

# Check website accessibility
curl -I https://arrahmah.org
```

### High Memory Usage
```bash
# Restart the service
pm2 restart arrahmah-api

# Or with systemd
sudo systemctl restart arrahmah-api
```

## Security Checklist

- [ ] Run as non-root user
- [ ] Set up firewall (only expose necessary ports)
- [ ] Use HTTPS/SSL in production
- [ ] Keep dependencies updated: `npm audit`
- [ ] Set up rate limiting on API endpoints
- [ ] Restrict access to `/api/trigger-scrape` endpoint
- [ ] Enable CORS only for trusted domains
- [ ] Set up monitoring and alerts
- [ ] Regular backups of data
- [ ] Log rotation configured

## Maintenance

### Regular Updates
```bash
# Update dependencies
npm update

# Rebuild
npm run build

# Restart
pm2 restart arrahmah-api
```

### Clean Up Old Data
```bash
# If data directory gets too large
cd data
gzip scraped_data_old.json
mv scraped_data_old.json.gz archives/
```

## Support and Monitoring

### Useful Commands
```bash
# View real-time logs
pm2 logs arrahmah-api --lines 100

# Monitor system resources
pm2 monit

# Check scraper status
watch -n 60 'curl -s http://localhost:8888/api/scraper-status | jq'
```

### Dashboard Setup
Consider setting up PM2 Plus for advanced monitoring:
```bash
pm2 link [secret-key] [public-key]
```

## Conclusion

With this production setup, your Arrahmah API will:
- ✅ Auto-start on system boot
- ✅ Auto-restart on crashes
- ✅ Automatically scrape every 2 hours
- ✅ Handle failures gracefully with retries
- ✅ Maintain logs for debugging
- ✅ Serve fresh data reliably
