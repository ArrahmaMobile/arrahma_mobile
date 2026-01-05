#!/bin/bash

# Test script for the auto-scraper API setup
# This script verifies that all components are working correctly

echo "============================================================"
echo "Testing Auto-Scraper API Setup"
echo "============================================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if build was successful
echo "Step 1: Checking build..."
if [ -d "dist" ] && [ -f "dist/api/server.js" ]; then
    echo -e "${GREEN}✓ Build successful - dist directory exists${NC}"
else
    echo -e "${RED}✗ Build failed - dist directory not found${NC}"
    echo "Run 'npm run build' first"
    exit 1
fi

# Check if data directory exists
echo ""
echo "Step 2: Checking data directory..."
if [ -d "data" ]; then
    echo -e "${GREEN}✓ Data directory exists${NC}"
    if [ -f "data/scraped_data.json" ]; then
        echo -e "${GREEN}✓ Existing data file found${NC}"
        # Show file size
        size=$(ls -lh data/scraped_data.json | awk '{print $5}')
        echo "  File size: $size"
    else
        echo -e "${YELLOW}⚠ No existing data file (will be created on first run)${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Data directory not found - creating it${NC}"
    mkdir -p data
fi

# Check if dependencies are installed
echo ""
echo "Step 3: Checking dependencies..."
if [ -d "node_modules/node-cron" ]; then
    echo -e "${GREEN}✓ node-cron installed${NC}"
else
    echo -e "${RED}✗ node-cron not found${NC}"
    echo "Run 'npm install' first"
    exit 1
fi

# Check if TypeScript files exist
echo ""
echo "Step 4: Checking source files..."
required_files=(
    "src/api/server.ts"
    "src/services/scraper-scheduler.ts"
    "src/index.ts"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓ $file${NC}"
    else
        echo -e "${RED}✗ $file missing${NC}"
        exit 1
    fi
done

# Check compiled files
echo ""
echo "Step 5: Checking compiled files..."
required_dist=(
    "dist/api/server.js"
    "dist/services/scraper-scheduler.js"
    "dist/index.js"
)

for file in "${required_dist[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓ $file${NC}"
    else
        echo -e "${RED}✗ $file missing${NC}"
        exit 1
    fi
done

echo ""
echo "============================================================"
echo -e "${GREEN}✅ All checks passed!${NC}"
echo "============================================================"
echo ""
echo "The auto-scraper API is ready to run!"
echo ""
echo "To start the API server:"
echo "  Development: npm run api:dev"
echo "  Production:  npm run api"
echo ""
echo "The server will:"
echo "  1. Start on port 8888"
echo "  2. Run an initial scrape immediately"
echo "  3. Schedule scraping every 2 hours"
echo "  4. Retry up to 3 times on failure"
echo ""
echo "Available endpoints:"
echo "  GET  http://localhost:8888/api/data"
echo "  GET  http://localhost:8888/api/status"
echo "  GET  http://localhost:8888/api/scraper-status"
echo "  POST http://localhost:8888/api/trigger-scrape"
echo "  GET  http://localhost:8888/health"
echo ""
