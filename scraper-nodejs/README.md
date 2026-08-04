# Arrahmah Scraper - Node.js

A robust, maintainable web scraper for Arrahmah Islamic Institute content.

## Features

- 🚀 TypeScript for type safety
- 🔄 Concurrent request handling (max 5 simultaneous)
- ⏱️ Rate limiting (600ms delay between requests)
- 💾 Document caching to avoid redundant requests
- 🔁 Retry logic for rate limits (429 errors)
- 🎯 Modular scraper architecture
- 🧹 Clean, maintainable code following SOLID principles

## Installation

```bash
npm install
```

## Usage

```bash
# Development mode (with ts-node)
npm run dev

# Build and run
npm run scrape

# Build only
npm run build

# Build and run focused contract tests
npm test

# Run built version
npm start
```

## Output

Scraped data is saved to `data/scraped_data.json`

## Product telemetry

The production API exposes SASID Product Stats v1 at authenticated
`GET /_stats`. Configure `PRODUCT_STATS_TOKEN` with the same strong bearer token
used by Relay. The report derives current catalog, content-freshness, and
broadcast-checker gauges from the loaded snapshot. User, signup, active-user,
and online-user metrics are explicitly unavailable because this API does not
receive application identity or interaction events.

The `master` deployment workflow requires a `PRODUCT_STATS_TOKEN` GitHub
Actions secret. It installs the app-owned VPS Compose file and preserves any
unrelated live `.env` entries while rotating that token.

## Architecture

```
scraper-nodejs/
├── src/
│   ├── index.ts                  # Entry point
│   ├── config.ts                 # Configuration
│   ├── types/
│   │   └── models.ts             # Data models
│   ├── core/
│   │   ├── http-client.ts        # HTTP client with rate limiting
│   │   └── scraper-base.ts       # Base scraper class
│   ├── scrapers/
│   │   ├── homepage.scraper.ts
│   │   ├── about-us.scraper.ts
│   │   ├── quran-course.scraper.ts
│   │   ├── dua.scraper.ts
│   │   └── media.scraper.ts
│   └── utils/
│       ├── url.utils.ts          # URL normalization
│       ├── text.utils.ts         # Text cleaning
│       └── content-type.utils.ts # File type detection
└── data/
    └── scraped_data.json         # Output
```

## Maintainability

- **Single Responsibility**: Each scraper handles one content type
- **DRY**: Shared utilities for common operations
- **Type Safety**: Full TypeScript interfaces
- **Easy to Extend**: Add new scrapers by extending base class
- **KISS**: Simple, straightforward logic

## License

MIT
