#!/bin/bash

#############################################################################
# Deploy to GCP VM from Local Machine
#
# This script deploys to your GCP VM without needing to SSH manually.
# It uses gcloud compute ssh to execute commands remotely.
#
# Usage:
#   ./deploy-from-local.sh
#
# Prerequisites:
#   - gcloud CLI installed and configured
#   - VM name: arrahmah-api
#   - Access to GCP project with the VM
#
# Configuration:
#   Set these environment variables to customize:
#   - GCP_VM_NAME (default: arrahmah-api)
#   - GCP_ZONE (default: us-central1-a)
#   - GCP_PROJECT (optional, uses current project)
#   - REPO_PATH (default: ~/arrahma_mobile/scraper-nodejs)
#   - BRANCH (default: feat/update-api)
#############################################################################

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Cleanup function to restore gcloud config
cleanup() {
    local exit_code=$?

    if [ "$NEEDS_ACCOUNT_RESTORE" = true ] && [ -n "$ORIGINAL_ACCOUNT" ]; then
        echo ""
        echo -e "${YELLOW}Restoring original account: $ORIGINAL_ACCOUNT${NC}"
        gcloud config set account "$ORIGINAL_ACCOUNT" 2>/dev/null || true
    fi

    if [ "$NEEDS_PROJECT_RESTORE" = true ] && [ -n "$ORIGINAL_PROJECT" ]; then
        echo -e "${YELLOW}Restoring original project: $ORIGINAL_PROJECT${NC}"
        gcloud config set project "$ORIGINAL_PROJECT" 2>/dev/null || true
    fi

    exit $exit_code
}

# Set trap to restore config on exit (including errors)
trap cleanup EXIT INT TERM

# Configuration
VM_NAME="${GCP_VM_NAME:-arrahmah-api}"
ZONE="${GCP_ZONE:-us-central1-c}"
PROJECT="${GCP_PROJECT:-arrahmah-islamic-institute}"
ACCOUNT="${GCP_ACCOUNT:-tehtech1337@gmail.com}"
REPO_PATH="${REPO_PATH:-~/arrahmah-scraper/scraper-nodejs}"
BRANCH="${BRANCH:-feat/update-api}"
PM2_APP_NAME="${PM2_APP_NAME:-arrahmah-api}"

echo ""
echo "============================================================"
echo "  🚀 Deploying Arrahmah API to GCP VM (Remote)"
echo "============================================================"
echo ""
echo "Configuration:"
echo "  VM Name: $VM_NAME"
echo "  Zone: $ZONE"
echo "  Project: $PROJECT"
echo "  Account: $ACCOUNT"
echo "  Repository Path: $REPO_PATH"
echo "  Branch: $BRANCH"
echo "  PM2 App Name: $PM2_APP_NAME"
echo ""
echo "============================================================"
echo ""

# Step -1: Configure gcloud account and project
echo -e "${BLUE}Configuring gcloud authentication...${NC}"
echo "------------------------------------------------------------"

# Save current account and project to restore later
ORIGINAL_ACCOUNT=$(gcloud config get-value account 2>/dev/null)
ORIGINAL_PROJECT=$(gcloud config get-value project 2>/dev/null)

echo "Current gcloud account: ${ORIGINAL_ACCOUNT:-none}"
echo "Current gcloud project: ${ORIGINAL_PROJECT:-none}"
echo ""

# Check if we need to switch account
NEEDS_ACCOUNT_RESTORE=false
if [ "$ORIGINAL_ACCOUNT" != "$ACCOUNT" ]; then
    echo -e "${YELLOW}⚠ Switching to personal account: $ACCOUNT${NC}"
    NEEDS_ACCOUNT_RESTORE=true

    # List available accounts
    AVAILABLE_ACCOUNTS=$(gcloud auth list --format="value(account)")

    if echo "$AVAILABLE_ACCOUNTS" | grep -q "^$ACCOUNT$"; then
        echo "Account found in authenticated accounts, switching..."
        gcloud config set account "$ACCOUNT"
    else
        echo -e "${RED}Account $ACCOUNT is not authenticated.${NC}"
        echo "Please run: gcloud auth login $ACCOUNT"
        exit 1
    fi
else
    echo -e "${GREEN}✓ Using correct account: $ACCOUNT${NC}"
fi

# Set the correct project
NEEDS_PROJECT_RESTORE=false
if [ "$ORIGINAL_PROJECT" != "$PROJECT" ]; then
    echo "Setting project to: $PROJECT"
    NEEDS_PROJECT_RESTORE=true
    gcloud config set project "$PROJECT"
else
    echo -e "${GREEN}✓ Using correct project: $PROJECT${NC}"
fi

echo ""
echo "GCloud Configuration Set:"
echo "  Account: $(gcloud config get-value account)"
echo "  Project: $(gcloud config get-value project)"
echo ""

# Build gcloud command prefix
GCLOUD_CMD="gcloud compute ssh $VM_NAME --zone=$ZONE --project=$PROJECT"

# Function to run command on VM
run_on_vm() {
    local description=$1
    local command=$2

    echo -e "${CYAN}▶ $description${NC}"
    if $GCLOUD_CMD --command="$command"; then
        echo -e "${GREEN}✓ Success${NC}"
        return 0
    else
        echo -e "${RED}✗ Failed${NC}"
        return 1
    fi
}

# Function to run command and capture output
run_and_capture() {
    local command=$1
    $GCLOUD_CMD --command="$command" 2>/dev/null
}

# Step 0: Verify VM is accessible
echo -e "${BLUE}Step 0/7: Verifying VM accessibility...${NC}"
echo "------------------------------------------------------------"

if run_on_vm "Checking VM connection" "echo 'VM is accessible'"; then
    echo ""
else
    echo -e "${RED}Cannot connect to VM. Please check:${NC}"
    echo "  1. VM name is correct: $VM_NAME"
    echo "  2. Zone is correct: $ZONE"
    echo "  3. You have access to the VM"
    echo "  4. gcloud is configured: gcloud auth list"
    exit 1
fi

# Step 1: Git Pull
echo -e "${BLUE}Step 1/7: Pulling latest code from git...${NC}"
echo "------------------------------------------------------------"

GIT_COMMANDS="cd $REPO_PATH && \
    echo 'Current directory:' && pwd && \
    echo 'Current branch:' && git branch --show-current && \
    echo 'Stashing local changes...' && \
    git stash && \
    echo 'Pulling latest changes...' && \
    git pull origin $BRANCH"

if run_on_vm "Git pull" "$GIT_COMMANDS"; then
    echo ""
else
    echo -e "${YELLOW}⚠ Git pull failed. Continuing anyway...${NC}"
    echo ""
fi

# Step 2: Install Dependencies
echo -e "${BLUE}Step 2/7: Installing/updating dependencies...${NC}"
echo "------------------------------------------------------------"

if run_on_vm "Installing dependencies" "cd $REPO_PATH && npm install"; then
    echo ""
else
    echo -e "${RED}Failed to install dependencies${NC}"
    exit 1
fi

# Step 3: Build TypeScript
echo -e "${BLUE}Step 3/7: Building TypeScript project...${NC}"
echo "------------------------------------------------------------"

if run_on_vm "Building project" "cd $REPO_PATH && npm run build"; then
    echo ""
else
    echo -e "${RED}Build failed${NC}"
    exit 1
fi

# Step 4: Check PM2 Status
echo -e "${BLUE}Step 4/7: Checking PM2 status...${NC}"
echo "------------------------------------------------------------"

PM2_STATUS=$(run_and_capture "pm2 list | grep -q '$PM2_APP_NAME' && echo 'exists' || echo 'not_found'")

if [ "$PM2_STATUS" = "exists" ]; then
    echo "PM2 app '$PM2_APP_NAME' found"
    run_and_capture "pm2 describe $PM2_APP_NAME --no-color" || true
else
    echo -e "${YELLOW}⚠ PM2 app '$PM2_APP_NAME' not found${NC}"
    echo "Starting app with PM2..."
    run_on_vm "Starting PM2 app" "cd $REPO_PATH && pm2 start npm --name '$PM2_APP_NAME' -- run api && pm2 save"
fi

echo ""

# Step 5: Restart PM2 Server
echo -e "${BLUE}Step 5/7: Restarting PM2 server...${NC}"
echo "------------------------------------------------------------"

RESTART_COMMANDS="pm2 stop $PM2_APP_NAME && \
    sleep 2 && \
    pm2 start $PM2_APP_NAME && \
    sleep 5"

if run_on_vm "Restarting server" "$RESTART_COMMANDS"; then
    echo ""
else
    echo -e "${RED}Failed to restart server${NC}"
    exit 1
fi

# Step 6: Verify Server Status
echo -e "${BLUE}Step 6/7: Verifying server status...${NC}"
echo "------------------------------------------------------------"

echo "PM2 Status:"
run_and_capture "pm2 status $PM2_APP_NAME --no-color" || true

echo ""
echo "Recent logs:"
run_and_capture "pm2 logs $PM2_APP_NAME --lines 20 --nostream --no-color" || true

echo ""

# Step 7: Verify Endpoints
echo -e "${BLUE}Step 7/7: Verifying API endpoints...${NC}"
echo "------------------------------------------------------------"

# Wait for server to be fully ready
echo "Waiting for server to be ready..."
sleep 5

FAILED=0
API_URL="http://localhost:8888"

# Test health endpoint
echo -n "Testing /health endpoint... "
HEALTH_CHECK=$(run_and_capture "curl -sf $API_URL/health" || echo "failed")
if [ "$HEALTH_CHECK" != "failed" ]; then
    echo -e "${GREEN}✓ OK${NC}"
else
    echo -e "${RED}✗ FAILED${NC}"
    FAILED=1
fi

# Test status endpoint
echo -n "Testing /api/status endpoint... "
STATUS_CHECK=$(run_and_capture "curl -sf $API_URL/api/status" || echo "failed")
if [ "$STATUS_CHECK" != "failed" ]; then
    echo -e "${GREEN}✓ OK${NC}"

    # Show status details
    echo ""
    echo "Status Details:"
    run_and_capture "curl -s $API_URL/api/status | jq '{status, lastScrapedOn, lastScrapeAttemptOn, lastDataHash: (.lastDataHash[:16] + \"...\")}'" || true
else
    echo -e "${RED}✗ FAILED${NC}"
    FAILED=1
fi
echo ""

# Test scraper status endpoint
echo -n "Testing /api/scraper-status endpoint... "
SCRAPER_CHECK=$(run_and_capture "curl -sf $API_URL/api/scraper-status" || echo "failed")
if [ "$SCRAPER_CHECK" != "failed" ]; then
    echo -e "${GREEN}✓ OK${NC}"

    # Show scraper details
    echo ""
    echo "Scraper Status:"
    run_and_capture "curl -s $API_URL/api/scraper-status | jq '{isRunning, lastRunTime, lastSuccessTime, successCount, failureCount, nextScheduledRun}'" || true
else
    echo -e "${RED}✗ FAILED${NC}"
    FAILED=1
fi
echo ""

# Test data endpoint
echo -n "Testing /api/data endpoint... "
DATA_CHECK=$(run_and_capture "curl -sf $API_URL/api/data -o /dev/null && echo 'ok'" || echo "failed")
if [ "$DATA_CHECK" = "ok" ]; then
    echo -e "${GREEN}✓ OK${NC}"
else
    echo -e "${RED}✗ FAILED${NC}"
    FAILED=1
fi

echo ""
echo "============================================================"

# Restore original gcloud configuration
echo ""
echo -e "${BLUE}Restoring original gcloud configuration...${NC}"
echo "------------------------------------------------------------"

if [ "$NEEDS_ACCOUNT_RESTORE" = true ] && [ -n "$ORIGINAL_ACCOUNT" ]; then
    echo "Restoring account to: $ORIGINAL_ACCOUNT"
    gcloud config set account "$ORIGINAL_ACCOUNT"
fi

if [ "$NEEDS_PROJECT_RESTORE" = true ] && [ -n "$ORIGINAL_PROJECT" ]; then
    echo "Restoring project to: $ORIGINAL_PROJECT"
    gcloud config set project "$ORIGINAL_PROJECT"
fi

if [ "$NEEDS_ACCOUNT_RESTORE" = true ] || [ "$NEEDS_PROJECT_RESTORE" = true ]; then
    echo ""
    echo "GCloud Configuration Restored:"
    echo "  Account: $(gcloud config get-value account 2>/dev/null)"
    echo "  Project: $(gcloud config get-value project 2>/dev/null)"
    echo -e "${GREEN}✓ Configuration restored${NC}"
else
    echo "No changes needed - configuration unchanged"
fi

echo ""
echo "============================================================"

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ Deployment completed successfully!${NC}"
    echo ""
    echo "Server is running and all endpoints are responding."
    echo ""
    echo "VM Details:"
    echo "  Name: $VM_NAME"
    echo "  Zone: $ZONE"
    echo ""
    echo "To access the VM directly:"
    echo "  gcloud compute ssh $VM_NAME --zone=$ZONE --project=$PROJECT"
    echo ""
    echo "To view logs:"
    echo "  $GCLOUD_CMD --command='pm2 logs $PM2_APP_NAME'"
    echo ""
    echo "To check status:"
    echo "  $GCLOUD_CMD --command='pm2 status'"
    echo ""
    echo "API Endpoints (if externally accessible):"
    echo "  Check your VM's external IP for public access"
    echo ""
else
    echo -e "${RED}⚠ Deployment completed with errors!${NC}"
    echo ""
    echo "Some endpoints are not responding correctly."
    echo ""
    echo "To check logs, run:"
    echo "  $GCLOUD_CMD --command='pm2 logs $PM2_APP_NAME'"
    echo ""
    echo "To SSH into the VM:"
    echo "  gcloud compute ssh $VM_NAME --zone=$ZONE --project=$PROJECT"
    echo ""
    exit 1
fi

echo "============================================================"
echo ""
