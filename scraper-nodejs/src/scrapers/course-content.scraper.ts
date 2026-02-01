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
      const rawData = this.scrapeNewStructureRaw($, title);

      if (!rawData || rawData.surahs.length === 0) {
        console.warn(`  ⚠️  No lessons found for ${this.url} (page may be under construction)`);
        return null;
      }

      // Convert to final structure
      const content = this.convertRawDataToContent(rawData, title, rawData.groupNames);
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
    const allPracticeWords: Item[] = [];
    const allIntroductionLessons: Lesson[] = [];
    const juzPages: string[] = [];
    const scrapedUrls = new Set<string>(); // Track already scraped URLs

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
      console.warn('  ⚠️  No Juz pages found in selector');
      return null;
    }

    console.log(`  📋 Found ${juzPages.length} Juz pages to scrape`);

    // Determine the base URL for Juz pages
    const baseUrl = this.url.substring(0, this.url.lastIndexOf('/') + 1);

    // Scrape each Juz page sequentially
    for (let i = 0; i < juzPages.length; i++) {
      const juzPage = juzPages[i];
      const juzUrl = baseUrl + juzPage;

      // Skip if we've already scraped this URL
      if (scrapedUrls.has(juzPage)) {
        console.log(`    ⏭️  Skipping Juz ${i + 1}/${juzPages.length}: ${juzPage} (already scraped)`);
        continue;
      }

      console.log(`    📑 Scraping Juz ${i + 1}/${juzPages.length}: ${juzPage}`);
      scrapedUrls.add(juzPage);

      try {
        const $juzDoc = await this.navigateTo(juzUrl);

        if (!$juzDoc) {
          console.warn(`    ⚠️  Failed to load Juz page ${juzPage} - stopping`);
          break;
        }

        // Check if this page still has the selector (if not, content is not available yet)
        if ($juzDoc('#selectJuz').length === 0) {
          console.warn(`    ⏹️  Juz page ${juzPage} doesn't have selector - content not available, stopping`);
          break;
        }

        // Scrape raw content from this Juz page (returns temporary structure)
        const juzRawData = this.scrapeNewStructureRaw($juzDoc, title);
        if (juzRawData) {
          if (juzRawData.surahs.length > 0) {
            allSurahs.push(...juzRawData.surahs);
          }
          if (juzRawData.practiceWords.length > 0) {
            allPracticeWords.push(...juzRawData.practiceWords);
          }
          if (juzRawData.introductionLessons.length > 0) {
            allIntroductionLessons.push(...juzRawData.introductionLessons);
          }
          console.log(`    ✓ Added ${juzRawData.surahs.length} surahs from Juz ${i + 1}`);
        } else {
          console.warn(`    ⚠️  No content found in Juz ${i + 1}`);
        }
      } catch (error) {
        console.error(`    ❌ Error scraping Juz page ${juzPage}:`, error);
        // Continue to next page on error
      }
    }

    if (allSurahs.length === 0) {
      console.warn('  ⚠️  No surahs found across all Juz pages');
      return null;
    }

    // Convert to final structure
    const content = this.convertRawDataToContent(
      {
        surahs: allSurahs,
        practiceWords: allPracticeWords,
        introductionLessons: allIntroductionLessons,
        groupNames: ['Root words', 'Translation', 'Tafseer', 'Ref. Material']
      },
      title,
      ['Root words', 'Translation', 'Tafseer', 'Ref. Material']
    );

    return content;
  }

  /**
   * Scrape new Bootstrap structure (col-12 col-md-5 for titles, col-12 col-md-7 for items)
   * Returns raw data before conversion to final structure
   */
  private scrapeNewStructureRaw($: cheerio.CheerioAPI, _title: string): { surahs: Surah[], practiceWords: Item[], introductionLessons: Lesson[], groupNames: string[] } | null {
    const surahs: Surah[] = [];
    let currentSurah: Surah | null = null;
    const introductionLessons: Lesson[] = [];
    const practiceWords: Item[] = [];
    let isInIntroduction = false;

    // First, extract column headers to determine group names
    let groupNames: string[] = [];

    // Look for header rows by finding .row.border elements that have text-only columns (no links)
    const $rows = $('.row.border').toArray();
    for (const row of $rows) {
      const $row = $(row);

      // Try standard pattern: col-12 col-md-5 for title, col-12 col-md-7 for items
      const $titleCol = $row.find('.col-12.col-md-5').first();
      const $itemsContainer = $row.find('.col-12.col-md-7').first();

      if ($titleCol.length > 0 && $itemsContainer.length > 0) {
        // Check if title column is empty or nearly empty (header row indicator)
        const titleText = cleanText($titleCol.text());

        if (titleText.length === 0 || titleText.length < 3) {
          // This looks like a header row - extract column headers
          const $headerCols = $itemsContainer.find('.row > .col-3, .row > .col-md-3, .row > div[class*="col-"]').toArray();

          // Verify these are text-only columns (no links)
          const hasNoLinks = $headerCols.every((col: any) => $(col).find('a').length === 0);
          const hasText = $headerCols.some((col: any) => cleanText($(col).text()).length > 0);

          if (hasNoLinks && hasText && $headerCols.length > 0) {
            groupNames = $headerCols.map((col: any) => cleanText($(col).text()) || 'Item');
            console.log(`  Found ${groupNames.length} column headers: ${groupNames.join(', ')}`);
            break;
          }
        }
      }

      // Try ATQ pattern: col-12 col-md-8 for title, col-md-2 for items
      if (groupNames.length === 0) {
        const $titleColAlt = $row.find('.col-12.col-md-8').first();
        const $itemCols = $row.find('.col-6.col-md-2, .col-md-2').toArray()
          .filter((col: any) => !$(col).is($titleColAlt));

        // Check if this row has text-only columns (header row)
        if ($itemCols.length > 0 && $itemCols.every((col: any) => $(col).find('a').length === 0)) {
          const hasText = $itemCols.some((col: any) => cleanText($(col).text()).length > 0);
          if (hasText) {
            groupNames = $itemCols.map((col: any) => cleanText($(col).text()) || 'Item');
            console.log(`  Found ${groupNames.length} column headers (ATQ pattern): ${groupNames.join(', ')}`);
            break;
          }
        }
      }
    }

    // If no headers found, use defaults
    if (groupNames.length === 0) {
      groupNames = ['Root words', 'Translation', 'Tafseer', 'Ref. Material'];
      console.log(`  No headers found, using defaults: ${groupNames.join(', ')}`);
    }

    // Collect all containers and standalone rows in document order
    // We'll assign each element a sequence number as we encounter it
    const allElements: Array<{ type: 'container' | 'row', element: any, order: number }> = [];
    let orderCounter = 0;

    // First pass: collect all elements with their document order
    // Use a single traversal of the document to maintain natural order
    $('*').each((_: any, elem: any) => {
      const $elem = $(elem);

      // Check if this is a container we care about
      if ($elem.hasClass('container') && ($elem.hasClass('my-3') || $elem.hasClass('my-4'))) {
        allElements.push({ type: 'container', element: elem, order: orderCounter++ });
      }
      // Check if this is a standalone header row
      else if ($elem.hasClass('row')) {
        const style = $elem.attr('style') || '';
        // Only include standalone rows with header styling
        if ((style.includes('#0a2e4f') || style.includes('#ecece3')) &&
            !$elem.closest('.container').hasClass('my-3')) {
          allElements.push({ type: 'row', element: elem, order: orderCounter++ });
        }
      }
    });

    // Elements are already in document order from the traversal above
    // No sorting needed!

    for (const item of allElements) {
      if (item.type === 'row') {
        // Process standalone row (header only)
        const $row = $(item.element);
        const rowText = cleanText($row.text());
        const bgStyle = $row.attr('style') || '';

        // Check if this is a Juz header
        const hasJuzStyling = bgStyle.includes('#0a2e4f');
        if (hasJuzStyling && rowText.match(/^Juz \d+/i)) {
          if (currentSurah && currentSurah.lessons.length > 0) {
            surahs.push(currentSurah);
          }
          isInIntroduction = false;
          currentSurah = null;
          continue;
        }

        // Check if this is a Surah header
        const hasSurahStyling = bgStyle.includes('#ecece3');
        if (hasSurahStyling && $row.find('strong').length > 0) {
          const surahText = cleanText($row.find('strong').text());
          if (currentSurah && currentSurah.lessons.length > 0) {
            surahs.push(currentSurah);
          }
          currentSurah = {
            name: surahText,
            arabicName: null,
            description: null,
            groups: groupNames.map(name => ({ name })),
            lessons: [],
          };
          isInIntroduction = false;
          continue;
        }

        // Check if this is Introduction header
        if ($row.find('strong').text().trim() === 'Introduction') {
          isInIntroduction = true;
          if (currentSurah && currentSurah.lessons.length > 0) {
            surahs.push(currentSurah);
            currentSurah = null;
          }
          continue;
        }
        continue;
      }

      // Process container
      const $container = $(item.element);

      // Check if this is the practice words section (container.my-4)
      if ($container.hasClass('my-4')) {
        const containerText = cleanText($container.text());
        if (containerText.toLowerCase().includes('practice words')) {
          // Extract all PDF links from this section
          const links = $container.find('a').toArray();
          for (const link of links) {
            const $link = $(link);
            const href = $link.attr('href');
            if (href && (href.toLowerCase().includes('.pdf') || $link.find('img[alt*="pdf"]').length > 0)) {
              const absoluteUrl = toAbsoluteUrl(href, this.baseUrl);
              practiceWords.push(createItem(absoluteUrl));
            }
          }
        }
        continue;
      }

      // Process all rows in this container to handle multiple headers
      const $rows = $container.find('.row').toArray();

      for (const row of $rows) {
        const $row = $(row);
        const rowText = cleanText($row.text());

        // Check if this is an "Introduction" header
        if ($row.find('strong').text().trim() === 'Introduction') {
          isInIntroduction = true;
          // Mark that we're no longer in a surah section
          if (currentSurah && currentSurah.lessons.length > 0) {
            surahs.push(currentSurah);
            currentSurah = null;
          }
          continue;
        }

        // Check if this is a Juz header (styled with dark blue background)
        const bgStyle = $row.attr('style') || '';
        const hasJuzStyling = bgStyle.includes('#0a2e4f') || bgStyle.includes('0a2e4f');

        if (hasJuzStyling && rowText.match(/^Juz \d+/i)) {
          // Save previous surah if exists
          if (currentSurah && currentSurah.lessons.length > 0) {
            surahs.push(currentSurah);
          }

          // Juz headers don't create surahs yet - wait for Surah header
          isInIntroduction = false;
          currentSurah = null;
          continue;
        }

        // Check if this is a Surah header (styled with light beige background)
        const hasSurahStyling = bgStyle.includes('#ecece3') || bgStyle.includes('ecece3');

        if (hasSurahStyling && $row.find('strong').length > 0) {
          // This is a surah name header
          const surahText = cleanText($row.find('strong').text());

          // Save previous surah if exists
          if (currentSurah && currentSurah.lessons.length > 0) {
            surahs.push(currentSurah);
          }

          // Create new surah
          currentSurah = {
            name: surahText,
            arabicName: null,
            description: null,
            groups: groupNames.map(name => ({ name })),
            lessons: [],
          };
          isInIntroduction = false;
          continue;
        }

        // Check if this is a lesson row
        // Support two patterns:
        // 1. Standard pattern: col-12 col-md-5 for title, col-12 col-md-7 for items container
        // 2. ATQ pattern: col-12 col-md-8 for title, col-6 col-md-2 directly as item columns
        let $titleCol = $row.find('.col-12.col-md-5').first();
        let $itemsContainer = $row.find('.col-12.col-md-7').first();
        let $itemCols: any[] = [];

        // Try standard pattern first
        if ($titleCol.length > 0 && $itemsContainer.length > 0) {
          // Standard pattern: items are in a container with nested columns
          // Find the nested row first, then get all its column children
          const $nestedRow = $itemsContainer.find('.row').first();
          if ($nestedRow.length > 0) {
            // Get all direct children that have a col- class
            $itemCols = $nestedRow.children('[class*="col-"]').toArray();
          }
        } else {
          // Try ATQ pattern: col-12 col-md-8 for title, col-md-2 directly as siblings
          $titleCol = $row.find('.col-12.col-md-8').first();
          if ($titleCol.length > 0) {
            // Item columns are siblings with col-md-2 class
            $itemCols = $row.find('.col-6.col-md-2, .col-md-2').toArray()
              .filter((col: any) => !$(col).is($titleCol)); // Exclude title column
          }
        }

        const lessonTitle = cleanText($titleCol.text());

        if (lessonTitle && $row.hasClass('border')) {
          const itemGroups: ItemGroup[] = [];

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

          // Ensure we have the correct number of itemGroups to match the header groups
          // Pad with empty groups if needed
          while (itemGroups.length < groupNames.length) {
            itemGroups.push({ items: [] });
          }

          const lesson: Lesson = {
            title: lessonTitle,
            lessonNum: null,
            ayahNum: null,
            uploadDate: null,
            itemGroups,
          };

          // Add to introduction lessons if we're in that section
          if (isInIntroduction) {
            introductionLessons.push(lesson);
          } else if (currentSurah) {
            currentSurah.lessons.push(lesson);
          }
        }
      }
    }

    // Save last surah
    if (currentSurah && currentSurah.lessons.length > 0) {
      surahs.push(currentSurah);
    }

    const totalLessons = surahs.reduce((sum, s) => sum + s.lessons.length, 0);
    const practiceWordsCount = practiceWords.length;
    const introLessonsCount = introductionLessons.length;

    console.log(`  Scraped: ${surahs.length} surahs, ${totalLessons} lessons, ${introLessonsCount} intro lessons, ${practiceWordsCount} practice PDFs`);

    return {
      surahs,
      practiceWords,
      introductionLessons,
      groupNames
    };
  }

  /**
   * Convert raw scraped data into final QuranCourseContent structure
   */
  private convertRawDataToContent(
    rawData: { surahs: Surah[], practiceWords: Item[], introductionLessons: Lesson[], groupNames: string[] },
    title: string,
    groupNames: string[]
  ): QuranCourseContent {
    // Convert special sections into regular Surahs
    const finalSurahs = this.convertSpecialSectionsToSurahs(
      rawData.surahs,
      rawData.practiceWords,
      rawData.introductionLessons,
      groupNames
    );

    const totalLessons = finalSurahs.reduce((sum, s) => sum + s.lessons.length, 0);
    console.log(`  Final: ${finalSurahs.length} surahs (including special sections), ${totalLessons} total lessons`);

    return {
      id: title.toLowerCase().replace(/\s+/g, '-'),
      title: title,
      surahs: finalSurahs,
    };
  }

  /**
   * Convert practice words and introduction lessons into regular Surahs
   * so they can be displayed in the app without special handling
   */
  private convertSpecialSectionsToSurahs(
    surahs: Surah[],
    practiceWords: Item[],
    introductionLessons: Lesson[],
    groupNames: string[]
  ): Surah[] {
    const specialSurahs: Surah[] = [];

    // Convert introduction lessons into a Surah
    if (introductionLessons.length > 0) {
      specialSurahs.push({
        name: 'Introduction',
        arabicName: null,
        description: null,
        groups: groupNames.map(name => ({ name })),
        lessons: introductionLessons,
      });
    }

    // Convert practice words into a Surah with a single lesson
    if (practiceWords.length > 0) {
      // Group practice words into item groups (one group per practice word)
      const itemGroups: ItemGroup[] = practiceWords.map(item => ({
        items: [item]
      }));

      // Pad with empty groups to match the number of columns
      while (itemGroups.length < groupNames.length) {
        itemGroups.push({ items: [] });
      }

      specialSurahs.push({
        name: 'Practice Words',
        arabicName: null,
        description: null,
        groups: groupNames.map(name => ({ name })),
        lessons: [{
          title: 'Practice Word PDFs',
          lessonNum: null,
          ayahNum: null,
          uploadDate: null,
          itemGroups,
        }],
      });
    }

    // Return special surahs first, then regular surahs
    return [...specialSurahs, ...surahs];
  }
}
