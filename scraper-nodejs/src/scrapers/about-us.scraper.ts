/**
 * About Us page scraper
 * Extracts About Us content and converts to Markdown
 */

import TurndownService from 'turndown';
import { BaseScraper } from '../core/scraper-base';

export class AboutUsScraper extends BaseScraper<string> {
  private turndownService: TurndownService;

  constructor(httpClient: any) {
    super(httpClient);
    this.turndownService = new TurndownService({
      headingStyle: 'atx',
      codeBlockStyle: 'fenced',
    });
  }

  async scrape(): Promise<string> {
    try {
      // Navigate directly to About Us page
      const aboutDoc = await this.navigateTo('about.php');
      if (!aboutDoc) {
        console.error('Failed to load About Us page');
        return '';
      }

      // Try multiple selectors for content
      const selectors = [
        '#aboutuscontent',
        '.about-section',
        'section.about',
        'main',
        '.content',
        'body', // Fallback to extract everything
      ];

      let contentElement = null;
      for (const selector of selectors) {
        const el = aboutDoc(selector);
        if (el && el.length > 0) {
          contentElement = el;
          console.log(`Found content with selector: ${selector}`);
          break;
        }
      }

      if (!contentElement || contentElement.length === 0) {
        console.error('About Us content not found with any selector');
        return '';
      }

      // Extract HTML content
      const htmlContent = contentElement.html() || '';

      // Remove scripts, styles, and navigation elements before converting
      const cleanedHtml = htmlContent
        .replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, '')
        .replace(/<style\b[^<]*(?:(?!<\/style>)<[^<]*)*<\/style>/gi, '')
        .replace(/<nav\b[^<]*(?:(?!<\/nav>)<[^<]*)*<\/nav>/gi, '')
        .replace(/<header\b[^<]*(?:(?!<\/header>)<[^<]*)*<\/header>/gi, '')
        .replace(/<footer\b[^<]*(?:(?!<\/footer>)<[^<]*)*<\/footer>/gi, '');

      // Convert to Markdown
      const markdown = this.turndownService.turndown(cleanedHtml);

      console.log(`About Us content extracted: ${markdown.length} characters`);
      return markdown;
    } catch (error) {
      console.error('Error in AboutUsScraper:', error);
      return '';
    }
  }
}
