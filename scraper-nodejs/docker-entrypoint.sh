#!/bin/sh
set -e

# Generate RELOAD_API_KEY if not set (used for scraper→API communication)
export RELOAD_API_KEY="${RELOAD_API_KEY:-$(cat /dev/urandom | tr -dc 'a-f0-9' | head -c 64)}"

# Run initial scrape after server is up (30s delay)
(
  sleep 30
  echo "[entrypoint] Running initial scrape..."
  node dist/standalone-scraper.js || echo "[entrypoint] Initial scrape failed, will retry on schedule"
) &

# Schedule scraper every 2 hours
(
  while true; do
    sleep 7200
    echo "[entrypoint] Running scheduled scrape..."
    node dist/standalone-scraper.js || echo "[entrypoint] Scheduled scrape failed"
  done
) &

# Start API server as main process
exec node dist/api/server.js
