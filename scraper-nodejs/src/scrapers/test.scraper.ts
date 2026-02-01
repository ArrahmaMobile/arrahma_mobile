/**
 * Test scraper - extracts test pages (tests-q101.php, tests-english.php, juz-tests.php, etc.)
 */

import { BaseScraper } from '../core/scraper-base';
import { MediaContent, MediaItem } from '../types/models';
import { toAbsoluteUrl } from '../utils/url.utils';
import { cleanText } from '../utils/text.utils';
import { createItem } from '../utils/content-type.utils';

export class TestScraper extends BaseScraper<MediaContent | null> {
  private url: string;

  constructor(httpClient: any, url: string) {
    super(httpClient);
    this.url = url;
  }

  async scrape(): Promise<MediaContent | null> {
    console.log(`Scraping test page: ${this.url}`);

    const $ = await this.navigateTo(this.url);
    if (!$) {
      console.error('Failed to load test page');
      return null;
    }

    // Extract title from page
    const pageTitle = cleanText($('h1, h2').first().text()) || 'Tests';

    // Extract instructions and rules
    const instructions: string[] = [];
    const seenInstructions = new Set<string>();

    // Use body as search area since test content can be in various containers
    // We'll filter out navigation using the closest() check in the link extraction
    const $searchArea = $('body');

    // Look for "Important" section and instructions
    $searchArea.find('p, li').each((_: any, el: any) => {
      const $el = $(el);
      const text = cleanText($el.text());

      // Check if this is an instruction/rule
      if (text.match(/^(please|once|remember|passing|cheating|note|direction)/i) ||
          text.match(/^\d+\.\s+/) || // numbered list
          $el.find('strong, b').length > 0) {
        if (text.length > 10 && text.length < 500 && !seenInstructions.has(text)) {
          seenInstructions.add(text);
          instructions.push(text);
        }
      }
    });

    // Extract test items
    const mediaItems: MediaItem[] = [];
    const seenUrls = new Set<string>();

    // Strategy 1: Look for links to PDF, DOCX, or Google Forms in main content area
    $searchArea.find('a[href]').each((_: any, el: any) => {
      const $link = $(el);
      const href = $link.attr('href');
      const linkText = cleanText($link.text());

      if (!href) return;

      // Skip navigation links - but only if they're in the top navigation or sidebar
      // Allow links that are in the page content, even if technically in a nav container
      const $navParent = $link.closest('#navmenu, .navbar-nav, .sidebar, aside');
      if ($navParent.length > 0) {
        return;
      }

      // Check if this is a test link
      const isPdf = href.toLowerCase().endsWith('.pdf');
      const isDocx = href.toLowerCase().endsWith('.docx') || href.toLowerCase().endsWith('.doc');
      const isGoogleForm = href.includes('docs.google.com/forms') || href.includes('forms.gle');

      if (isPdf || isDocx || isGoogleForm) {
        const absoluteUrl = toAbsoluteUrl(href, this.baseUrl + '/' + this.url);

        // Skip if we've already seen this URL
        if (seenUrls.has(absoluteUrl)) {
          return;
        }
        seenUrls.add(absoluteUrl);

        // Try to find the test title and due date
        let testTitle = linkText;
        let dueDate = '';

        // Look in parent elements for more context
        const $parent = $link.parent();
        const $grandParent = $parent.parent();

        // Try to find "Juz X Test" or similar pattern
        const parentText = cleanText($parent.text());
        const grandParentText = cleanText($grandParent.text());

        const testMatch = parentText.match(/(Juz \d+ Test \d+|Test \d+|[A-Z][a-z\s]+Test)/i);
        if (testMatch) {
          testTitle = testMatch[0];
        } else {
          const grandTestMatch = grandParentText.match(/(Juz \d+ Test \d+|Test \d+|[A-Z][a-z\s]+Test)/i);
          if (grandTestMatch) {
            testTitle = grandTestMatch[0];
          }
        }

        // Try to find due date
        const dueDateMatch = parentText.match(/Due:?\s*([A-Z][a-z]+\s+\d+(?:st|nd|rd|th)?,?\s*\d{4})/i) ||
                            grandParentText.match(/Due:?\s*([A-Z][a-z]+\s+\d+(?:st|nd|rd|th)?,?\s*\d{4})/i);
        if (dueDateMatch) {
          dueDate = dueDateMatch[1];
        }

        // Build the item title
        let itemTitle = testTitle;
        if (dueDate) {
          itemTitle += ` (Due: ${dueDate})`;
        }
        if (isPdf) {
          itemTitle += ' - PDF';
        } else if (isDocx) {
          itemTitle += ' - Word';
        } else if (isGoogleForm) {
          itemTitle += ' - Online Form';
        }

        const item = createItem(absoluteUrl);

        mediaItems.push({
          item,
          title: itemTitle,
          imageUrl: null,
        });
      }
    });

    // Strategy 2: Look for embedded test content or tables with test information
    // This handles cases where tests might be displayed in a table format
    $searchArea.find('table tr, .test-item, .row').each((_: any, el: any) => {
      const $row = $(el);
      const rowText = cleanText($row.text());

      // Look for test indicators in the row
      if (rowText.match(/test|quiz/i) && rowText.match(/due|deadline/i)) {
        const $links = $row.find('a[href]');

        $links.each((_: any, link: any) => {
          const $link = $(link);
          const href = $link.attr('href');

          if (!href) return;

          // Skip navigation links - but only if they're in the top navigation or sidebar
          const $navParent = $link.closest('#navmenu, .navbar-nav, .sidebar, aside');
          if ($navParent.length > 0) {
            return;
          }

          const isPdf = href.toLowerCase().endsWith('.pdf');
          const isDocx = href.toLowerCase().endsWith('.docx') || href.toLowerCase().endsWith('.doc');
          const isGoogleForm = href.includes('docs.google.com/forms') || href.includes('forms.gle');

          if (isPdf || isDocx || isGoogleForm) {
            // Avoid duplicates
            const absoluteUrl = toAbsoluteUrl(href, this.baseUrl + '/' + this.url);

            if (!seenUrls.has(absoluteUrl)) {
              seenUrls.add(absoluteUrl);
              const item = createItem(absoluteUrl);
              mediaItems.push({
                item,
                title: cleanText($link.text()) || 'Test',
                imageUrl: null,
              });
            }
          }
        });
      }
    });

    if (mediaItems.length === 0) {
      console.warn(`  ⚠️  No test links found on ${this.url}`);
      return null;
    }

    // Build description from instructions
    const description = instructions.length > 0
      ? instructions.join('\n\n')
      : undefined;

    console.log(`  ✓ Found ${mediaItems.length} test(s)`);

    return {
      title: pageTitle,
      description,
      items: mediaItems,
    };
  }
}
