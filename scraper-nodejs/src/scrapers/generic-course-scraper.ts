/**
 * GENERIC course content scraper
 * Works with ANY Bootstrap-based course page by detecting patterns automatically
 * instead of hardcoding specific column widths or selectors
 */

import * as cheerio from 'cheerio';
import { BaseScraper } from '../core/scraper-base';
import { QuranCourseContent, Surah, Lesson, ItemGroup, Item } from '../types/models';
import { createItem } from '../utils/content-type.utils';
import { toAbsoluteUrl } from '../utils/url.utils';
import { cleanText } from '../utils/text.utils';

interface RowAnalysis {
  $row: cheerio.Cheerio<any>;
  columns: {
    $col: cheerio.Cheerio<any>;
    text: string;
    linkCount: number;
    hasMedia: boolean;
  }[];
  type: 'header' | 'lesson' | 'unknown';
  bgColor?: string;
}

export class GenericCourseScraper extends BaseScraper<QuranCourseContent | null> {
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

      // Check if page has a multi-page selector (like #selectJuz)
      const $selector = $('select[id*="select" i], select[onchange*="location"]');
      if ($selector.length > 0) {
        console.log(`  📚 Found page selector - scraping all available pages`);
        return await this.scrapeMultiPage($, $selector);
      }

      // Single page scraping
      console.log(`  📄 Scraping single-page course: ${this.url}`);
      const rawData = this.scrapePageGeneric($);

      if (!rawData || rawData.surahs.length === 0) {
        console.warn(`  ⚠️  No lessons found for ${this.url}`);
        return null;
      }

      return this.convertToFinalStructure(rawData);
    } catch (error) {
      console.error(`  ❌ Error scraping course content from ${this.url}:`, error);
      return null;
    }
  }

  /**
   * Scrape multiple pages using a dropdown selector
   */
  private async scrapeMultiPage($: cheerio.CheerioAPI, $selector: cheerio.Cheerio<any>): Promise<QuranCourseContent | null> {
    const allSurahs: Surah[] = [];
    const allPracticeWords: Item[] = [];
    const allIntroLessons: Lesson[] = [];
    const pages: string[] = [];
    const scrapedUrls = new Set<string>();

    // Extract all page URLs from selector
    $selector.find('option').each((_: any, option: any) => {
      const $option = $(option);
      const value = $option.attr('value');
      if (value && !value.toLowerCase().includes('please') && !value.toLowerCase().includes('select')) {
        pages.push(value);
      }
    });

    if (pages.length === 0) {
      console.warn('  ⚠️  No pages found in selector');
      return null;
    }

    console.log(`  📋 Found ${pages.length} pages to scrape`);

    const baseUrl = this.url.substring(0, this.url.lastIndexOf('/') + 1);

    // Scrape each page
    for (let i = 0; i < pages.length; i++) {
      const page = pages[i];
      const pageUrl = baseUrl + page;

      if (scrapedUrls.has(page)) {
        console.log(`    ⏭️  Skipping page ${i + 1}/${pages.length}: ${page} (already scraped)`);
        continue;
      }

      console.log(`    📑 Scraping page ${i + 1}/${pages.length}: ${page}`);
      scrapedUrls.add(page);

      try {
        const $pageDoc = await this.navigateTo(pageUrl);
        if (!$pageDoc) {
          console.warn(`    ⚠️  Failed to load page ${page}`);
          continue;
        }

        const pageData = this.scrapePageGeneric($pageDoc);
        if (pageData) {
          if (pageData.surahs.length > 0) allSurahs.push(...pageData.surahs);
          if (pageData.practiceWords.length > 0) allPracticeWords.push(...pageData.practiceWords);
          if (pageData.introductionLessons.length > 0) allIntroLessons.push(...pageData.introductionLessons);
          console.log(`    ✓ Added ${pageData.surahs.length} surahs from page ${i + 1}`);
        }
      } catch (error) {
        console.error(`    ❌ Error scraping page ${page}:`, error);
      }
    }

    if (allSurahs.length === 0) {
      console.warn('  ⚠️  No surahs found across all pages');
      return null;
    }

    return this.convertToFinalStructure({
      surahs: allSurahs,
      practiceWords: allPracticeWords,
      introductionLessons: allIntroLessons,
      groupNames: allSurahs[0]?.groups?.map(g => g.name) || []
    });
  }

  /**
   * GENERIC page scraping - works with any Bootstrap course page structure
   */
  private scrapePageGeneric($: cheerio.CheerioAPI): { surahs: Surah[], practiceWords: Item[], introductionLessons: Lesson[], groupNames: string[] } | null {
    const surahs: Surah[] = [];
    let currentSurah: Surah | null = null;
    const introductionLessons: Lesson[] = [];
    const practiceWords: Item[] = [];
    let isInIntroduction = false;

    // Step 1: Analyze all rows with borders to understand the structure
    const rowAnalyses: RowAnalysis[] = [];
    $('.row.border, .row[class*="border"]').each((_: any, row: any) => {
      const $row = $(row);
      const analysis = this.analyzeRow($, $row);
      if (analysis) {
        rowAnalyses.push(analysis);
      }
    });

    // Step 2: Extract group names from first header row with text-only columns
    let groupNames: string[] = [];
    for (const analysis of rowAnalyses) {
      if (analysis.type === 'header' && !analysis.bgColor) {
        // This is likely a column header row
        const textOnlyCols = analysis.columns.filter(col => col.linkCount === 0 && col.text.length > 0);
        if (textOnlyCols.length > 0) {
          groupNames = textOnlyCols.map(col => col.text);
          break;
        }
      }
    }

    if (groupNames.length === 0) {
      groupNames = ['Items']; // Default
    }

    console.log(`  Detected ${groupNames.length} column groups: ${groupNames.join(', ')}`);

    // Step 3: Process all rows in document order
    for (const analysis of rowAnalyses) {
      const { $row, type, bgColor, columns } = analysis;

      // Check for Juz header
      const rowText = cleanText($row.text());
      if (bgColor && rowText.match(/^Juz \d+/i)) {
        if (currentSurah && currentSurah.lessons.length > 0) {
          surahs.push(currentSurah);
        }
        isInIntroduction = false;
        currentSurah = null;
        continue;
      }

      // Check for Surah header
      if (bgColor && $row.find('strong').length > 0 && !rowText.match(/^Juz/i)) {
        const surahText = cleanText($row.find('strong').text());
        if (surahText && !surahText.toLowerCase().includes('lesson')) {
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
      }

      // Check for Introduction header
      if ($row.find('strong').text().trim() === 'Introduction') {
        isInIntroduction = true;
        if (currentSurah && currentSurah.lessons.length > 0) {
          surahs.push(currentSurah);
          currentSurah = null;
        }
        continue;
      }

      // Check for Practice Words section
      if (rowText.toLowerCase().includes('practice words') || rowText.toLowerCase().includes('practice word')) {
        // Extract PDF links
        $row.find('a').each((_: any, link: any) => {
          const href = $(link).attr('href');
          if (href && (href.toLowerCase().includes('.pdf') || $(link).find('img[alt*="pdf"]').length > 0)) {
            practiceWords.push(createItem(toAbsoluteUrl(href, this.baseUrl)));
          }
        });
        continue;
      }

      // Check if this is a lesson row
      if (type === 'lesson') {
        const lesson = this.extractLessonFromRow($, $row, columns, groupNames.length);
        if (lesson) {
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
    console.log(`  Scraped: ${surahs.length} surahs, ${totalLessons} lessons, ${introductionLessons.length} intro lessons, ${practiceWords.length} practice PDFs`);

    return { surahs, practiceWords, introductionLessons, groupNames };
  }

  /**
   * Analyze a row to determine its type and extract column information
   */
  private analyzeRow($: cheerio.CheerioAPI, $row: cheerio.Cheerio<any>): RowAnalysis | null {
    // Get all columns (children divs with col- classes)
    const $allCols = $row.children('[class*="col-"]');

    if ($allCols.length === 0) return null;

    const columns = $allCols.toArray().map((col: any) => {
      const $col = $(col);
      const text = cleanText($col.text());
      const $links = $col.find('a');
      const linkCount = $links.length;
      const hasMedia = $col.find('img, audio, video, i[class*="fa-"], i[class*="bi-"]').length > 0;

      return { $col, text, linkCount, hasMedia };
    });

    // Determine row type
    const style = $row.attr('style') || '';
    const bgColor = style.match(/background[^:]*:\s*([^;]+)/)?.[1]?.trim();

    let type: 'header' | 'lesson' | 'unknown' = 'unknown';

    if (bgColor) {
      type = 'header';
    } else {
      // It's a lesson if it has at least one column with text and at least one column with links
      const hasTextCol = columns.some(col => col.text.length > 10 && col.linkCount === 0);
      const hasLinkCol = columns.some(col => col.linkCount > 0);

      if (hasTextCol && hasLinkCol) {
        type = 'lesson';
      }
    }

    return { $row, columns, type, bgColor };
  }

  /**
   * Extract lesson data from a row
   */
  private extractLessonFromRow($: cheerio.CheerioAPI, _$row: cheerio.Cheerio<any>, columns: RowAnalysis['columns'], _expectedGroupCount: number): Lesson | null {
    // Find title column (most text, fewest links)
    let titleCol = columns[0]; // default to first
    for (const col of columns) {
      if (col.text.length > titleCol.text.length && col.linkCount === 0) {
        titleCol = col;
      }
    }

    const lessonTitle = titleCol.text;
    if (!lessonTitle) return null;

    // All other columns are item columns
    const itemCols = columns.filter(col => col !== titleCol);

    const itemGroups: ItemGroup[] = [];

    for (const col of itemCols) {
      const items: Item[] = [];

      // Extract all links
      col.$col.find('a').each((_: any, link: any) => {
        const href = $(link).attr('href');
        if (href) {
          const absoluteUrl = toAbsoluteUrl(href, this.baseUrl);
          items.push(createItem(absoluteUrl));
        }
      });

      itemGroups.push({ items });
    }

    return {
      title: lessonTitle,
      lessonNum: null,
      ayahNum: null,
      uploadDate: null,
      itemGroups,
    };
  }

  /**
   * Convert raw data to final QuranCourseContent structure
   */
  private convertToFinalStructure(rawData: { surahs: Surah[], practiceWords: Item[], introductionLessons: Lesson[], groupNames: string[] }): QuranCourseContent {
    const specialSurahs: Surah[] = [];

    // Convert introduction lessons
    if (rawData.introductionLessons.length > 0) {
      specialSurahs.push({
        name: 'Introduction',
        arabicName: null,
        description: null,
        groups: rawData.groupNames.map(name => ({ name })),
        lessons: rawData.introductionLessons,
      });
    }

    // Convert practice words
    if (rawData.practiceWords.length > 0) {
      const itemGroups: ItemGroup[] = rawData.practiceWords.map(item => ({ items: [item] }));
      while (itemGroups.length < rawData.groupNames.length) {
        itemGroups.push({ items: [] });
      }

      specialSurahs.push({
        name: 'Practice Words',
        arabicName: null,
        description: null,
        groups: rawData.groupNames.map(name => ({ name })),
        lessons: [{
          title: 'Practice Word PDFs',
          lessonNum: null,
          ayahNum: null,
          uploadDate: null,
          itemGroups,
        }],
      });
    }

    const finalSurahs = [...specialSurahs, ...rawData.surahs];
    const totalLessons = finalSurahs.reduce((sum, s) => sum + s.lessons.length, 0);
    console.log(`  Final: ${finalSurahs.length} surahs (including special sections), ${totalLessons} total lessons`);

    // Extract title from URL or use default
    const urlParts = this.url.split('/');
    const fileName = urlParts[urlParts.length - 2] || 'course';
    const title = fileName.replace(/_/g, ' ').replace(/-/g, ' ');

    return {
      id: title.toLowerCase().replace(/\s+/g, '-'),
      title: title,
      surahs: finalSurahs,
    };
  }
}
