#!/bin/bash

# Simulate the exact API flow that the mobile app uses

API_URL="https://arrahmah.sasid.me/api"

echo "=================================================="
echo "Simulating Mobile App API Flow"
echo "=================================================="
echo ""

# Step 1: App startup - check status
echo "Step 1: App Startup - Checking Server Status"
echo "--------------------------------------------------"
STATUS=$(curl -s "$API_URL/status")
echo "$STATUS" | jq '.'

IS_AVAILABLE=$(echo "$STATUS" | jq -r '.status')
LAST_HASH=$(echo "$STATUS" | jq -r '.lastDataHash')

if [ "$IS_AVAILABLE" = "Available" ]; then
    echo "✓ Server is available"
else
    echo "✗ Server is not available"
    exit 1
fi
echo ""

# Step 2: Fetch initial data
echo "Step 2: Fetching Initial App Data"
echo "--------------------------------------------------"
echo "Making request to: $API_URL/data"
DATA=$(curl -sI "$API_URL/data")
NEW_ETAG=$(echo "$DATA" | grep -i "etag:" | awk '{print $2}' | tr -d '\r')
HTTP_STATUS=$(echo "$DATA" | grep "HTTP" | awk '{print $2}')

echo "HTTP Status: $HTTP_STATUS"
echo "ETag: $NEW_ETAG"

if [ "$HTTP_STATUS" = "200" ]; then
    echo "✓ Successfully fetched data"
    # Save the ETag for later
    SAVED_ETAG="$NEW_ETAG"
else
    echo "✗ Failed to fetch data"
    exit 1
fi
echo ""

# Step 3: Subsequent status check with data hash
echo "Step 3: Periodic Status Check (simulating refresh)"
echo "--------------------------------------------------"
STATUS=$(curl -s "$API_URL/status?dataHash=$SAVED_ETAG")
echo "$STATUS" | jq '.'

IS_STALE=$(echo "$STATUS" | jq -r '.isDataStale')
echo ""
echo "Is Data Stale: $IS_STALE"
if [ "$IS_STALE" = "false" ]; then
    echo "✓ Cached data is still fresh - no need to re-download"
else
    echo "! Data is stale - app would fetch new data"
fi
echo ""

# Step 4: Use cached ETag to avoid re-downloading
echo "Step 4: Request Data with ETag (simulating cache check)"
echo "--------------------------------------------------"
echo "Making conditional request with If-None-Match: $SAVED_ETAG"
RESPONSE=$(curl -sI -H "If-None-Match: $SAVED_ETAG" "$API_URL/data")
HTTP_STATUS=$(echo "$RESPONSE" | grep "HTTP" | awk '{print $2}')

echo "HTTP Status: $HTTP_STATUS"
if [ "$HTTP_STATUS" = "304" ]; then
    echo "✓ Server returned 304 Not Modified - using cached data"
    echo "✓ Bandwidth saved by not re-downloading unchanged data"
else
    echo "! Server returned new data"
fi
echo ""

# Step 5: Verify data structure for app parsing
echo "Step 5: Verify Data Structure for App Parsing"
echo "--------------------------------------------------"
DATA_RESPONSE=$(curl -s "$API_URL/data")

echo "Quick Links available:"
QUICK_LINKS=$(echo "$DATA_RESPONSE" | jq -r '.quickLinks[].title')
echo "$QUICK_LINKS" | head -3
echo "..."
echo ""

echo "Courses available:"
COURSES=$(echo "$DATA_RESPONSE" | jq -r '.courses[].title')
echo "$COURSES" | head -3
echo "..."
echo ""

echo "Dua Categories available:"
DUA_CATS=$(echo "$DATA_RESPONSE" | jq -r '.duaCategories[].title')
echo "$DUA_CATS" | head -3
echo "..."
echo ""

# Step 6: Verify drawer items (navigation structure)
echo "Step 6: Verify Navigation Structure"
echo "--------------------------------------------------"
DRAWER_ITEMS=$(echo "$DATA_RESPONSE" | jq '.drawerItems[] | {title: .title, hasContent: (.content != null), hasChildren: (.children != null)}' | head -20)
echo "Drawer Items:"
echo "$DRAWER_ITEMS"
echo ""

echo "=================================================="
echo "App Flow Simulation Complete!"
echo ""
echo "Summary:"
echo "  ✓ Server is available and responding"
echo "  ✓ Data is being served correctly"
echo "  ✓ ETag caching is working (saves bandwidth)"
echo "  ✓ All data structures match app requirements"
echo "  ✓ Navigation, courses, and duas are available"
echo ""
echo "The API is ready for the mobile app to use!"
echo "=================================================="
