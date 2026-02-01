# Broadcast Status Checker

## Overview

The broadcast status checker monitors live streaming status for YouTube, Facebook, and Mixlr platforms. It's integrated into the API server and checks every 30 seconds (matching the original Dart implementation).

## Implementation

### Files Created/Modified

1. **`src/services/broadcast-checker.ts`** - Main broadcast checking service
2. **`src/api/server.ts`** - Updated to use broadcast checker
3. **`data/lastVideoIds.json`** - Stores last known video IDs to detect changes

### How It Works

#### Channel ID Extraction

The checker extracts channel IDs from broadcast items in the scraped data:

- **YouTube**: Supports multiple URL formats
  - `youtube.com/channel/CHANNEL_ID`
  - `youtube.com/c/USERNAME`
  - `youtube.com/@USERNAME`

- **Facebook**: Extracts page username
  - `facebook.com/PAGE_NAME`

- **Mixlr**: Supports subdomain and path formats
  - `mixlr.com/USERNAME`
  - `USERNAME.mixlr.com`

#### Live Status Detection

1. **YouTube** (`_checkYoutubeLive`)
   - Fetches the channel page HTML
   - Searches for `hqdefault_live.jpg` thumbnail pattern
   - Extracts video ID from thumbnail URL
   - Returns video ID if live, null otherwise

2. **Facebook** (`_checkFacebookLive`)
   - Fetches `/live_videos` page
   - Searches for `"videoID":"(\d+)"` pattern
   - Returns video ID if found, null otherwise
   - **Note**: Facebook often blocks automated requests (returns 400)
   - For production, consider using Facebook Graph API with authentication

3. **Mixlr** (`_checkMixlrLive`)
   - Calls Mixlr API: `https://api.mixlr.com/users/USERNAME?source=embed`
   - Checks `is_live` boolean
   - Returns first broadcast ID if live, null otherwise

#### Change Detection

- Stores last video IDs in `data/lastVideoIds.json`
- Only updates status when video IDs change
- Prevents unnecessary status updates and notifications

#### Status Polling

- Checks every **30 seconds** (same as original Dart implementation)
- Runs in background via `setInterval`
- Updates status only when changes detected

## API Response

The `/api/status` endpoint returns:

```json
{
  "status": "Available",
  "isDataStale": false,
  "broadcastStatus": {
    "isYoutubeLive": false,
    "isFacebookLive": false,
    "isMixlrLive": false
  },
  "lastScrapedOn": "2024-01-30T00:00:00.000Z",
  "lastScrapeAttemptOn": "2024-01-30T00:00:00.000Z",
  "lastDataHash": "abc123...",
  "lastDataChangeOn": "2024-01-30T00:00:00.000Z"
}
```

## Frontend Integration

The Flutter app already has the UI components to display live badges:

- **File**: `lib/views/home_page.dart:423-451`
- Shows "LIVE" badge on social media icons
- Polls `/api/status` every 10 minutes
- Updates UI when broadcast status changes

## Current Status

### ✅ Working

- YouTube live detection
- Mixlr live detection
- Change detection and state persistence
- API integration
- Frontend UI components

### ⚠️ Known Limitations

- **Facebook**: Often blocks automated HTTP requests (returns 400 error)
  - Current implementation handles this gracefully
  - For production, consider:
    - Facebook Graph API with authentication
    - Playwright/Puppeteer with browser automation
    - Server-side proxies with rotation

## Testing

The broadcast checker automatically starts when the API server starts:

```bash
npm run api:dev
```

You should see:
```
🔴 Broadcast status checking started (every 30 seconds)
🔴 Checking live broadcast status...
  YouTube channel: c/arrahmahislamicinstitute
  Facebook page: arrahmah.islamic.institute
  Mixlr user: arrahma-live
✓ Broadcast status updated:
  YouTube: ⚫ Offline
  Facebook: ⚫ Offline
  Mixlr: ⚫ Offline
```

## Future Enhancements

1. **Facebook Graph API Integration**
   - Use official API with app credentials
   - More reliable than HTML scraping
   - Requires Facebook app setup

2. **Playwright/Puppeteer for Facebook**
   - Use headless browser for more reliable scraping
   - Bypasses some anti-bot measures
   - Higher resource usage

3. **Webhook Notifications**
   - Notify when streams go live
   - Push notifications to mobile apps
   - Email/SMS alerts

4. **Caching & Rate Limiting**
   - Cache results for short periods
   - Implement exponential backoff on errors
   - Respect platform rate limits

## Comparison with Original Dart Implementation

| Feature | Dart BroadcastService | Node.js BroadcastChecker |
|---------|----------------------|--------------------------|
| Check Interval | 30 seconds | 30 seconds ✅ |
| YouTube Detection | HTML regex | HTML regex ✅ |
| Facebook Detection | HTML regex | HTML regex ⚠️ (blocked) |
| Mixlr Detection | API call | API call ✅ |
| State Persistence | File storage | File storage ✅ |
| Change Detection | Video ID comparison | Video ID comparison ✅ |
| Error Handling | Basic | Enhanced ✅ |

## Configuration

No configuration needed - the checker automatically:
1. Reads broadcast items from scraped data
2. Extracts channel IDs from URLs
3. Starts checking on server startup
4. Stores state in `data/lastVideoIds.json`
