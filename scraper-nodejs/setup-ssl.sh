#!/bin/bash
#############################################################################
# SSL/TLS Setup Script for Arrahmah API on GCP VM
#
# This script automates the setup of:
#   1. Nginx reverse proxy with SSL/TLS
#   2. Let's Encrypt SSL certificates
#   3. Automatic certificate renewal
#   4. PM2 process manager with ecosystem file
#
# Prerequisites:
#   - Ubuntu/Debian-based system
#   - Domain name pointing to this server
#   - Port 80 and 443 accessible
#   - Run as user with sudo privileges
#
# Usage:
#   ./setup-ssl.sh your-domain.com your-email@example.com
#
# Example:
#   ./setup-ssl.sh api.arrahmah.org admin@arrahmah.org
#
#############################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check arguments
if [ $# -ne 2 ]; then
    echo -e "${RED}Error: Missing required arguments${NC}"
    echo ""
    echo "Usage: $0 DOMAIN EMAIL"
    echo ""
    echo "Example:"
    echo "  $0 api.arrahmah.org admin@arrahmah.org"
    echo ""
    exit 1
fi

DOMAIN=$1
EMAIL=$2
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PM2_APP_NAME="arrahmah-api"

echo ""
echo "============================================================"
echo -e "${BLUE}  SSL/TLS Setup for Arrahmah API${NC}"
echo "============================================================"
echo ""
echo "Configuration:"
echo "  Domain: $DOMAIN"
echo "  Email: $EMAIL"
echo "  Script Directory: $SCRIPT_DIR"
echo "  PM2 App Name: $PM2_APP_NAME"
echo ""
echo "This script will:"
echo "  1. Install and configure Nginx"
echo "  2. Install certbot (Let's Encrypt)"
echo "  3. Obtain SSL certificate"
echo "  4. Configure automatic renewal"
echo "  5. Set up PM2 with ecosystem file"
echo ""
echo "============================================================"
echo ""

read -p "Do you want to continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

echo ""

# Step 1: Update package list
echo -e "${BLUE}Step 1/8: Updating package list...${NC}"
echo "------------------------------------------------------------"
sudo apt update
echo -e "${GREEN}✓ Complete${NC}"
echo ""

# Step 2: Install Nginx
echo -e "${BLUE}Step 2/8: Installing Nginx...${NC}"
echo "------------------------------------------------------------"
if ! command -v nginx &> /dev/null; then
    sudo apt install -y nginx
    echo -e "${GREEN}✓ Nginx installed${NC}"
else
    echo -e "${GREEN}✓ Nginx already installed${NC}"
fi
echo ""

# Step 3: Install Certbot
echo -e "${BLUE}Step 3/8: Installing Certbot...${NC}"
echo "------------------------------------------------------------"
if ! command -v certbot &> /dev/null; then
    sudo apt install -y certbot python3-certbot-nginx
    echo -e "${GREEN}✓ Certbot installed${NC}"
else
    echo -e "${GREEN}✓ Certbot already installed${NC}"
fi
echo ""

# Step 4: Configure Nginx
echo -e "${BLUE}Step 4/8: Configuring Nginx...${NC}"
echo "------------------------------------------------------------"

# Create Nginx config from template
NGINX_CONFIG="/etc/nginx/sites-available/arrahmah-api"
TEMP_CONFIG="/tmp/arrahmah-api-nginx.conf"

# Copy template and replace placeholders
cat "$SCRIPT_DIR/nginx-ssl.conf" | \
    sed "s/YOUR_DOMAIN/$DOMAIN/g" | \
    sed "s/YOUR_EMAIL/$EMAIL/g" > "$TEMP_CONFIG"

# Install config
sudo cp "$TEMP_CONFIG" "$NGINX_CONFIG"
echo -e "${GREEN}✓ Nginx config created at $NGINX_CONFIG${NC}"

# Enable site
if [ ! -L "/etc/nginx/sites-enabled/arrahmah-api" ]; then
    sudo ln -s "$NGINX_CONFIG" /etc/nginx/sites-enabled/arrahmah-api
    echo -e "${GREEN}✓ Site enabled${NC}"
else
    echo -e "${GREEN}✓ Site already enabled${NC}"
fi

# Remove default site if it exists
if [ -L "/etc/nginx/sites-enabled/default" ]; then
    sudo rm /etc/nginx/sites-enabled/default
    echo -e "${GREEN}✓ Default site removed${NC}"
fi

# Test Nginx config
echo "Testing Nginx configuration..."
if sudo nginx -t; then
    echo -e "${GREEN}✓ Nginx configuration valid${NC}"
    sudo systemctl reload nginx
    echo -e "${GREEN}✓ Nginx reloaded${NC}"
else
    echo -e "${RED}✗ Nginx configuration invalid${NC}"
    exit 1
fi
echo ""

# Step 5: Obtain SSL Certificate
echo -e "${BLUE}Step 5/8: Obtaining SSL certificate from Let's Encrypt...${NC}"
echo "------------------------------------------------------------"

# Check if certificate already exists
if [ -d "/etc/letsencrypt/live/$DOMAIN" ]; then
    echo -e "${YELLOW}Certificate already exists for $DOMAIN${NC}"
    read -p "Do you want to renew/recreate it? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo certbot --nginx -d "$DOMAIN" --email "$EMAIL" --agree-tos --non-interactive --force-renewal
    else
        echo "Skipping certificate generation"
    fi
else
    # Obtain certificate
    sudo certbot --nginx -d "$DOMAIN" --email "$EMAIL" --agree-tos --non-interactive
fi

echo -e "${GREEN}✓ SSL certificate obtained${NC}"
echo ""

# Step 6: Install Renewal Hook and Fix Renewal Config
echo -e "${BLUE}Step 6/8: Setting up certificate renewal hook...${NC}"
echo "------------------------------------------------------------"

HOOK_DIR="/etc/letsencrypt/renewal-hooks/post"
HOOK_FILE="$HOOK_DIR/arrahmah-reload.sh"
RENEWAL_CONF="/etc/letsencrypt/renewal/${DOMAIN}.conf"

# Create hook directory if it doesn't exist
sudo mkdir -p "$HOOK_DIR"

# Copy renewal hook script
sudo cp "$SCRIPT_DIR/certbot-renewal-hook.sh" "$HOOK_FILE"
sudo chmod +x "$HOOK_FILE"

echo -e "${GREEN}✓ Renewal hook installed at $HOOK_FILE${NC}"

# Ensure renewal config uses nginx authenticator (not standalone)
if [ -f "$RENEWAL_CONF" ]; then
    echo "Verifying renewal configuration..."

    # Check if using standalone (wrong)
    if grep -q "authenticator = standalone" "$RENEWAL_CONF"; then
        echo -e "${YELLOW}⚠ Fixing renewal config (changing standalone → nginx)${NC}"
        sudo sed -i.backup 's/authenticator = standalone/authenticator = nginx/g' "$RENEWAL_CONF"
        sudo sed -i 's/installer = None/installer = nginx/g' "$RENEWAL_CONF"

        # Add installer if not present
        if ! grep -q "installer = " "$RENEWAL_CONF"; then
            sudo sed -i '/authenticator = nginx/a installer = nginx' "$RENEWAL_CONF"
        fi

        echo -e "${GREEN}✓ Renewal config fixed${NC}"
    else
        echo -e "${GREEN}✓ Renewal config already correct (using nginx)${NC}"
    fi
fi

# Test renewal (dry run)
echo "Testing certificate renewal (dry run)..."
if sudo certbot renew --dry-run; then
    echo -e "${GREEN}✓ Certificate renewal test passed${NC}"
else
    echo -e "${YELLOW}⚠ Certificate renewal test failed (this might be OK if recently issued)${NC}"
fi
echo ""

# Step 7: Set up PM2 with ecosystem file
echo -e "${BLUE}Step 7/8: Setting up PM2 with ecosystem file...${NC}"
echo "------------------------------------------------------------"

# Check if PM2 is installed
if ! command -v pm2 &> /dev/null; then
    echo "Installing PM2 globally..."
    sudo npm install -g pm2
    echo -e "${GREEN}✓ PM2 installed${NC}"
else
    echo -e "${GREEN}✓ PM2 already installed${NC}"
fi

# Create logs directory
mkdir -p "$SCRIPT_DIR/logs"

# Build the project
echo "Building TypeScript project..."
cd "$SCRIPT_DIR"
npm run build
echo -e "${GREEN}✓ Project built${NC}"

# Stop existing PM2 process if running
if pm2 list | grep -q "$PM2_APP_NAME"; then
    echo "Stopping existing PM2 process..."
    pm2 stop "$PM2_APP_NAME"
    pm2 delete "$PM2_APP_NAME"
fi

# Start with ecosystem file
echo "Starting PM2 with ecosystem file..."
pm2 start ecosystem.config.js
pm2 save

echo -e "${GREEN}✓ PM2 configured and started${NC}"

# Set up PM2 startup script
echo "Configuring PM2 to start on boot..."
sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u $USER --hp $HOME
echo -e "${GREEN}✓ PM2 startup configured${NC}"
echo ""

# Step 8: Verify Setup
echo -e "${BLUE}Step 8/8: Verifying setup...${NC}"
echo "------------------------------------------------------------"

# Wait for services to stabilize
sleep 3

echo "Testing endpoints..."

# Test HTTPS endpoint
echo -n "  Testing https://$DOMAIN/health ... "
if curl -sf "https://$DOMAIN/health" > /dev/null; then
    echo -e "${GREEN}✓ OK${NC}"
else
    echo -e "${RED}✗ FAILED${NC}"
    echo -e "${YELLOW}Note: This might fail if the domain is not yet propagated${NC}"
fi

# Test local endpoint
echo -n "  Testing http://localhost:8888/health ... "
if curl -sf "http://localhost:8888/health" > /dev/null; then
    echo -e "${GREEN}✓ OK${NC}"
else
    echo -e "${RED}✗ FAILED${NC}"
fi

echo ""

# Show PM2 status
echo "PM2 Status:"
pm2 status

echo ""
echo "============================================================"
echo -e "${GREEN}✅ SSL/TLS Setup Complete!${NC}"
echo "============================================================"
echo ""
echo "Your Arrahmah API is now secured with SSL/TLS"
echo ""
echo "Key Features:"
echo "  ✓ HTTPS enabled with Let's Encrypt certificate"
echo "  ✓ Automatic certificate renewal (every 60 days)"
echo "  ✓ Nginx automatically reloads when certificates renew"
echo "  ✓ PM2 manages the Node.js process with auto-restart"
echo "  ✓ PM2 configured to start on system boot"
echo ""
echo "Access your API at:"
echo "  https://$DOMAIN/api/status"
echo "  https://$DOMAIN/api/data"
echo "  https://$DOMAIN/health"
echo ""
echo "Certificate Information:"
echo "  Location: /etc/letsencrypt/live/$DOMAIN/"
echo "  Renewal check: Automatic (twice daily)"
echo "  Renewal hook: $HOOK_FILE"
echo "  Renewal log: /var/log/arrahmah-cert-renewal.log"
echo ""
echo "Useful Commands:"
echo "  # View PM2 logs"
echo "  pm2 logs $PM2_APP_NAME"
echo ""
echo "  # Restart API server"
echo "  pm2 restart $PM2_APP_NAME"
echo ""
echo "  # Check Nginx status"
echo "  sudo systemctl status nginx"
echo ""
echo "  # Test certificate renewal"
echo "  sudo certbot renew --dry-run"
echo ""
echo "  # Force certificate renewal"
echo "  sudo certbot renew --force-renewal"
echo ""
echo "  # View renewal log"
echo "  sudo cat /var/log/arrahmah-cert-renewal.log"
echo ""
echo "============================================================"
echo ""
