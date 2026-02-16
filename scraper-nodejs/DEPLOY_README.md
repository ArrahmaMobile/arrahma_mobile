# Deploy to GCP VM - Quick Guide

## 🚀 One-Command Deployment

Simply run:

```bash
./deploy-from-local.sh
```

**That's it!** The script automatically:

✅ Detects your domain from VM configuration (`arrahmah.sasid.me`)
✅ Checks SSL certificate status
✅ Auto-renews expired certificates
✅ Deploys your latest code
✅ Restarts the server with zero downtime
✅ Verifies all endpoints

## 🔍 What Gets Auto-Detected

The script intelligently detects from your VM:

| Setting | Current Value | Source |
|---------|---------------|--------|
| **Domain** | `arrahmah.sasid.me` | Nginx configuration |
| **Email** | `tehtech1337@gmail.com` | GCP account |
| **SSL Status** | Auto-checked | certbot |

## 🎯 Zero Configuration

No environment variables needed! The deployment script:
- Auto-detects domain from existing Nginx config
- Checks if SSL certificate is valid or expired
- Automatically renews certificates when needed
- Uses your GCP email for notifications

## 💡 Override Defaults (Optional)

Only needed if you want to change from auto-detected values:

```bash
# Change domain (auto-detects arrahmah.sasid.me)
export SSL_DOMAIN="different-domain.com"

# Change email (defaults to tehtech1337@gmail.com)
export SSL_EMAIL="different-email@example.com"

# Force SSL re-setup even if valid
export SETUP_SSL="yes"  # auto|yes|no

# Deploy
./deploy-from-local.sh
```

### Other Settings (rarely needed)

```bash
export GCP_VM_NAME="arrahmah-api"
export GCP_ZONE="us-central1-c"
export GCP_PROJECT="arrahmah-islamic-institute"
export GCP_ACCOUNT="tehtech1337@gmail.com"
```

## ✅ Expected Output

```
Step 0/8: Verifying VM accessibility...
✓ Success

Detecting SSL configuration from VM...
✓ Detected domain: arrahmah.sasid.me

SSL/TLS Configuration:
  Domain: arrahmah.sasid.me
  Email: tehtech1337@gmail.com
  Mode: auto

Step 1/8: Pulling latest code from git...
Step 2/8: Installing/updating dependencies...
Step 3/8: Building TypeScript project...
Step 4/8: Checking PM2 status...
Step 5/8: Restarting PM2 server...
Step 6/8: Verifying server status...
Step 7/8: Verifying API endpoints...
✓ Testing /health endpoint... ✓ OK
✓ Testing /api/status endpoint... ✓ OK
✓ Testing /api/data endpoint... ✓ OK

Step 8/8: Setting up SSL/TLS...
Checking certificate expiration...
⚠ Certificate expired or expiring soon - will renew automatically

Running SSL setup script on VM...

✅ SSL/TLS setup completed successfully!

🔒 HTTPS Endpoints:
  https://arrahmah.sasid.me/health
  https://arrahmah.sasid.me/api/status
  https://arrahmah.sasid.me/api/data

Certificate Management:
  • Auto-renewal: Enabled (checks twice daily)
  • Renewal window: 30 days before expiration
  • Post-renewal: Nginx reloads automatically

✅ Deployment completed successfully!
```

## 🔒 SSL Certificate Auto-Renewal

After the first deployment:
- ✅ Certificates check for renewal **twice daily**
- ✅ Auto-renew **30 days before expiration**
- ✅ Nginx reloads automatically with new certs
- ✅ Zero manual intervention required

## 📞 Troubleshooting

### Domain Not Detected
If the script doesn't detect your domain:
```bash
export SSL_DOMAIN="arrahmah.sasid.me"
./deploy-from-local.sh
```

### Certificate Renewal Fails
SSH into the VM and check logs:
```bash
gcloud compute ssh arrahmah-api --zone=us-central1-c --project=arrahmah-islamic-institute
sudo cat /var/log/arrahmah-cert-renewal.log
```

### Force Fresh SSL Setup
To force certificate renewal/re-setup:
```bash
export SETUP_SSL="yes"
./deploy-from-local.sh
```

### Change Domain
To use a different domain:
```bash
export SSL_DOMAIN="new-domain.com"
export SETUP_SSL="yes"
./deploy-from-local.sh
```

### API Not Accessible
Check PM2 status and logs:
```bash
# SSH into VM
gcloud compute ssh arrahmah-api --zone=us-central1-c --project=arrahmah-islamic-institute

# Check status
pm2 status

# View logs
pm2 logs arrahmah-api
```

## 📝 Related Files

- **[deploy-from-local.sh](deploy-from-local.sh)** - Main deployment script
- **[SSL_DEPLOYMENT_GUIDE.md](SSL_DEPLOYMENT_GUIDE.md)** - Complete SSL documentation
- **[.env.deployment.example](.env.deployment.example)** - Optional config template

---

**Ready to deploy?** Just run `./deploy-from-local.sh` and you're done! 🎉
