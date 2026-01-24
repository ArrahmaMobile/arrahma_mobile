/**
 * Course content scraper for Juz/Surah template pages
 * Extracts lessons, surahs, and items from course pages
 */

import * as cheerio from 'cheerio';
import { BaseScraper } from '../core/scraper-base';
import { QuranCourseContent, Surah, Lesson, ItemGroup, Item } from '../types/models';
import { createItem } from '../utils/content-type.utils';
import { toAbsoluteUrl } from '../utils/url.utils';
import { cleanText } from '../utils/text.utils';

export class CourseContentScraper extends BaseScraper<QuranCourseContent | null> {
  private url: string;

  constructor(httpClient: any, url: string) {
    super(httpClient);
    this.url = url;
  }

  async scrape(): Promise<QuranCourseContent | null> {
    try {
      const $ = await this.navigateTo(this.url);
      if (!$) {
        console.warn(`  ⚠️  Failed to load course page: ${this.url}`);
        return null;
      }

      // Check if page contains actual course content
      // Look for common indicators that the page is valid
      const hasContent = $('.container.my-3').length > 0 ||
                        $('.row.g-2.border').length > 0 ||
                        $('#selectJuz').length > 0;

      if (!hasContent) {
        console.warn(`  ⚠️  Page does not contain recognizable course structure: ${this.url}`);
        return null;
      }

      // Extract title (from title tag or heading)
      let title = $('title').text().trim();
      if (!title || title === 'Arrahmah Islamic Institute') {
        title = $('h1').first().text().trim();
      }
      if (!title || title === 'Arrahmah Islamic Institute') {
        // Try to extract from URL
        const match = this.url.match(/\/([^\/]+)\/juz\d+\.php/);
        if (match) {
          title = match[1];
        } else {
          title = 'Untitled Course';
        }
      }

      // Check if this page has a Juz selector dropdown
      const $juzSelect = $('#selectJuz');
      if ($juzSelect.length > 0) {
        console.log(`  📚 Found Juz selector - scraping all available Juz pages`);
        return await this.scrapeAllJuzPages($, title);
      }

      // Single page scraping (existing logic)
      console.log(`  📄 Scraping NEW Bootstrap structure for ${this.url}`);
      const content = this.scrapeNewStructure($, title);

      if (!content || content.surahs.length === 0) {
        console.warn(`  ⚠️  No lessons found for ${this.url} (page may be under construction)`);
        return null;
      }

      return content;
    } catch (error) {
      console.error(`  ❌ Error scraping course content from ${this.url}:`, error);
      return null;
    }
  }

  /**
   * Scrape all available Juz pages sequentially
   */
  private async scrapeAllJuzPages($: cheerio.CheerioAPI, title: string): Promise<QuranCourseContent | null> {
    const allSurahs: Surah[] = [];
    const juzPages: string[] = [];

    // Extract all Juz page URLs from the dropdown
    $('#selectJuz option').each((_: any, option: any) => {
      const $option = $(option);
      const value = $option.attr('value');
      // Skip empty values and placeholder text
      if (value && !value.includes('Please')) {
        juzPages.push(value);
      }
    });

    if (juzPages.length === 0) {
      console.warn('  No Juz pages found in selector');
      return null;
    }

    console.log(`  Found ${juzPages.length} Juz pages to scrape`);

    // Determine the base URL for Juz pages
    const baseUrl = this.url.substring(0, this.url.lastIndexOf('/') + 1);

    // Scrape each Juz page sequentially
    for (let i = 0; i < juzPages.length; i++) {
      const juzPage = juzPages[i];
      const juzUrl = baseUrl + juzPage;

      console.log(`    Scraping Juz ${i + 1}/${juzPages.length}: ${juzPage}`);

      try {
        const $juzDoc = await this.navigateTo(juzUrl);

        if (!$juzDoc) {
          console.log(`    Failed to load Juz page ${juzPage} - stopping`);
          break;
        }

        // Check if this page still has the selector (if not, content is not available yet)
        if ($juzDoc('#selectJuz').length === 0) {
          console.log(`    Juz page ${juzPage} doesn't have selector - content not available, stopping`);
          break;
        }

        // Scrape content from this Juz page
        const juzContent = this.scrapeNewStructure($juzDoc, title);
        if (juzContent && juzContent.surahs.length > 0) {
          allSurahs.push(...juzContent.surahs);
          console.log(`    ✓ Added ${juzContent.surahs.length} surahs from Juz ${i + 1}`);
        } else {
          console.log(`    No content found in Juz ${i + 1}`);
        }
      } catch (error) {
        console.error(`    Error scraping Juz page ${juzPage}:`, error);
        // Continue to next page on error
      }
    }

    if (allSurahs.length === 0) {
      console.warn('  No surahs found across all Juz pages');
      return null;
    }

    const totalLessons = allSurahs.reduce((sum, s) => sum + s.lessons.length, 0);
    console.log(`  ✓ Total: ${allSurahs.length} surahs, ${totalLessons} lessons from all Juz pages`);

    return {
      id: title.toLowerCase().replace(/\s+/g, '-'),
      title: title,
      surahs: allSurahs,
    };
  }

  /**
   * Scrape new Bootstrap structure (col-12 col-md-5 for titles, col-12 col-md-7 for items)
   */
  private scrapeNewStructure($: cheerio.CheerioAPI, title: string): QuranCourseContent | null {
    const surahs: Surah[] = [];
    let currentSurah: Surah | null = null;
    const allLessons: Lesson[] = [];

    // First, extract column headers to determine group names
    let groupNames: string[] = [];
    const $headerRow = $('.col-12.col-md-7').first();
    if ($headerRow.length > 0) {
      const $headerCols = $headerRow.find('.col-3, .col-md-3').toArray();
      groupNames = $headerCols.map((col) => {
        const text = cleanText($(col).text());
        // Use desktop text if available, otherwise use shortened text
        return text || 'Item';
      });
    }

    // If no headers found, use defaults
    if (groupNames.length === 0) {
      groupNames = ['Root words', 'Translation', 'Tafseer', 'Ref. Material'];
    }

    // Find all containers that might have lesson rows
    const $containers = $('.container.my-3').toArray();

    for (const container of $containers) {
      const $container = $(container);

      // Check if this is a Juz/Surah header
      const $juzHeader = $container.find('.row').first();
      const headerText = cleanText($juzHeader.text());

      // Detect Juz header (e.g., "Juz 1 الم")
      if (headerText.match(/^Juz \d+/i) || headerText.match(/^الم|^يس|^حم/)) {
        // Save previous surah if exists
        if (currentSurah && currentSurah.lessons.length > 0) {
          surahs.push(currentSurah);
        }

        // Create new surah for this Juz
        currentSurah = {
          name: headerText,
          arabicName: null,
          description: null,
          groups: groupNames.map(name => ({ name })),
          lessons: [],
        };
        continue;
      }

      // Check if this is a Surah name header
      if (headerText.match(/^Surah /i) || headerText.match(/^[A-Z][a-z]+-/)) {
        // This is a surah name - update current surah or create new one
        if (!currentSurah) {
          currentSurah = {
            name: headerText,
            arabicName: null,
            description: null,
            groups: groupNames.map(name => ({ name })),
            lessons: [],
          };
        } else {
          currentSurah.name = headerText;
        }
        continue;
      }

      // Extract lesson from this container
      const $lessonRow = $container.find('.row.g-2.border').first();
      if ($lessonRow.length > 0) {
        const $titleCol = $lessonRow.find('.col-12.col-md-5').first();
        const lessonTitle = cleanText($titleCol.text());

        if (lessonTitle) {
          const $itemsContainer = $lessonRow.find('.col-12.col-md-7').first();
          const itemGroups: ItemGroup[] = [];

          if ($itemsContainer.length > 0) {
            const $itemCols = $itemsContainer.find('.row > .col-3, .row > .col-md-3').toArray();

            for (const col of $itemCols) {
              const $col = $(col);
              const items: Item[] = [];

              // Extract all links in this column
              const links = $col.find('a').toArray();
              for (const link of links) {
                const $link = $(link);
                const href = $link.attr('href');
                if (href) {
                  const absoluteUrl = toAbsoluteUrl(href, this.baseUrl);
                  items.push(createItem(absoluteUrl));
                }
              }

              itemGroups.push({ items });
            }
          }

          const lesson: Lesson = {
            title: lessonTitle,
            lessonNum: null,
            ayahNum: null,
            uploadDate: null,
            itemGroups,
          };

          if (currentSurah) {
            currentSurah.lessons.push(lesson);
          } else {
            allLessons.push(lesson);
          }
        }
      }
    }

    // Save last surah
    if (currentSurah && currentSurah.lessons.length > 0) {
      surahs.push(currentSurah);
    }

    // If we have lessons but no surahs, create a default surah
    if (surahs.length === 0 && allLessons.length > 0) {
      surahs.push({
        name: 'Course Content',
        arabicName: null,
        description: null,
        groups: groupNames.map(name => ({ name })),
        lessons: allLessons,
      });
    }

    const content: QuranCourseContent = {
      id: title.toLowerCase().replace(/\s+/g, '-'),
      title: title,
      surahs,
    };

    const totalLessons = surahs.reduce((sum, s) => sum + s.lessons.length, 0);
    console.log(`  Scraped: ${surahs.length} surahs, ${totalLessons} total lessons`);

    return content;
  }
}
