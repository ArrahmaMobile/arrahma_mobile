/**
 * URL utility functions for normalization and conversion
 */

import { config } from '../config';

/**
 * Convert relative URL to absolute URL
 */
export function toAbsoluteUrl(url: string, baseUrl: string = config.baseUrl): string {
  try {
    // If already absolute, return as-is
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }

    // Handle protocol-relative URLs
    if (url.startsWith('//')) {
      return `https:${url}`;
    }

    // Handle relative URLs
    const base = new URL(baseUrl);
    const absolute = new URL(url, base);
    return absolute.toString();
  } catch (error) {
    console.error(`Error converting URL to absolute: ${url}`, error);
    return url;
  }
}

/**
 * Remove query string from URL
 */
export function removeQueryString(url: string): string {
  try {
    const urlObj = new URL(url);
    return `${urlObj.origin}${urlObj.pathname}`;
  } catch (error) {
    // If URL parsing fails, try simple string manipulation
    return url.split('?')[0];
  }
}

/**
 * Normalize URL (absolute + remove query string)
 */
export function normalizeUrl(url: string, baseUrl: string = config.baseUrl): string {
  const absolute = toAbsoluteUrl(url, baseUrl);
  return removeQueryString(absolute);
}

/**
 * Extract domain from URL
 */
export function getDomain(url: string): string | null {
  try {
    const urlObj = new URL(url);
    return urlObj.hostname;
  } catch (error) {
    return null;
  }
}

/**
 * Check if URL is external (not from base domain)
 */
export function isExternalUrl(url: string, baseUrl: string = config.baseUrl): boolean {
  try {
    const urlDomain = getDomain(url);
    const baseDomain = getDomain(baseUrl);
    return urlDomain !== baseDomain;
  } catch (error) {
    return false;
  }
}
