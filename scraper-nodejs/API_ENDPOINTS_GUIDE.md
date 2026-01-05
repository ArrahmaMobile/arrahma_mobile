# API Endpoints Guide

Complete guide to all available API endpoints and their responses.

## Base URL
```
http://localhost:8888
```

---

## 📊 GET /api/data

Returns the latest scraped data.

### Request
```bash
curl http://localhost:8888/api/data
```

### Headers
- `If-None-Match: <etag>` (optional) - Returns 304 if data hasn't changed
- `Accept-Version: <version>` (optional) - API version

### Query Parameters
- `api-version` (optional) - API version number

### Response (200 OK)
```json
{
  "logoUrl": "https://arrahmah.org/img/logo.png",
  "quickLinks": [...],
  "banners": [...],
  "broadcastItems": [...],
  "socialMediaItems": [...],
  "drawerItems": [...],
  "aboutUsMarkdown": "...",
  "courses": [...],
  "otherCourseGroups": [...],
  "duaCategories": [...]
}
```

### Response Headers
- `ETag: <hash>` - Data hash for caching

### Response (304 Not Modified)
If `If-None-Match` header matches current data hash, returns empty body.

---

## 📡 GET /api/status

Returns API server status and data freshness information.

### Request
```bash
curl http://localhost:8888/api/status
```

### Query Parameters
- `dataHash` (optional) - Client's current data hash to check staleness

### Response (200 OK)
```json
{
  "status": "Available",
  "isDataStale": false,
  "broadcastStatus": {
    "isYoutubeLive": false,
    "isFacebookLive": false,
    "isMixlrLive": false
  },
  "lastScrapedOn": "2024-01-04T10:15:23.456Z",
  "lastScrapeAttemptOn": "2024-01-04T10:15:00.000Z",
  "lastDataHash": "a1b2c3d4e5f6..."
}
```

### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| `status` | string | Server status: "Available", "Maintenance", or "Unavailable" |
| `isDataStale` | boolean | `true` if client's dataHash doesn't match server's |
| `broadcastStatus` | object | Live broadcast status for various platforms |
| `lastScrapedOn` | string (ISO 8601) | When the data was last successfully scraped |
| `lastScrapeAttemptOn` | string (ISO 8601) | When the last scrape attempt started |
| `lastDataHash` | string | MD5 hash of current data for cache validation |

### Usage Example
```bash
# First call - get initial data hash
RESPONSE=$(curl -s http://localhost:8888/api/status)
HASH=$(echo $RESPONSE | jq -r '.lastDataHash')

# Later - check if data is stale
curl "http://localhost:8888/api/status?dataHash=$HASH"
# If isDataStale is true, fetch new data
```

---

## 🔧 GET /api/scraper-status

Returns detailed information about the scraper scheduler.

### Request
```bash
curl http://localhost:8888/api/scraper-status
```

### Response (200 OK)
```json
{
  "isRunning": false,
  "lastRunTime": "2024-01-04T10:00:00.000Z",
  "lastSuccessTime": "2024-01-04T10:00:23.456Z",
  "lastError": null,
  "successCount": 15,
  "failureCount": 0,
  "nextScheduledRun": "2024-01-04T12:00:00.000Z",
  "statusSummary": "Scraper Scheduler Status\n============================================================\nRunning: No 💤\nLast Run: 1/4/2024, 10:00:00 AM\nLast Success: 1/4/2024, 10:00:23 AM\nNext Scheduled: 1/4/2024, 12:00:00 PM\nSuccess Count: 15 ✅\nFailure Count: 0 ❌\nLast Error: None\n============================================================"
}
```

### Response Fields

| Field | Type | Description |
|-------|------|-------------|
| `isRunning` | boolean | Whether a scrape is currently in progress |
| `lastRunTime` | string/null (ISO 8601) | When the last scrape run started |
| `lastSuccessTime` | string/null (ISO 8601) | When the last successful scrape completed |
| `lastError` | Error/null | Details of last error (if any) |
| `successCount` | number | Total number of successful scrapes |
| `failureCount` | number | Total number of failed scrapes |
| `nextScheduledRun` | string/null (ISO 8601) | When the next scrape is scheduled |
| `statusSummary` | string | Human-readable status summary |

### Use Cases
- Monitor scraper health
- Check when next scrape will run
- Diagnose scraping issues
- Track success/failure rates

---

## ⚡ POST /api/trigger-scrape

Manually triggers a scraper run (admin/maintenance use).

### Request
```bash
curl -X POST http://localhost:8888/api/trigger-scrape
```

### Response (200 OK)
```json
{
  "message": "Scraper run triggered successfully",
  "timestamp": "2024-01-04T10:30:00.000Z"
}
```

### Notes
- The scrape runs asynchronously (non-blocking)
- Response is returned immediately
- Check `/api/scraper-status` to monitor progress
- If a scrape is already running, it will be queued
- Useful for:
  - Forcing immediate data refresh
  - Testing the scraper
  - Recovery after failures
  - Initial data population

### Example Workflow
```bash
# 1. Trigger a scrape
curl -X POST http://localhost:8888/api/trigger-scrape

# 2. Wait a moment
sleep 2

# 3. Check if it's running
curl http://localhost:8888/api/scraper-status | jq '.isRunning'

# 4. Wait for completion (poll every 10 seconds)
while [ $(curl -s http://localhost:8888/api/scraper-status | jq -r '.isRunning') == "true" ]; do
  echo "Scraping in progress..."
  sleep 10
done

# 5. Check result
curl http://localhost:8888/api/scraper-status | jq '.lastSuccessTime, .lastError'
```

---

## ❤️ GET /health

Simple health check endpoint.

### Request
```bash
curl http://localhost:8888/health
```

### Response (200 OK)
```json
{
  "status": "ok"
}
```

### Use Cases
- Load balancer health checks
- Monitoring systems
- Quick availability test
- Uptime monitoring

---

## Data Freshness Strategy

The API implements a smart caching strategy:

### For Clients

1. **Initial Load**
   ```bash
   # Get initial data
   curl http://localhost:8888/api/data > data.json

   # Store the ETag
   ETAG=$(curl -I http://localhost:8888/api/data | grep -i etag | cut -d' ' -f2)
   ```

2. **Periodic Check** (e.g., every 5 minutes)
   ```bash
   # Check if data is stale
   RESPONSE=$(curl -s "http://localhost:8888/api/status?dataHash=$ETAG")
   IS_STALE=$(echo $RESPONSE | jq -r '.isDataStale')

   if [ "$IS_STALE" == "true" ]; then
     # Fetch new data
     curl http://localhost:8888/api/data > data.json
     # Update stored ETag
     ETAG=$(curl -I http://localhost:8888/api/data | grep -i etag | cut -d' ' -f2)
   fi
   ```

3. **Using If-None-Match** (more efficient)
   ```bash
   # Returns 304 if not modified, 200 with data if modified
   curl -H "If-None-Match: $ETAG" http://localhost:8888/api/data
   ```

### Data Freshness Guarantees

- **Maximum Age**: 2 hours (time between automatic scrapes)
- **Typical Age**: < 2 hours (depends on when last scrape ran)
- **On Demand**: Can force refresh via `/api/trigger-scrape`
- **Cache Validation**: Use ETag or dataHash for efficient checking

### Timeline Example

```
00:00 - Automatic scrape (data fresh)
00:30 - Data age: 30 minutes
01:00 - Data age: 1 hour
01:30 - Data age: 1.5 hours
02:00 - Automatic scrape (data refreshed)
02:30 - Data age: 30 minutes
...
```

---

## Error Responses

All endpoints may return error responses:

### 404 Not Found
```json
{
  "error": "Not found"
}
```

### 500 Internal Server Error
```json
{
  "error": "Internal server error"
}
```

### 304 Not Modified
Empty body (for `/api/data` with matching `If-None-Match`)

---

## Response Headers

### Common Headers
- `Content-Type: application/json`
- `Access-Control-Allow-Origin: *` (CORS enabled)

### Caching Headers
- `ETag: <hash>` (on `/api/data` endpoint)
- `Access-Control-Expose-Headers: ETag`

---

## Integration Examples

### JavaScript/TypeScript
```typescript
// Check if data needs updating
async function checkDataFreshness(currentHash: string): Promise<boolean> {
  const response = await fetch(
    `http://localhost:8888/api/status?dataHash=${currentHash}`
  );
  const status = await response.json();
  return status.isDataStale;
}

// Fetch data with ETag
async function fetchData(etag?: string) {
  const headers = etag ? { 'If-None-Match': etag } : {};
  const response = await fetch('http://localhost:8888/api/data', { headers });

  if (response.status === 304) {
    console.log('Data not modified, using cache');
    return null;
  }

  const newEtag = response.headers.get('etag');
  const data = await response.json();
  return { data, etag: newEtag };
}
```

### Python
```python
import requests

# Check status
response = requests.get('http://localhost:8888/api/status')
status = response.json()
print(f"Last scraped: {status['lastScrapedOn']}")

# Fetch data with ETag
headers = {'If-None-Match': stored_etag} if stored_etag else {}
response = requests.get('http://localhost:8888/api/data', headers=headers)

if response.status_code == 304:
    print('Data not modified')
else:
    data = response.json()
    new_etag = response.headers.get('etag')
```

### Shell Script
```bash
#!/bin/bash

API_URL="http://localhost:8888"

# Get current status
status=$(curl -s "$API_URL/api/status")
echo "Last scraped: $(echo $status | jq -r '.lastScrapedOn')"
echo "Last hash: $(echo $status | jq -r '.lastDataHash')"

# Get scraper status
scraper=$(curl -s "$API_URL/api/scraper-status")
echo "Success count: $(echo $scraper | jq -r '.successCount')"
echo "Next run: $(echo $scraper | jq -r '.nextScheduledRun')"
```

---

## Best Practices

1. **Use ETag/If-None-Match** for efficient data fetching
2. **Check `/api/status`** periodically (every 5-10 minutes) to detect changes
3. **Monitor `/api/scraper-status`** to ensure scraper is healthy
4. **Don't poll `/api/data`** too frequently - use status endpoint instead
5. **Handle 304 responses** properly to save bandwidth
6. **Store the data hash** to check for staleness
7. **Implement retry logic** for failed requests
8. **Use `/api/trigger-scrape`** sparingly - automatic scraping is sufficient

---

## Monitoring Checklist

For production deployments, monitor:

- [ ] `/health` returns 200 (server is up)
- [ ] `/api/status` returns valid data
- [ ] `lastScrapedOn` is recent (< 3 hours old)
- [ ] `/api/scraper-status` shows `successCount` increasing
- [ ] `/api/scraper-status` shows `failureCount` not increasing
- [ ] `isRunning` is occasionally true (during scrapes)
- [ ] `nextScheduledRun` is always set and upcoming
- [ ] No persistent errors in `lastError`

---

## Support

For issues or questions:
- Check the logs for detailed error messages
- Use `/api/scraper-status` to diagnose scraper issues
- Manually trigger a scrape with `/api/trigger-scrape` for testing
- See [AUTO_SCRAPER_SETUP.md](AUTO_SCRAPER_SETUP.md) for full documentation
