/**
 * Scraper configuration
 */
export const config = {
  /** Base URL for Arrahmah website */
  baseUrl: 'https://arrahmah.org',

  /** Rate limiting delay between requests (ms) */
  requestDelay: 600,

  /** Maximum concurrent requests */
  maxConcurrentRequests: 5,

  /** Maximum rate limit retries */
  maxRateLimitRetries: 5,

  /** Retry delay when rate limited (ms) */
  rateLimitRetryDelay: 5000,

  /** Request timeout (ms) */
  requestTimeout: 30000,

  /** Output file path - writes to API's data directory */
  outputPath: './data/scraped_data.json',
} as const;
