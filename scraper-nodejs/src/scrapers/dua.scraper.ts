/**
 * Dua scraper - extracts duas from the website
 */

import { BaseScraper } from '../core/scraper-base';
import { DuaCategory, Dua } from '../types/models';
import { toAbsoluteUrl } from '../utils/url.utils';
import { cleanText } from '../utils/text.utils';

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
    const titleUrdu = cleanText($header.find('p.category-title-urdu').text()) || '';

    // Extract all dua content blocks
    const duas: Dua[] = [];
    const $contentBlocks = $frame.find('div.content');

    $contentBlocks.each((index: number, el: any) => {
      const $content = $(el);

      const duaTitle = cleanText($content.find('h2.dua-title').text()) || undefined;
      const duaTitleUrdu = cleanText($content.find('p.dua-title-urdu').text()) || undefined;
      const duaArabic = cleanText($content.find('p.dua-arabic').text()) || '';
      const duaEnglish = cleanText($content.find('p.dua-english').text()) || undefined;
      const duaUrdu = cleanText($content.find('p.dua-urdu').text()) || undefined;

      // Only add if there's Arabic text (required field)
      if (duaArabic) {
        const dua: Dua = {
          id: `${index + 1}`,
          title: duaTitle,
          titleUrdu: duaTitleUrdu,
          dua: duaArabic,
          duaEnglish: duaEnglish,
          duaUrdu: duaUrdu,
          notes: undefined,
        };

        duas.push(dua);
      }
    });

    if (duas.length === 0) {
      return null;
    }

    return {
      title,
      titleUrdu,
      duas,
    };
  }
}
