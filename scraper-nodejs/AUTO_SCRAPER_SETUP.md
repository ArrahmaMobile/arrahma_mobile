# Auto-Scraper Setup Guide

This document explains the automatic scraping setup for the Arrahmah API.

## Overview

The API server now includes automatic scraping every 2 hours with the following features:

- **Automatic Scraping**: Runs every 2 hours automatically
- **Retry Logic**: 3 retry attempts on failure with 1-minute delays
- **Error Handling**: Comprehensive error handling and logging
- **Manual Trigger**: Ability to manually trigger scraping via API
- **Status Monitoring**: Real-time status monitoring of scraper operations

## How It Works

1. When the API server starts, it automatically runs the scraper to get fresh data
2. A scheduler is configured to run the scraper every 2 hours (on even hours: 00:00, 02:00, 04:00, etc.)
3. Each scraper run:
   - Fetches latest data from arrahmah.org
   - Updates the `data/scraped_data.json` file
   - Retries up to 3 times if it fails
   - Logs all operations with timestamps
4. The API endpoints automatically serve the latest scraped data

## Running the Server

### Development Mode (with TypeScript)
```bash
npm run api:dev
```

### Production Mode
```bash
npm run api
```

This will:
- Build the TypeScript code
- Start the API server on port 8888
- Run an initial scrape
- Schedule scraping every 2 hours

## API Endpoints

### Main Endpoints
- `GET /api/data` - Get the latest scraped data
- `GET /api/status` - Get API status and data freshness
- `GET /health` - Health check endpoint

### Scraper Management Endpoints
- `GET /api/scraper-status` - Get detailed scraper scheduler status
- `POST /api/trigger-scrape` - Manually trigger a scraper run

## Monitoring the Scraper

### Check Scraper Status
```bash
curl http://localhost:8888/api/scraper-status
```

This returns:
```json
{
  "isRunning": false,
  "lastRunTime": "2024-01-04T10:00:00.000Z",
  "lastSuccessTime": "2024-01-04T10:00:00.000Z",
  "lastError": null,
  "successCount": 5,
  "failureCount": 0,
  "nextScheduledRun": "2024-01-04T12:00:00.000Z",
  "statusSummary": "..."
}
```

### Manually Trigger a Scrape
```bash
curl -X POST http://localhost:8888/api/trigger-scrape
```

## Schedule Configuration

The scraper runs every 2 hours by default. The schedule is defined using cron syntax:
- **Cron Expression**: `0 */2 * * *`
- **Meaning**: At minute 0 of every 2nd hour
- **Examples**: 00:00, 02:00, 04:00, 06:00, 08:00, 10:00, 12:00, 14:00, 16:00, 18:00, 20:00, 22:00

### Customizing the Schedule

To change the schedule, modify the `ScraperScheduler` configuration in [src/api/server.ts](src/api/server.ts):

```typescript
this.scheduler = new ScraperScheduler({
  cronExpression: '0 */2 * * *',  // Change this for different schedule
  runOnStart: true,                // Run immediately on server start
  maxRetries: 3,                   // Number of retry attempts
  retryDelay: 60000,              // Delay between retries (ms)
});
```

#### Common Cron Patterns
- `0 */1 * * *` - Every hour
- `0 */4 * * *` - Every 4 hours
- `0 0 * * *` - Once a day at midnight
- `*/30 * * * *` - Every 30 minutes

## Logging

The scraper provides detailed logging for all operations:

```
============================================================
🔄 Scraper run started (Attempt 1/3)
⏰ Time: 1/4/2024, 10:00:00 AM
============================================================

🚀 Starting Arrahmah scraper...
📄 Scraping homepage...
📖 Scraping About Us...
📚 Scraping Quran courses...
🤲 Scraping Duas...

✅ Scraping completed successfully!

============================================================
✅ Scraper run completed successfully
⏱️  Duration: 12.34s
📊 Total successful runs: 5
⏰ Next run: 1/4/2024, 12:00:00 PM
============================================================
```

## Error Handling

If a scrape fails:

1. The error is logged with details
2. The scraper waits 1 minute (configurable)
3. It retries up to 3 times (configurable)
4. If all retries fail, it waits for the next scheduled run
5. The last error is available via the `/api/scraper-status` endpoint

## Data Freshness

The API automatically tracks data freshness:
- Each scrape updates the timestamp in `scraped_data.json`
- The `/api/status` endpoint returns `lastScrapedOn` timestamp
- Clients can use the `dataHash` parameter to check for stale data

## Production Deployment

For production deployment:

1. Build the project: `npm run build`
2. Start the server: `npm run api`
3. Use a process manager like PM2 to keep it running:

```bash
# Install PM2
npm install -g pm2

# Start the server with PM2
pm2 start npm --name "arrahmah-api" -- run api

# Save the PM2 configuration
pm2 save

# Enable PM2 to start on boot
pm2 startup
```

## Troubleshooting

### Scraper Not Running
- Check the logs for error messages
- Verify the `data` directory exists and is writable
- Check the `/api/scraper-status` endpoint for details

### Data Not Updating
- Check if the scraper is running: `GET /api/scraper-status`
- Manually trigger a scrape: `POST /api/trigger-scrape`
- Check the logs for errors

### High Failure Rate
- Check network connectivity to arrahmah.org
- Verify the website structure hasn't changed
- Increase retry delay if rate-limited

## Files Modified

- [src/services/scraper-scheduler.ts](src/services/scraper-scheduler.ts) - New scheduler service
- [src/api/server.ts](src/api/server.ts) - Updated with scheduler integration
- [package.json](package.json) - Added node-cron dependency

## Benefits

✅ **Always Fresh Data**: Data is automatically updated every 2 hours
✅ **Reliable**: Automatic retries on failure
✅ **Transparent**: Detailed logging and status monitoring
✅ **Flexible**: Easy to customize schedule and retry behavior
✅ **Production-Ready**: Robust error handling and recovery
