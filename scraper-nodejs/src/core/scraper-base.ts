/**
 * Base scraper class with common functionality
 */

import * as cheerio from 'cheerio';
import { config } from '../config';
import { HttpClient } from './http-client';

/**
 * Base class for all scrapers
 */
export abstract class BaseScraper<T> {
  protected httpClient: HttpClient;
  protected baseUrl: string;

  constructor(httpClient: HttpClient) {
    this.httpClient = httpClient;
    this.baseUrl = config.baseUrl;
  }

  /**
   * Navigate to a URL and get parsed document
   */
  protected async navigateTo(url: string): Promise<cheerio.CheerioAPI | null> {
    return this.httpClient.navigateTo(url);
  }

  /**
   * Download content from URL
   */
  protected async download(url: string, contentType?: string): Promise<string | null> {
    return this.httpClient.download(url, contentType);
  }

  /**
   * Execute multiple async operations
   * TODO: Add proper concurrency control with p-queue
   */
  protected async performAsyncOp<I, O>(
    items: I[],
    operation: (item: I) => Promise<O>
  ): Promise<O[]> {
    return Promise.all(items.map((item) => operation(item)));
  }

  /**
   * Abstract scrape method to be implemented by child classes
   */
  abstract scrape(): Promise<T>;

  /**
   * Get attribute value from Cheerio element
   */
  protected getAttr(
    element: cheerio.Cheerio<any>,
    attr: string
  ): string | undefined {
    return element.attr(attr);
  }

  /**
   * Get text content from Cheerio element
   */
  protected getText(element: cheerio.Cheerio<any>): string {
    return element.text();
  }

  /**
   * Safe query selector that returns null if not found
   */
  protected querySelector(
    $: cheerio.CheerioAPI,
    selector: string
  ): cheerio.Cheerio<any> | null {
    const element = $(selector);
    return element.length > 0 ? element : null;
  }

  /**
   * Safe query selector for attribute
   */
  protected getAttrFromSelector(
    $: cheerio.CheerioAPI,
    selector: string,
    attr: string
  ): string | null {
    const element = this.querySelector($, selector);
    if (!element) return null;
    return this.getAttr(element, attr) || null;
  }
}
