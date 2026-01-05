#!/bin/bash

# Arrahmah API Test Script
# Tests all API endpoints to verify they work correctly with the mobile app

API_URL="https://arrahmah.sasid.me/api"

echo "=================================================="
echo "Testing Arrahmah API Endpoints"
echo "API URL: $API_URL"
echo "=================================================="
echo ""

# Test 1: Status Endpoint
echo "Test 1: GET /api/status"
echo "--------------------------------------------------"
STATUS_RESPONSE=$(curl -s "$API_URL/status")
echo "$STATUS_RESPONSE" | jq '.'
echo ""

# Verify status response has required fields
echo "Verifying status response structure..."
echo "$STATUS_RESPONSE" | jq -e '.status' > /dev/null && echo "✓ Has 'status' field" || echo "✗ Missing 'status' field"
echo "$STATUS_RESPONSE" | jq -e '.isDataStale' > /dev/null && echo "✓ Has 'isDataStale' field" || echo "✗ Missing 'isDataStale' field"
echo "$STATUS_RESPONSE" | jq -e '.broadcastStatus' > /dev/null && echo "✓ Has 'broadcastStatus' field" || echo "✗ Missing 'broadcastStatus' field"
echo "$STATUS_RESPONSE" | jq -e '.lastScrapedOn' > /dev/null && echo "✓ Has 'lastScrapedOn' field" || echo "✗ Missing 'lastScrapedOn' field"
echo "$STATUS_RESPONSE" | jq -e '.lastDataHash' > /dev/null && echo "✓ Has 'lastDataHash' field" || echo "✗ Missing 'lastDataHash' field"
echo ""

# Extract data hash for next test
DATA_HASH=$(echo "$STATUS_RESPONSE" | jq -r '.lastDataHash')
echo "Data Hash: $DATA_HASH"
echo ""

# Test 2: Data Endpoint
echo "Test 2: GET /api/data"
echo "--------------------------------------------------"
DATA_RESPONSE=$(curl -s "$API_URL/data")
echo "Data response summary:"
echo "$DATA_RESPONSE" | jq '{
  keys: keys,
  logoUrl: .logoUrl,
  quickLinksCount: (.quickLinks | length),
  bannersCount: (.banners | length),
  broadcastItemsCount: (.broadcastItems | length),
  socialMediaItemsCount: (.socialMediaItems | length),
  drawerItemsCount: (.drawerItems | length),
  coursesCount: (.courses | length),
  otherCourseGroupsCount: (.otherCourseGroups | length),
  duaCategoriesCount: (.duaCategories | length)
}'
echo ""

# Verify data response structure
echo "Verifying data response structure..."
echo "$DATA_RESPONSE" | jq -e '.logoUrl' > /dev/null && echo "✓ Has 'logoUrl' field" || echo "✗ Missing 'logoUrl' field"
echo "$DATA_RESPONSE" | jq -e '.quickLinks' > /dev/null && echo "✓ Has 'quickLinks' array" || echo "✗ Missing 'quickLinks' array"
echo "$DATA_RESPONSE" | jq -e '.banners' > /dev/null && echo "✓ Has 'banners' array" || echo "✗ Missing 'banners' array"
echo "$DATA_RESPONSE" | jq -e '.broadcastItems' > /dev/null && echo "✓ Has 'broadcastItems' array" || echo "✗ Missing 'broadcastItems' array"
echo "$DATA_RESPONSE" | jq -e '.socialMediaItems' > /dev/null && echo "✓ Has 'socialMediaItems' array" || echo "✗ Missing 'socialMediaItems' array"
echo "$DATA_RESPONSE" | jq -e '.drawerItems' > /dev/null && echo "✓ Has 'drawerItems' array" || echo "✗ Missing 'drawerItems' array"
echo "$DATA_RESPONSE" | jq -e '.aboutUsMarkdown' > /dev/null && echo "✓ Has 'aboutUsMarkdown' field" || echo "✗ Missing 'aboutUsMarkdown' field"
echo "$DATA_RESPONSE" | jq -e '.courses' > /dev/null && echo "✓ Has 'courses' array" || echo "✗ Missing 'courses' array"
echo "$DATA_RESPONSE" | jq -e '.otherCourseGroups' > /dev/null && echo "✓ Has 'otherCourseGroups' array" || echo "✗ Missing 'otherCourseGroups' array"
echo "$DATA_RESPONSE" | jq -e '.duaCategories' > /dev/null && echo "✓ Has 'duaCategories' array" || echo "✗ Missing 'duaCategories' array"
echo ""

# Test 3: ETag Header
echo "Test 3: Verify ETag header"
echo "--------------------------------------------------"
ETAG=$(curl -sI "$API_URL/data" | grep -i "etag:" | awk '{print $2}' | tr -d '\r')
echo "ETag from header: $ETAG"
if [ -n "$ETAG" ]; then
    echo "✓ ETag header present"
else
    echo "✗ ETag header missing"
fi
echo ""

# Test 4: 304 Not Modified with ETag
echo "Test 4: GET /api/data with If-None-Match (should return 304)"
echo "--------------------------------------------------"
HTTP_CODE=$(curl -sI -H "If-None-Match: $ETAG" "$API_URL/data" | grep "HTTP" | awk '{print $2}')
echo "HTTP Status Code: $HTTP_CODE"
if [ "$HTTP_CODE" = "304" ]; then
    echo "✓ Returns 304 Not Modified when ETag matches"
else
    echo "✗ Expected 304 but got $HTTP_CODE"
fi
echo ""

# Test 5: Sample Course Data
echo "Test 5: Verify course structure"
echo "--------------------------------------------------"
FIRST_COURSE=$(echo "$DATA_RESPONSE" | jq '.courses[0]')
echo "First course:"
echo "$FIRST_COURSE" | jq '{
  title: .title,
  imageUrl: .imageUrl,
  hasDetail: (.detail != null),
  hasRegistration: (.registration != null),
  hasTafseer: (.tafseer != null),
  hasTajweed: (.tajweed != null)
}'
echo ""

# Test 6: Sample Dua Data
echo "Test 6: Verify dua category structure"
echo "--------------------------------------------------"
FIRST_DUA_CAT=$(echo "$DATA_RESPONSE" | jq '.duaCategories[0]')
echo "First dua category:"
echo "$FIRST_DUA_CAT" | jq '{
  title: .title,
  titleUrdu: .titleUrdu,
  duasCount: (.duas | length)
}'
echo ""

# Test 7: CORS Headers
echo "Test 7: Verify CORS headers"
echo "--------------------------------------------------"
CORS_HEADER=$(curl -sI "$API_URL/status" | grep -i "access-control-allow-origin" | tr -d '\r')
echo "$CORS_HEADER"
if [ -n "$CORS_HEADER" ]; then
    echo "✓ CORS headers present"
else
    echo "✗ CORS headers missing"
fi
echo ""

# Test 8: Response Time
echo "Test 8: Measure response time"
echo "--------------------------------------------------"
START_TIME=$(date +%s%N)
curl -s "$API_URL/status" > /dev/null
END_TIME=$(date +%s%N)
ELAPSED=$((($END_TIME - $START_TIME) / 1000000))
echo "Status endpoint response time: ${ELAPSED}ms"

START_TIME=$(date +%s%N)
curl -s "$API_URL/data" > /dev/null
END_TIME=$(date +%s%N)
ELAPSED=$((($END_TIME - $START_TIME) / 1000000))
echo "Data endpoint response time: ${ELAPSED}ms"
echo ""

echo "=================================================="
echo "API Tests Complete!"
echo "=================================================="
