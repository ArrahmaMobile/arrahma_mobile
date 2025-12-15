/**
 * HTTP client with rate limiting, caching, and retry logic
 */

import axios, { AxiosInstance, AxiosResponse } from 'axios';
import * as cheerio from 'cheerio';
import { config } from '../config';
import { toAbsoluteUrl } from '../utils/url.utils';

export class HttpClient {
  private axiosInstance: AxiosInstance;
  private documentCache: Map<string, cheerio.CheerioAPI>;
  private rateLimitCount: number;
  private lastRequestTime: number;

  constructor() {
    this.documentCache = new Map();
    this.rateLimitCount = 0;
    this.lastRequestTime = 0;

    this.axiosInstance = axios.create({
      timeout: config.requestTimeout,
      headers: {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
      },
    });
  }

  /**
   * Rate limiting delay
   */
  private async rateLimit(): Promise<void> {
    const now = Date.now();
    const timeSinceLastRequest = now - this.lastRequestTime;

    if (timeSinceLastRequest < config.requestDelay) {
      const waitTime = config.requestDelay - timeSinceLastRequest;
      await this.sleep(waitTime);
    }

    this.lastRequestTime = Date.now();
  }

  /**
   * Sleep utility
   */
  private sleep(ms: number): Promise<void> {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }

  /**
   * Download content from URL
   */
  async download(url: string, contentType?: string): Promise<string | null> {
    try {
      await this.rateLimit();

      const absoluteUrl = toAbsoluteUrl(url);
      console.log(`Downloading: ${absoluteUrl}`);

      const response: AxiosResponse = await this.axiosInstance.get(absoluteUrl, {
        responseType: 'text',
      });

      // Handle rate limiting (429)
      if (response.status === 429) {
        this.rateLimitCount++;
        if (this.rateLimitCount > config.maxRateLimitRetries) {
          throw new Error('Rate limited too many times');
        }
        console.log(`Rate limited, waiting ${config.rateLimitRetryDelay}ms...`);
        await this.sleep(config.rateLimitRetryDelay);
        return this.download(url, contentType);
      }

      // Check status code
      if (response.status !== 200) {
        console.error(`Failed to download ${absoluteUrl}: Status ${response.status}`);
        return null;
      }

      // Check content type if specified
      if (contentType && response.headers['content-type']) {
        if (!response.headers['content-type'].startsWith(contentType)) {
          console.error(`Wrong content type for ${absoluteUrl}: ${response.headers['content-type']}`);
          return null;
        }
      }

      return response.data;
    } catch (error) {
      console.error(`Error downloading ${url}:`, error);
      return null;
    }
  }

  /**
   * Navigate to URL and parse HTML with Cheerio
   */
  async navigateTo(url: string): Promise<cheerio.CheerioAPI | null> {
    const absoluteUrl = toAbsoluteUrl(url);

    // Check cache first
    if (this.documentCache.has(absoluteUrl)) {
      console.log(`Using cached document: ${absoluteUrl}`);
      return this.documentCache.get(absoluteUrl)!;
    }

    try {
      const html = await this.download(absoluteUrl, 'text/html');
      if (!html) return null;

      const $ = cheerio.load(html);
      this.documentCache.set(absoluteUrl, $);
      return $;
    } catch (error) {
      console.error(`Error navigating to ${url}:`, error);
      return null;
    }
  }

  /**
   * Clear document cache
   */
  clearCache(): void {
    this.documentCache.clear();
  }

  /**
   * Get cache size
   */
  getCacheSize(): number {
    return this.documentCache.size;
  }
}
