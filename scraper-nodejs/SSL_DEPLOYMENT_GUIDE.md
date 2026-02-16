# SSL/TLS Deployment Guide for GCP VM

This guide shows you how to deploy the Arrahmah API to your GCP VM with automatic SSL/TLS certificate management.

## 🚀 Quick Start

### 1. Set Environment Variables

Before running the deployment script, set your SSL configuration:

```bash
export SSL_DOMAIN="api.yourdomain.com"      # Your domain name
export SSL_EMAIL="your-email@example.com"   # Your email for Let's Encrypt
```

Example:
```bash
export SSL_DOMAIN="api.arrahmah.org"
export SSL_EMAIL="admin@arrahmah.org"
```

### 2. Run Deployment

```bash
cd /Users/shah/Documents/repos/arrahma_mobile/scraper-nodejs
./deploy-from-local.sh
```

That's it! The script will:
- ✅ Deploy your code to the GCP VM
- ✅ Install and configure Nginx with SSL/TLS
- ✅ Obtain Let's Encrypt certificate automatically
- ✅ Set up automatic certificate renewal
- ✅ Configure post-renewal hooks
- ✅ Start your API with PM2
- ✅ Verify everything is working

## 📋 Prerequisites

### 1. Domain Configuration
- Your domain must be pointing to your GCP VM's external IP
- DNS propagation must be complete (check with `dig` or `nslookup`)

```bash
# Check DNS
dig api.arrahmah.org

# Or
nslookup api.arrahmah.org
```

### 2. GCP VM Firewall
Make sure ports 80 and 443 are open:

```bash
# List firewall rules
gcloud compute firewall-rules list --project=arrahmah-islamic-institute

# Create firewall rules if needed
gcloud compute firewall-rules create allow-http \
    --allow tcp:80 \
    --source-ranges 0.0.0.0/0 \
    --description "Allow HTTP traffic"

gcloud compute firewall-rules create allow-https \
    --allow tcp:443 \
    --source-ranges 0.0.0.0/0 \
    --description "Allow HTTPS traffic"
```

### 3. VM Requirements
- Ubuntu/Debian-based system
- Sudo access for the user
- Enough disk space for certificates (~10MB)

## 🔧 Configuration Options

### Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `SSL_DOMAIN` | Yes | - | Your domain name (e.g., api.arrahmah.org) |
| `SSL_EMAIL` | Yes | - | Email for Let's Encrypt notifications |
| `SETUP_SSL` | No | `auto` | SSL setup mode: `auto`, `yes`, or `no` |
| `GCP_VM_NAME` | No | `arrahmah-api` | GCP VM instance name |
| `GCP_ZONE` | No | `us-central1-c` | GCP zone |
| `GCP_PROJECT` | No | `arrahmah-islamic-institute` | GCP project ID |
| `REPO_PATH` | No | `~/arrahmah-scraper/scraper-nodejs` | Path on VM |

### SSL Setup Modes

- **`auto` (default)**: Sets up SSL only if certificate doesn't exist
- **`yes`**: Always runs SSL setup (useful for renewal/updates)
- **`no`**: Skips SSL setup entirely (HTTP only)

Examples:
```bash
# Auto mode (default) - setup SSL only if not already configured
export SETUP_SSL="auto"

# Force SSL setup even if certificate exists
export SETUP_SSL="yes"

# Skip SSL setup (HTTP only)
export SETUP_SSL="no"
```

## 🔒 What Gets Set Up

### 1. Nginx Configuration
- Reverse proxy on ports 80 and 443
- HTTP to HTTPS redirect
- Modern TLS 1.2/1.3 configuration
- Security headers
- SSL session caching
- OCSP stapling

**Location**: `/etc/nginx/sites-available/arrahmah-api`

### 2. SSL Certificates
- Let's Encrypt SSL/TLS certificates
- 90-day validity
- Auto-renewal 30 days before expiration
- Renewal checks run twice daily

**Location**: `/etc/letsencrypt/live/YOUR_DOMAIN/`

### 3. Renewal Hook
- Automatically runs after certificate renewal
- Tests Nginx configuration
- Reloads Nginx with new certificates
- Verifies HTTPS connectivity
- Logs all actions

**Location**: `/etc/letsencrypt/renewal-hooks/post/arrahmah-reload.sh`

### 4. PM2 Process Manager
- Manages Node.js application
- Auto-restart on crashes
- Starts on system boot
- Memory limits and monitoring

**Configuration**: `ecosystem.config.js`

## 📊 Monitoring & Maintenance

### Check Certificate Status

```bash
# SSH into the VM
gcloud compute ssh arrahmah-api --zone=us-central1-c --project=arrahmah-islamic-institute

# Check certificate expiration
sudo certbot certificates

# View renewal log
sudo cat /var/log/arrahmah-cert-renewal.log

# Test renewal (dry run)
sudo certbot renew --dry-run
```

### Check Server Status

```bash
# PM2 status
pm2 status

# View logs
pm2 logs arrahmah-api

# Nginx status
sudo systemctl status nginx

# Test HTTPS endpoint
curl https://api.arrahmah.org/health
```

### Force Certificate Renewal

If you need to renew certificates immediately:

```bash
# SSH into VM
gcloud compute ssh arrahmah-api --zone=us-central1-c --project=arrahmah-islamic-institute

# Force renewal
sudo certbot renew --force-renewal
```

## 🔄 Deployment Workflow

### First-Time Deployment with SSL

```bash
# 1. Set environment variables
export SSL_DOMAIN="api.arrahmah.org"
export SSL_EMAIL="admin@arrahmah.org"

# 2. Deploy
cd /Users/shah/Documents/repos/arrahma_mobile/scraper-nodejs
./deploy-from-local.sh

# The script will:
# - Deploy code
# - Install Nginx
# - Install certbot
# - Obtain SSL certificate
# - Configure auto-renewal
# - Start the API
```

### Subsequent Deployments

```bash
# Just run the deployment script
./deploy-from-local.sh

# SSL is already configured, so it will:
# - Update code
# - Restart the API
# - Skip SSL setup (already done)
```

### Re-running SSL Setup

If you need to reconfigure SSL:

```bash
export SSL_DOMAIN="api.arrahmah.org"
export SSL_EMAIL="admin@arrahmah.org"
export SETUP_SSL="yes"  # Force SSL setup

./deploy-from-local.sh
```

## 🚨 Troubleshooting

### Certificate Not Obtained

**Problem**: Let's Encrypt can't verify domain ownership

**Solutions**:
1. Verify DNS is pointing to VM external IP
2. Check firewall allows port 80 and 443
3. Ensure domain is accessible from internet
4. Check Nginx is running: `sudo systemctl status nginx`

### HTTPS Not Working

**Problem**: Can't access `https://your-domain.com`

**Solutions**:
1. Check certificate exists: `sudo ls -la /etc/letsencrypt/live/`
2. Verify Nginx config: `sudo nginx -t`
3. Check Nginx is running: `sudo systemctl status nginx`
4. View Nginx error logs: `sudo tail -f /var/log/nginx/error.log`

### Certificate Renewal Fails

**Problem**: Automatic renewal not working

**Solutions**:
1. Check renewal log: `sudo cat /var/log/arrahmah-cert-renewal.log`
2. Test renewal: `sudo certbot renew --dry-run`
3. Check certbot timer: `sudo systemctl status certbot.timer`
4. Manually renew: `sudo certbot renew --force-renewal`

## 📝 Files Reference

| File | Purpose |
|------|---------|
| `deploy-from-local.sh` | Main deployment script with SSL integration |
| `setup-ssl.sh` | Standalone SSL setup script (runs on VM) |
| `certbot-renewal-hook.sh` | Post-renewal hook for certificate updates |
| `nginx-ssl.conf` | Nginx configuration template |
| `ecosystem.config.js` | PM2 process manager configuration |

## 🎯 Complete Example

```bash
# From your local machine

# 1. Configure SSL
export SSL_DOMAIN="api.arrahmah.org"
export SSL_EMAIL="admin@arrahmah.org"

# 2. Deploy
cd /Users/shah/Documents/repos/arrahma_mobile/scraper-nodejs
./deploy-from-local.sh

# 3. Wait for completion (3-5 minutes)

# 4. Access your API
curl https://api.arrahmah.org/health
curl https://api.arrahmah.org/api/status
curl https://api.arrahmah.org/api/data

# 5. Verify certificate
echo | openssl s_client -connect api.arrahmah.org:443 -servername api.arrahmah.org 2>/dev/null | openssl x509 -noout -dates
```

## ✅ Success Indicators

After successful deployment, you should see:

1. ✅ "Deployment completed successfully!" message
2. ✅ "SSL/TLS setup completed successfully!" message
3. ✅ All endpoint tests passing
4. ✅ HTTPS endpoint responding
5. ✅ PM2 showing process as "online"
6. ✅ Certificate shown with 90-day expiration

## 🔐 Security Best Practices

1. **Keep certificates up to date**: Auto-renewal handles this
2. **Monitor renewal logs**: Check `/var/log/arrahmah-cert-renewal.log` monthly
3. **Use strong TLS settings**: Already configured in `nginx-ssl.conf`
4. **Enable HSTS**: Uncomment HSTS header in Nginx config after testing
5. **Regular updates**: Run `sudo apt update && sudo apt upgrade` monthly
6. **Monitor expiration**: Certificates expire in 90 days, renew at 30 days

## 📞 Support

If you encounter issues:

1. Check the logs: `pm2 logs arrahmah-api`
2. Check Nginx logs: `sudo tail -f /var/log/nginx/error.log`
3. Check renewal log: `sudo cat /var/log/arrahmah-cert-renewal.log`
4. SSH into VM for manual inspection
5. Review this guide's troubleshooting section

---

**Note**: This setup provides production-grade SSL/TLS with automatic renewal. Once configured, certificates will renew automatically and Nginx will reload seamlessly without any manual intervention.
