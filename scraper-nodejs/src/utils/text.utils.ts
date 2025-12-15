/**
 * Text utility functions for cleaning and normalizing text
 */

/**
 * Clean text by normalizing whitespace and trimming
 */
export function cleanText(text: string): string {
  return text
    .replace(/\s+/g, ' ') // Replace multiple whitespace with single space
    .replace(/\n+/g, ' ') // Replace newlines with space
    .trim();
}

/**
 * Remove all non-alphanumeric characters except spaces
 */
export function alphanumericOnly(text: string): string {
  return text.replace(/[^a-zA-Z0-9\s]/g, '');
}

/**
 * Normalize whitespace (collapse multiple spaces/newlines)
 */
export function normalizeWhitespace(text: string): string {
  return text
    .replace(/[ \t]+/g, ' ')
    .replace(/\n+/g, '\n')
    .trim();
}

/**
 * Extract text content and clean it
 */
export function extractCleanText(text: string | null | undefined): string {
  if (!text) return '';
  return cleanText(text);
}
