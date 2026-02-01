/**
 * UNIVERSAL course scraper - auto-detects any Bootstrap course page structure
 * Works by analyzing the DOM structure rather than relying on specific CSS classes
 */

import * as cheerio from 'cheerio';
import { BaseScraper } from '../core/scraper-base';
import { QuranCourseContent, Surah, Lesson, Item, ItemGroup } from '../types/models';
import { createItem } from '../utils/content-type.utils';
import { toAbsoluteUrl } from '../utils/url.utils';
import { cleanText } from '../utils/text.utils';

export class UniversalCourseScraper extends BaseScraper<QuranCourseContent | null> {
  private url: string;

  constructor(httpClient: any, url: string) {
    super(httpClient);
    this.url = url;
  }

  async scrape(): Promise<QuranCourseContent | null> {
    try {
      const $ = await this.navigateTo(this.url);
      if (!$) {
        console.warn(`  ⚠️  Failed to load: ${this.url}`);
        return null;
      }

      // Check for tab-based navigation first
      const $navTabs = $('.nav.nav-tabs, .nav-tabs');
      if ($navTabs.length > 0) {
        return await this.scrapeTabBasedPages($, $navTabs);
      }

      // Check for multi-page selector
      const $selector = $('select[id*="select" i], select[onchange*="location"]');
      if ($selector.length > 0) {
        return await this.scrapeMultiPage($, $selector);
      }

      // Single page
      const rawData = this.scrapePage($);
      return rawData ? this.finalize(rawData) : null;
    } catch (error) {
      console.error(`  ❌ Error scraping ${this.url}:`, error);
      return null;
    }
  }

  private async scrapeMultiPage($: cheerio.CheerioAPI, $selector: cheerio.Cheerio<any>): Promise<QuranCourseContent | null> {
    const allSurahs: Surah[] = [];
    const pages: string[] = [];
    const seen = new Set<string>();

    $selector.find('option').each((_: any, opt: any) => {
      const val = $(opt).attr('value');
      if (val && !val.toLowerCase().match(/please|select/)) {
        pages.push(val);
      }
    });

    if (pages.length === 0) return null;

    console.log(`  📚 Multi-page course: ${pages.length} pages`);
    const baseUrl = this.url.substring(0, this.url.lastIndexOf('/') + 1);

    for (let i = 0; i < pages.length; i++) {
      if (seen.has(pages[i])) continue;
      seen.add(pages[i]);

      console.log(`    📑 Page ${i + 1}/${pages.length}: ${pages[i]}`);

      const $page = await this.navigateTo(baseUrl + pages[i]);
      if (!$page) {
        console.log(`    ❌ Page failed to load - aborting multi-page scraping`);
        break; // Stop processing remaining pages
      }

      // Validate that this page has the same selector structure
      const $pageSelector = $page('select[id*="select" i], select[onchange*="location"]');
      if ($pageSelector.length === 0) {
        console.log(`    ❌ Invalid page (no selector found) - aborting multi-page scraping`);
        break; // Stop processing remaining pages
      }

      const data = this.scrapePage($page);
      if (data && data.surahs && data.surahs.length > 0) {
        allSurahs.push(...data.surahs);
      }
    }

    return allSurahs.length > 0 ? this.finalize({ surahs: allSurahs }) : null;
  }

  private async scrapeTabBasedPages($: cheerio.CheerioAPI, $navTabs: cheerio.Cheerio<any>): Promise<QuranCourseContent | null> {
    const allSurahs: Surah[] = [];
    const tabs: Array<{ name: string; url: string; isDirectMedia: boolean }> = [];

    // Extract tab links
    $navTabs.find('.nav-item').each((_: any, item: any) => {
      const $link = $(item).find('a').first();
      const href = $link.attr('href');
      const text = cleanText($link.text());

      if (href && text) {
        const isDirectMedia = !!href.match(/\.(mp3|mp4|pdf|ppsx)$/i);
        tabs.push({ name: text, url: href, isDirectMedia });
      }
    });

    if (tabs.length === 0) {
      // No valid tabs found, scrape current page normally
      const data = this.scrapePage($);
      return data ? this.finalize(data) : null;
    }

    console.log(`  📑 Tab-based course: ${tabs.length} tabs`);
    const baseUrl = this.url.substring(0, this.url.lastIndexOf('/') + 1);

    for (let i = 0; i < tabs.length; i++) {
      const tab = tabs[i];
      console.log(`    📂 Tab ${i + 1}/${tabs.length}: ${tab.name}`);

      // Resolve relative URLs
      const tabUrl = tab.url.startsWith('http')
        ? tab.url
        : toAbsoluteUrl(tab.url, baseUrl);

      if (tab.isDirectMedia) {
        // Create a simple surah with one lesson containing the direct media link
        const mediaItem = createItem(tabUrl);
        allSurahs.push({
          name: tab.name,
          arabicName: null,
          description: null,
          groups: [{ name: 'Media' }],
          lessons: [{
            title: tab.name,
            lessonNum: null,
            ayahNum: null,
            uploadDate: null,
            itemGroups: [{ items: [mediaItem] }]
          }]
        });
      } else {
        const $tabPage = await this.navigateTo(tabUrl);
        if ($tabPage) {
          const data = this.scrapePage($tabPage);
          if (data && data.surahs && data.surahs.length > 0) {
            // Rename the surah to match the tab name
            data.surahs.forEach((surah: Surah) => {
              surah.name = tab.name;
            });
            allSurahs.push(...data.surahs);
          }
        }
      }
    }

    return allSurahs.length > 0 ? this.finalize({ surahs: allSurahs }) : null;
  }

  private scrapePage($: cheerio.CheerioAPI): { surahs: Surah[] } | null {
    // Try different scraping strategies in order
    let result = this.scrapeBootstrapRows($);
    if (result) return result;

    result = this.scrapeTabbedInterface($);
    if (result) return result;

    result = this.scrapeSimpleList($);
    if (result) return result;

    return null;
  }

  /**
   * Strategy 1: Bootstrap rows with bordered structure
   */
  private scrapeBootstrapRows($: cheerio.CheerioAPI): { surahs: Surah[] } | null {
    const surahs: Surah[] = [];
    let currentSurah: Surah | null = null;

    // Find ALL rows with borders - these are our content rows
    const $rows = $('.row').filter((_: any, el: any) => {
      const $el = $(el);
      return $el.attr('class')?.includes('border') || $el.hasClass('border');
    });

    console.log(`  Found ${$rows.length} bordered rows`);
    if ($rows.length === 0) return null;

    let groupNames: string[] = [];

    // First pass: detect header row with nested structure (like tafseer2025)
    if (groupNames.length === 0) {
      for (const row of $rows.toArray()) {
        const $row = $(row);

        // Look for pattern: col-md-5 (empty title) + col-md-7 (container with nested headers)
        const $titleCol = $row.find('.col-12.col-md-5').first();
        const $itemsContainer = $row.find('.col-12.col-md-7').first();

        if ($titleCol.length > 0 && $itemsContainer.length > 0) {
          const titleText = cleanText($titleCol.text());

          // Header row has empty or very short title
          if (titleText.length < 3) {
            const $nestedRow = $itemsContainer.find('.row').first();
            if ($nestedRow.length > 0) {
              const $headerCols = $nestedRow.children('[class*="col-"]').toArray();
              const hasNoLinks = $headerCols.every((col: any) => $(col).find('a').length === 0);
              const hasText = $headerCols.some((col: any) => cleanText($(col).text()).length > 0);

              if (hasNoLinks && hasText && $headerCols.length > 0) {
                groupNames = $headerCols.map((col: any) => {
                  const $col = $(col);
                  // Try to get desktop-only text first (removes mobile abbreviations)
                  const $desktopSpan = $col.find('.d-none.d-md-inline');
                  if ($desktopSpan.length > 0) {
                    return cleanText($desktopSpan.text()) || 'Item';
                  }
                  // Fallback to full text
                  return cleanText($col.text()) || 'Item';
                });
                console.log(`  Detected ${groupNames.length} column headers: ${groupNames.join(', ')}`);
                break;
              }
            }
          }
        }
      }
    }

    $rows.each((_: any, row: any) => {
      const $row = $(row);

      // Get all columns (children with col- class)
      const $cols = $row.children('[class*="col-"]');
      if ($cols.length === 0) return;

      // Analyze columns
      const cols = $cols.toArray().map((col: any) => {
        const $col = $(col);
        // Try to get desktop-only text first (removes mobile abbreviations)
        const $desktopSpan = $col.find('.d-none.d-md-inline');
        const text = $desktopSpan.length > 0
          ? cleanText($desktopSpan.text())
          : cleanText($col.text());
        return {
          $col,
          text,
          links: $col.find('a').length,
        };
      });

      const style = $row.attr('style') || '';
      const text = cleanText($row.text());

      // 1. Check if this is a Juz/Surah/Introduction header (has background color or strong tag)
      if (style.match(/#[0-9a-f]{6}/i) || $row.find('strong').length > 0) {
        const strongText = cleanText($row.find('strong').text());

        if (text.match(/^Juz \d+/i) || strongText.match(/^Juz \d+/i)) {
          // Juz header - save current surah
          if (currentSurah && currentSurah.lessons && currentSurah.lessons.length > 0) {
            surahs.push(currentSurah);
          }
          currentSurah = null;
        } else if (strongText === 'Introduction') {
          // Introduction header - save current surah and create Introduction surah
          if (currentSurah && currentSurah.lessons && currentSurah.lessons.length > 0) {
            surahs.push(currentSurah);
          }
          currentSurah = {
            name: 'Introduction',
            arabicName: null,
            description: null,
            groups: groupNames.map(n => ({ name: n })),
            lessons: [],
          };
        } else if (strongText && !strongText.toLowerCase().includes('lesson')) {
          // Surah header
          if (currentSurah && currentSurah.lessons && currentSurah.lessons.length > 0) {
            surahs.push(currentSurah);
          }
          currentSurah = {
            name: strongText,
            arabicName: null,
            description: null,
            groups: groupNames.map(n => ({ name: n })),
            lessons: [],
          };
        }
        return; // Skip to next row
      }

      // 2. Check if this is a column header row (text only, no links, short text)
      const allTextOnly = cols.every(c => c.links === 0);
      const hasShortText = cols.every(c => c.text.length < 50);

      if (allTextOnly && hasShortText && cols.some(c => c.text.length > 0)) {
        // This looks like a header row
        const headers = cols.filter(c => c.text.length > 0).map(c => c.text);
        if (headers.length >= 2 && groupNames.length === 0) {
          groupNames = headers;
          console.log(`  Detected headers: ${groupNames.join(', ')}`);

          // Update all surahs' groups if they were created before headers were detected
          surahs.forEach(surah => {
            if (surah.groups.length === 0) {
              surah.groups = groupNames.map(n => ({ name: n }));
            }
          });

          // Update current surah's groups if it exists and has empty groups
          if (currentSurah && currentSurah.groups.length === 0) {
            currentSurah.groups = groupNames.map(n => ({ name: n }));
          }
        }
        return; // Skip to next row
      }

      // 3. Check if this is a lesson row
      // Support two patterns:
      // Pattern A: col-md-5 (title) + col-md-7 (container with nested item columns)
      // Pattern B: one text column + multiple link columns (flat structure)

      let lessonTitle = '';
      let itemCols: any[] = [];

      // Try Pattern A first (nested structure like tafseer2025)
      const $titleCol = $row.find('.col-12.col-md-5').first();
      const $itemsContainer = $row.find('.col-12.col-md-7').first();

      if ($titleCol.length > 0 && $itemsContainer.length > 0) {
        const titleText = cleanText($titleCol.text());

        // Lesson rows have actual titles (not empty like header rows)
        if (titleText.length > 3) {
          lessonTitle = titleText;

          // Extract items from nested columns
          const $nestedRow = $itemsContainer.find('.row').first();
          if ($nestedRow.length > 0) {
            itemCols = $nestedRow.children('[class*="col-"]').toArray();
          }
        }
      } else {
        // Pattern B: flat structure
        const textCol = cols.find(c => c.text.length > 3 && c.links === 0);
        const linkCols = cols.filter(c => c.links > 0);

        if (textCol && linkCols.length > 0) {
          lessonTitle = textCol.text;
          itemCols = linkCols.map(c => c.$col);
        }
      }

      if (lessonTitle && itemCols.length > 0) {
        // Extract items from each column
        const itemGroups: ItemGroup[] = [];

        for (const col of itemCols) {
          const $col = $(col);
          const items: Item[] = [];

          $col.find('a').each((_: any, link: any) => {
            const href = $(link).attr('href');
            if (href) {
              items.push(createItem(toAbsoluteUrl(href, this.baseUrl)));
            }
          });

          itemGroups.push({ items });
        }

        // Ensure we have the correct number of itemGroups to match groupNames
        while (itemGroups.length < groupNames.length) {
          itemGroups.push({ items: [] });
        }

        // If no groupNames detected yet, infer from number of item columns
        if (groupNames.length === 0) {
          groupNames = itemCols.map((_, i) => `Group ${i + 1}`);
        }

        const lesson: Lesson = {
          title: lessonTitle,
          lessonNum: null,
          ayahNum: null,
          uploadDate: null,
          itemGroups,
        };

        // Add lesson to current surah (or create default surah)
        if (!currentSurah) {
          currentSurah = {
            name: 'Lessons',
            arabicName: null,
            description: null,
            groups: groupNames.map(n => ({ name: n })),
            lessons: [],
          };
        }

        currentSurah.lessons.push(lesson);
      }
    });

    // Save last surah
    const finalSurah = currentSurah as Surah | null;
    if (finalSurah && finalSurah.lessons.length > 0) {
      surahs.push(finalSurah);
    }

    if (surahs.length > 0) {
      const total = surahs.reduce((sum, s) => sum + s.lessons.length, 0);
      console.log(`  ✓ Bootstrap: ${surahs.length} surahs, ${total} lessons`);
    }

    return surahs.length > 0 ? { surahs } : null;
  }

  /**
   * Strategy 2: Tabbed interface (like assorted_lectures.php)
   */
  private scrapeTabbedInterface($: cheerio.CheerioAPI): { surahs: Surah[] } | null {
    const $tabPanels = $('[role="tabpanel"]');
    if ($tabPanels.length === 0) return null;

    console.log(`  Found ${$tabPanels.length} tab panels`);

    const surahs: Surah[] = [];

    $tabPanels.each((_: any, panel: any) => {
      const $panel = $(panel);

      // Get tab name from aria-labelledby or from the tab itself
      const tabId = $panel.attr('aria-labelledby');
      let tabName = 'Lectures';
      if (tabId) {
        const $tab = $(`#${tabId}, [aria-controls="${$panel.attr('id')}"]`).first();
        tabName = cleanText($tab.text()) || tabName;
      }

      const lessons: Lesson[] = [];

      // Find all direct children that contain media links
      $panel.children().each((_: any, item: any) => {
        const $item = $(item);

        // Look for links with media extensions
        const $links = $item.find('a[href]').filter((_: any, link: any) => {
          const href = $(link).attr('href') || '';
          return !!href.match(/\.(mp3|mp4|pdf)$/i);
        });

        if ($links.length > 0) {
          // Get title from the item's text, excluding link text
          const $titleEl = $item.find('> *').first();
          let titleText = cleanText($titleEl.text());

          // If title is too long, take first line
          if (titleText.length > 200) {
            titleText = titleText.split('\n')[0];
          }

          if (titleText && titleText.length > 3) {
            const items: Item[] = [];
            $links.each((_: any, link: any) => {
              const href = $(link).attr('href');
              if (href) {
                items.push(createItem(toAbsoluteUrl(href, this.baseUrl)));
              }
            });

            if (items.length > 0) {
              lessons.push({
                title: titleText,
                lessonNum: null,
                ayahNum: null,
                uploadDate: null,
                itemGroups: [{ items }]
              });
            }
          }
        }
      });

      if (lessons.length > 0) {
        surahs.push({
          name: tabName,
          arabicName: null,
          description: null,
          groups: [{ name: 'Audio/Video' }],
          lessons
        });
      }
    });

    if (surahs.length > 0) {
      const total = surahs.reduce((sum, s) => sum + s.lessons.length, 0);
      console.log(`  ✓ Tabbed: ${surahs.length} tabs, ${total} lessons`);
      return { surahs };
    }

    return null;
  }

  /**
   * Strategy 3: Simple list layout (like pashtu_taj_n, namaz_n, death_n)
   */
  private scrapeSimpleList($: cheerio.CheerioAPI): { surahs: Surah[] } | null {
    const lessons: Lesson[] = [];
    const seenTitles = new Set<string>();

    // Common navigation/sidebar keywords to skip
    const navigationKeywords = [
      'tafseer', 'tajweed', 'hadith', 'seerah', 'weekly update',
      'navigation', 'menu', 'taleem', 'fehm', 'quran 101', 'quran 102',
      'english qaidah', 'noorani', 'ahsan', 'furqan', 'ilm', 'al-misbah',
      'lulu wal marjaan', 'luloo'
    ];

    const isNavigationItem = (text: string): boolean => {
      const textLower = text.toLowerCase();
      return navigationKeywords.some(keyword => textLower.includes(keyword));
    };

    // Strategy 3a: Find elements with headers/titles followed by links
    // Common pattern: <generic><generic>Title</generic><link>...</link></generic>
    $('*').each((_: any, elem: any) => {
      const $elem = $(elem);

      // Look for media links
      const $links = $elem.find('> a[href]').filter((_: any, link: any) => {
        const href = $(link).attr('href') || '';
        return !!href.match(/\.(mp3|mp4|pdf|ppsx)$/i);
      });

      if ($links.length > 0) {
        // Look for title in sibling or child elements
        let titleText = '';

        // Try to find text in previous sibling
        const $prevSibling = $elem.prev();
        if ($prevSibling.length > 0 && $prevSibling.find('a').length === 0) {
          titleText = cleanText($prevSibling.text());
        }

        // If no title from sibling, try first child that has text but no link
        if (!titleText) {
          $elem.children().each((_: any, child: any) => {
            const $child = $(child);
            if (!titleText && $child.find('a').length === 0) {
              const text = cleanText($child.text());
              if (text && text.length > 3 && text.length < 300) {
                titleText = text;
                return false; // break
              }
            }
            return undefined; // Continue iteration
          });
        }

        // Skip if no meaningful title or if we've seen this title or if it's navigation
        if (!titleText || titleText.length < 3 || seenTitles.has(titleText) || isNavigationItem(titleText)) {
          return;
        }

        seenTitles.add(titleText);

        // Collect all media links
        const items: Item[] = [];
        $links.each((_: any, link: any) => {
          const href = $(link).attr('href');
          if (href) {
            items.push(createItem(toAbsoluteUrl(href, this.baseUrl)));
          }
        });

        if (items.length > 0) {
          lessons.push({
            title: titleText,
            lessonNum: null,
            ayahNum: null,
            uploadDate: null,
            itemGroups: items.length > 1 ?
              items.map(item => ({ items: [item] })) :
              [{ items }]
          });
        }
      }
    });

    // Strategy 3b: Direct table-like structure
    // Find rows that have text + link pattern
    if (lessons.length === 0) {
      const $contentArea = $('body').find('*').filter((_: any, elem: any) => {
        const $el = $(elem);
        const links = $el.find('a[href]').filter((_: any, link: any) => {
          const href = $(link).attr('href') || '';
          return !!href.match(/\.(mp3|mp4|pdf|ppsx)$/i);
        });
        return links.length > 0;
      });

      $contentArea.each((_: any, row: any) => {
        const $row = $(row);
        const $link = $row.find('a[href]').filter((_: any, link: any) => {
          const href = $(link).attr('href') || '';
          return !!href.match(/\.(mp3|mp4|pdf|ppsx)$/i);
        }).first();

        if ($link.length > 0) {
          const href = $link.attr('href');
          if (!href) return;

          // Get text from row, excluding the link
          const titleText = cleanText($row.clone().find('a').remove().end().text());

          if (titleText && titleText.length > 3 && !seenTitles.has(titleText) && !isNavigationItem(titleText)) {
            seenTitles.add(titleText);
            lessons.push({
              title: titleText,
              lessonNum: null,
              ayahNum: null,
              uploadDate: null,
              itemGroups: [{
                items: [createItem(toAbsoluteUrl(href, this.baseUrl))]
              }]
            });
          }
        }
      });
    }

    if (lessons.length > 0) {
      console.log(`  ✓ Simple list: ${lessons.length} lessons`);

      return {
        surahs: [{
          name: 'Lessons',
          arabicName: null,
          description: null,
          groups: [{ name: 'Media' }],
          lessons
        }]
      };
    }

    return null;
  }

  private finalize(data: { surahs: Surah[] }): QuranCourseContent {
    const total = data.surahs.reduce((sum, s) => sum + s.lessons.length, 0);
    console.log(`  Final: ${data.surahs.length} surahs, ${total} lessons`);

    // Extract title from URL
    const parts = this.url.split('/');
    const folder = parts[parts.length - 2] || 'course';
    const title = folder.replace(/[_-]/g, ' ');

    return {
      id: folder,
      title,
      surahs: data.surahs,
    };
  }
}
