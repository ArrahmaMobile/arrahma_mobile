# Quick Start Guide - Auto-Scraper API

## 🚀 Start the API Server

```bash
# Development mode (recommended for testing)
npm run api:dev

# Production mode
npm run api
```

## 📋 What Happens Automatically

1. ✅ Server starts on port 8888
2. ✅ Runs initial scrape immediately
3. ✅ Schedules scraping every 2 hours (00:00, 02:00, 04:00, etc.)
4. ✅ Auto-retries 3 times on failure with 1-minute delays
5. ✅ Saves data to `data/scraped_data.json`
6. ✅ API serves latest scraped data automatically

## 🔗 API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/data` | GET | Get latest scraped data |
| `/api/status` | GET | Get API status and data freshness |
| `/api/scraper-status` | GET | Get scraper scheduler status |
| `/api/trigger-scrape` | POST | Manually trigger a scrape |
| `/health` | GET | Health check |

## 📊 Check Scraper Status

```bash
curl http://localhost:8888/api/scraper-status
```

## ⚡ Manually Trigger Scrape

```bash
curl -X POST http://localhost:8888/api/trigger-scrape
```

## 📝 Monitor Logs

The server provides detailed logs for:
- When scrapes start and complete
- Any errors that occur
- Retry attempts
- Next scheduled run time

## 🎯 Key Features

- **Automatic Updates**: Data is refreshed every 2 hours
- **Smart Retries**: 3 automatic retry attempts on failure
- **Real-time Status**: Monitor scraper health via API
- **Manual Control**: Trigger scrapes on-demand
- **Production Ready**: Comprehensive error handling

## 📖 Full Documentation

See [AUTO_SCRAPER_SETUP.md](AUTO_SCRAPER_SETUP.md) for complete documentation.

## ✅ Verification

Run the test script to verify everything is set up correctly:

```bash
./test-api-setup.sh
```

## 💡 Tips

- Data is always fresh (max 2 hours old)
- Failed scrapes automatically retry
- Use `/api/scraper-status` to monitor health
- Logs show all operations with timestamps
- No manual intervention needed - it just works!
