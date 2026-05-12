/**
 * Text utility functions for cleaning and normalizing text
 */

/**
 * Clean text by normalizing whitespace and trimming.
 * Collapses all whitespace (including newlines) into single spaces.
 */
export function cleanText(text: string): string {
  return text
    .replace(/\s+/g, ' ')
    .trim();
}

/**
 * Clean text while preserving intentional line breaks.
 * Replaces <br> tags with newlines before extracting text,
 * then normalizes runs of whitespace per line while keeping newlines.
 */
export function cleanTextPreserveBreaks($el: any): string {
  const clone = $el.clone();
  clone.find('br').replaceWith('\n');
  return clone.text()
    .replace(/[ \t]+/g, ' ')
    .replace(/\n[ \t]*/g, '\n')
    .replace(/\n{3,}/g, '\n\n')
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

/**
 * Convert text to proper title case
 * Examples:
 * - "S T E A D Y P A C E D Courses" -> "Steadypaced Courses"
 * - "STEADY- PACED Courses" -> "Steady-Paced Courses"
 * - "Courses IN OTHER LANGUAGES" -> "Courses in Other Languages"
 */
export function fixSpacedText(text: string): string {
  // Words that should be lowercase in title case (unless first word)
  const smallWords = new Set([
    'a', 'an', 'and', 'as', 'at', 'but', 'by', 'for', 'in', 'into',
    'nor', 'of', 'on', 'or', 'so', 'the', 'to', 'up', 'yet'
  ]);

  // First, remove spaces between single uppercase letters
  // Pattern: single letters separated by spaces like "S T E A D Y"
  let fixed = text.replace(/\b([A-Z])\s+(?=[A-Z]\s|[A-Z]\b)/g, '$1');

  // Normalize spaces around hyphens (e.g., "STEADY- PACED" -> "STEADY-PACED")
  fixed = fixed.replace(/\s*-\s*/g, '-');

  // Normalize whitespace
  fixed = fixed.replace(/\s+/g, ' ').trim();

  // Split by spaces while preserving hyphenated words
  const words = fixed.split(' ');

  // Convert each word to title case
  const result = words.map((word, index) => {
    if (word.length === 0) return word;

    // Handle hyphenated words (e.g., "STEADY-PACED" -> "Steady-Paced")
    if (word.includes('-')) {
      return word
        .split('-')
        .map(part => {
          if (part.length === 0) return part;
          return part.charAt(0).toUpperCase() + part.slice(1).toLowerCase();
        })
        .join('-');
    }

    // Convert to lowercase first
    const lowerWord = word.toLowerCase();

    // Check if this is a small word (but not the first word)
    if (index > 0 && smallWords.has(lowerWord)) {
      return lowerWord;
    }

    // Title case: capitalize first letter, lowercase the rest
    return word.charAt(0).toUpperCase() + word.slice(1).toLowerCase();
  });

  return result.join(' ');
}
