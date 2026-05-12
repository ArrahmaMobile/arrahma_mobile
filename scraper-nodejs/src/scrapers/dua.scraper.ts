/**
 * Dua scraper - extracts duas from the website
 */

import { BaseScraper } from '../core/scraper-base';
import { DuaCategory, Dua } from '../types/models';
import { toAbsoluteUrl } from '../utils/url.utils';
import { cleanText, cleanTextPreserveBreaks } from '../utils/text.utils';

export class DuaScraper extends BaseScraper<DuaCategory[]> {
  private readonly duaPageUrl = 'duas/duas.php';

  async scrape(): Promise<DuaCategory[]> {
    console.log('Scraping duas...');

    const $ = await this.navigateTo(this.duaPageUrl);
    if (!$) {
      console.error('Failed to load duas page');
      return [];
    }

    const categories: DuaCategory[] = [];

    // Extract top-level image card links from the hero section
    const imageCardLinks: { url: string; imageUrl: string }[] = [];
    $('#main > .container a').each((_: any, el: any) => {
      const $link = $(el);
      const href = $link.attr('href');
      const $img = $link.find('img');
      const imgSrc = $img.attr('src');

      if (href && imgSrc && href.includes('/duas/') && !href.endsWith('.pdf')) {
        const absoluteUrl = toAbsoluteUrl(href, this.baseUrl + '/' + this.duaPageUrl);
        const absoluteImgUrl = toAbsoluteUrl(imgSrc, this.baseUrl + '/' + this.duaPageUrl);
        imageCardLinks.push({ url: absoluteUrl, imageUrl: absoluteImgUrl });
      }
    });

    // Scrape each image card dua page
    for (const { url, imageUrl } of imageCardLinks) {
      try {
        const category = await this.scrapeDuaPage(url);
        if (category) {
          category.imageUrl = imageUrl;
          categories.push(category);
        }
      } catch (error) {
        console.error(`  Failed to scrape dua page ${url}:`, error);
      }
    }

    // Find text-based dua links in the list section, deduplicating against image cards
    const duaLinks: string[] = [];
    const normalizeUrl = (url: string) => url.replace('://www.', '://');
    const imageCardUrls = new Set(imageCardLinks.map(l => normalizeUrl(l.url)));
    $('#table1 #ayahc a').each((_: any, el: any) => {
      const $link = $(el);
      const href = $link.attr('href');

      if (href && (href.includes('/duas/pages/') || href.includes('/dua_nn/') || href.includes('/duas/'))) {
        const absoluteUrl = toAbsoluteUrl(href, this.baseUrl + '/' + this.duaPageUrl);
        if (!imageCardUrls.has(normalizeUrl(absoluteUrl))) {
          duaLinks.push(absoluteUrl);
        }
      }
    });

    // Scrape each text-based dua page
    for (const link of duaLinks) {
      try {
        const category = await this.scrapeDuaPage(link);
        if (category) {
          categories.push(category);
        }
      } catch (error) {
        console.error(`  Failed to scrape dua page ${link}:`, error);
      }
    }

    console.log(`✓ Extracted ${categories.length} dua categories`);
    return categories;
  }

  /**
   * Scrape a single dua page
   */
  private async scrapeDuaPage(url: string): Promise<DuaCategory | null> {
    const $ = await this.navigateTo(url);
    if (!$) {
      return null;
    }

    const $frame = $('.frame');
    if ($frame.length === 0) {
      return null;
    }

    // Extract header information
    const $header = $frame.find('.header');
    const title = cleanText($header.find('h1.category-title').text()) || '';
    const titleUrdu = cleanText($header.find('p.category-title-urdu').text()) || undefined;

    // Collect category-level notes from content blocks
    const categoryNotes: string[] = [];
    const categoryNotesUrdu: string[] = [];

    // Extract all dua content blocks
    const duas: Dua[] = [];
    const $contentBlocks = $frame.find('div.content');

    $contentBlocks.each((index: number, el: any) => {
      const $content = $(el);

      // Extract notes (English and Urdu)
      const noteText = cleanText($content.children('h2.dua-note').text());
      const noteTextUrdu = cleanText($content.children('p.dua-note-urdu').text());
      if (noteText) categoryNotes.push(noteText);
      if (noteTextUrdu) categoryNotesUrdu.push(noteTextUrdu);

      // Use direct children only to avoid picking up nested content block elements.
      // Some pages have broken HTML where </div> is inside a comment, causing
      // nesting in browsers (Cheerio handles it correctly but we stay safe).
      const duaTitle = cleanText($content.children('h2.dua-title').text()) || undefined;
      const duaTitleUrdu = cleanText($content.children('p.dua-title-urdu').text()) || undefined;
      const arabic = cleanTextPreserveBreaks($content.children('p.dua-arabic')) || '';

      if (!arabic) return;

      // Try direct child elements first for English/Urdu
      let english = cleanTextPreserveBreaks($content.children('p.dua-english')) || '';
      let urdu = cleanTextPreserveBreaks($content.children('p.dua-urdu')) || '';

      // Some pages have English/Urdu inside HTML comments (<!--p class="dua-english">...-->).
      // Extract from comment nodes when the real elements are missing.
      if (!english || !urdu) {
        $content.contents().each((_: number, node: any) => {
          if (node.type === 'comment') {
            const commentText: string = node.data || '';
            if (!english) {
              const engMatch = commentText.match(/class=["']dua-english["']>([\s\S]*?)<\/p>/);
              if (engMatch) english = cleanText(engMatch[1]);
            }
            if (!urdu) {
              const urduMatch = commentText.match(/class=["']dua-urdu["']>([\s\S]*?)<\/p>/);
              if (urduMatch) urdu = cleanText(urduMatch[1]);
            }
          }
        });
      }

      const repeat = this.parseRepeat(arabic);
      const cleanedArabic = this.cleanArabic(arabic);

      const dua: Dua = {
        id: index + 1,
        title: duaTitle,
        titleUrdu: duaTitleUrdu,
        arabic: cleanedArabic,
        english,
        urdu,
        ...(repeat ? { repeat } : {}),
      };

      duas.push(dua);
    });

    if (duas.length === 0) {
      return null;
    }

    const notes = categoryNotes.length > 0 ? categoryNotes.join('\n') : undefined;
    const notesUrdu = categoryNotesUrdu.length > 0 ? categoryNotesUrdu.join('\n') : undefined;

    return { title, titleUrdu, notes, notesUrdu, duas };
  }

  private static readonly REPEAT_PATTERN = /\(\s*(\d+)\s*[xX×]\s*(?:OR\s+\d+\s*[xX×]\s*)?\)/;

  private parseRepeat(text: string): number | undefined {
    const match = text.match(DuaScraper.REPEAT_PATTERN);
    if (match) {
      return parseInt(match[1], 10);
    }
    return undefined;
  }

  private cleanArabic(text: string): string {
    return text
      .replace(DuaScraper.REPEAT_PATTERN, '')
      .replace(/^\s*\*?\s*\d+\s*[.)]\s*/gm, '')
      .trim();
  }
}
