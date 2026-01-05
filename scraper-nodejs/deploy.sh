#!/bin/bash
# Deployment script for Arrahmah API Server
# Run this on the production server after pulling latest changes

set -e  # Exit on error

echo "================================="
echo "Arrahmah API Deployment Script"
echo "================================="
echo ""

# Navigate to project directory
cd /home/shah/arrahmah-scraper/scraper-nodejs

echo "1. Installing dependencies..."
npm install

echo ""
echo "2. Building TypeScript..."
npm run build

echo ""
echo "3. Checking if API server is running..."
if pm2 list | grep -q arrahmah-api; then
    echo "   Found PM2 process, restarting..."
    pm2 restart arrahmah-api
    pm2 save
elif systemctl is-active --quiet arrahmah-api; then
    echo "   Found systemd service, restarting..."
    sudo systemctl restart arrahmah-api
    sudo systemctl status arrahmah-api --no-pager
else
    echo "   No running service found. Starting with PM2..."
    pm2 start dist/api/server.js --name arrahmah-api
    pm2 save
fi

echo ""
echo "4. Waiting for server to start..."
sleep 3

echo ""
echo "5. Verifying deployment..."
echo "   Health check:"
curl -s http://localhost:8888/health | jq '.' || echo "   Health check failed"

echo ""
echo "   API status:"
curl -s http://localhost:8888/api/status | jq '.status, .lastScrapedOn' || echo "   Status check failed"

echo ""
echo "================================="
echo "Deployment complete!"
echo "================================="
echo ""
echo "To view logs:"
echo "  pm2 logs arrahmah-api"
echo ""
echo "To check status:"
echo "  pm2 status"
echo "  curl http://localhost:8888/health"
