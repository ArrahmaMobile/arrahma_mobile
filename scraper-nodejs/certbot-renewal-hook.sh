#!/bin/bash
#############################################################################
# Certbot Post-Renewal Hook for Arrahmah API
#
# This script is executed after certbot successfully renews SSL certificates.
# It ensures that services reload to use the new certificates.
#
# Installation:
#   1. Copy this script to: /etc/letsencrypt/renewal-hooks/post/arrahmah-reload.sh
#   2. Make it executable: sudo chmod +x /etc/letsencrypt/renewal-hooks/post/arrahmah-reload.sh
#
# The script will run automatically when certbot renews certificates.
# You can test certificate renewal with:
#   sudo certbot renew --dry-run
#
#############################################################################

set -e

# Log file for debugging
LOG_FILE="/var/log/arrahmah-cert-renewal.log"

# Function to log messages
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log_message "========================================"
log_message "Certificate Renewal Hook Triggered"
log_message "========================================"

# 1. Test Nginx configuration before reloading
log_message "Testing Nginx configuration..."
if sudo nginx -t 2>&1 | tee -a "$LOG_FILE"; then
    log_message "✓ Nginx configuration is valid"
else
    log_message "✗ ERROR: Nginx configuration test failed!"
    log_message "Skipping Nginx reload to prevent downtime"
    exit 1
fi

# 2. Reload Nginx to use new certificates
log_message "Reloading Nginx to use new certificates..."
if sudo systemctl reload nginx; then
    log_message "✓ Nginx reloaded successfully"
else
    log_message "✗ ERROR: Failed to reload Nginx"
    exit 1
fi

# 3. Optional: Restart PM2 application if needed
# Uncomment the following lines if you want to restart the API server
# log_message "Restarting PM2 application..."
# if pm2 restart arrahmah-api; then
#     log_message "✓ PM2 application restarted successfully"
# else
#     log_message "⚠ Warning: Failed to restart PM2 application"
# fi

# 4. Verify HTTPS is working
log_message "Verifying HTTPS connectivity..."
sleep 2  # Give services time to stabilize

# Try to connect to the API via HTTPS (update with your domain)
DOMAIN="${RENEWED_DOMAINS:-localhost}"
if curl -sf "https://$DOMAIN/health" > /dev/null 2>&1; then
    log_message "✓ HTTPS health check passed for: $DOMAIN"
else
    log_message "⚠ Warning: HTTPS health check failed for: $DOMAIN"
    log_message "This might be normal if the domain is not accessible from this server"
fi

# 5. Send notification (optional - configure email/webhook)
# Uncomment and configure if you want notifications
# log_message "Sending notification..."
# echo "SSL certificates renewed for: $RENEWED_DOMAINS" | \
#     mail -s "Arrahmah API - SSL Certificates Renewed" admin@example.com

log_message "========================================"
log_message "Certificate renewal hook completed"
log_message "Renewed domains: ${RENEWED_DOMAINS:-unknown}"
log_message "========================================"
log_message ""

exit 0
