/**
 * Quran Course scraper - extracts course information from homepage
 * V2: Generic structure with buttons and sections
 */

import { BaseScraper } from '../core/scraper-base';
import { QuranCourse, CourseButton, CourseSection as CourseSectionModel, Item, CourseButtonType } from '../types/models';
import { toAbsoluteUrl, normalizeUrl } from '../utils/url.utils';
import { cleanText, fixSpacedText } from '../utils/text.utils';
import { createItem } from '../utils/content-type.utils';
import { TestScraper } from './test.scraper';

export interface HomepageSection {
  title: string;
  courses: QuranCourse[];
}

export class QuranCourseScraper extends BaseScraper<HomepageSection[]> {
  async scrape(): Promise<HomepageSection[]> {
    console.log('Scraping Quran courses...');

    const $ = await this.navigateTo('');
    if (!$) {
      console.error('Failed to load homepage');
      return [];
    }

    const sections: HomepageSection[] = [];
    let currentSectionTitle = 'Courses We Offer'; // Default for first section
    let currentCourses: QuranCourse[] = [];

    // Collection to track test URLs that need scraping
    const testUrlsToScrape: Array<{ courseIndex: number, sectionIndex: number, url: string }> = [];
    let courseGlobalIndex = 0;

    // Find all course container sections
    $('.col-12.col-md-9 .container-xxl').each((_: any, containerEl: any) => {
      const $container = $(containerEl);

      // Look for section title
      const rawSectionTitle = cleanText($container.find('.section-title').first().text());

      // If we found a new section title, save the previous section and start a new one
      if (rawSectionTitle) {
        if (currentCourses.length > 0) {
          sections.push({
            title: currentSectionTitle,
            courses: currentCourses,
          });
        }
        // Apply title case transformation
        currentSectionTitle = fixSpacedText(rawSectionTitle);
        currentCourses = [];
      }

      // Extract all courses in this container
      $container.find('.col-lg-4.col-md-6 .course-item').each((_: any, el: any) => {
        const $courseItem = $(el);

        // Extract title
        const title = cleanText($courseItem.find('h5, h6').first().text());
        if (!title) return;

        // Extract image URL
        const imageUrl = $courseItem.find('img').attr('src');
        if (!imageUrl) return;

        const absoluteImageUrl = normalizeUrl(toAbsoluteUrl(imageUrl, this.baseUrl), this.baseUrl);

        // Extract ALL buttons
        const courseButtons: CourseButton[] = [];
        const buttons = $courseItem.find('.position-absolute a');

        buttons.each((_: any, btn: any) => {
          const $btn = $(btn);
          const label = cleanText($btn.text());
          const href = $btn.attr('href');

          if (!label) return;

          const lowerLabel = label.toLowerCase();
          let buttonType: CourseButtonType = 'link';
          let url = href && href !== '#' ? toAbsoluteUrl(href, this.baseUrl) : '#';

          // Determine button type
          if (lowerLabel.includes('detail')) {
            buttonType = 'details';
          } else if (lowerLabel.includes('join')) {
            buttonType = 'join';
          } else if (lowerLabel.includes('reg')) {
            buttonType = 'register';
          }

          // Determine if button is active (clickable)
          // Inactive if: contains "closed" OR has no valid href
          const isActive = !lowerLabel.includes('closed') && !!(href && href !== '#');

          courseButtons.push({
            label,
            type: buttonType,
            isActive,
            url,
          });
        });

        // Extract links from bordered sections
        const courseSections: CourseSectionModel[] = [];
        const linkSections = $courseItem.find('.d-flex.border-top');

        // Group items by section type
        const sectionMap = new Map<string, Item[]>();
        const testUrls: string[] = []; // Track test URLs for scraping

        linkSections.each((_: any, section: any) => {
          const $section = $(section);
          $section.find('a').each((_: any, link: any) => {
            const $link = $(link);
            const linkText = cleanText($link.text());
            const href = $link.attr('href');

            if (!href || href === '#' || !linkText) return;

            const absoluteUrl = toAbsoluteUrl(href, this.baseUrl);
            const item = createItem(absoluteUrl);

            const lowerText = linkText.toLowerCase();
            let sectionKey = 'Other';

            if (lowerText.includes('tafseer')) {
              sectionKey = 'Tafseer';
            } else if (lowerText.includes('tajweed')) {
              sectionKey = 'Tajweed';
            } else if (lowerText.includes('latest')) {
              // Check 'latest' before 'test' since 'latest' contains 'test'
              sectionKey = 'Latest Lecture';
            } else if (lowerText.includes('lect') || lowerText.includes('lecture')) {
              sectionKey = 'Lectures';
            } else if (lowerText.includes('test')) {
              sectionKey = 'Tests';
              testUrls.push(absoluteUrl); // Save test URL for scraping
            }

            if (!sectionMap.has(sectionKey)) {
              sectionMap.set(sectionKey, []);
            }
            sectionMap.get(sectionKey)!.push(item);
          });
        });

        // Mark test URLs for later scraping (can't await inside .each())
        if (testUrls.length > 0 && testUrls[0]) {
          // Track this test URL for scraping after the loop
          testUrlsToScrape.push({
            courseIndex: courseGlobalIndex,
            sectionIndex: courseSections.length,
            url: testUrls[0], // Only scrape first test page per course
          });
          // Don't add to sectionMap yet - we'll handle it after scraping
          sectionMap.delete('Tests');
        }

        // Convert remaining sections from map to sections array
        sectionMap.forEach((items, label) => {
          courseSections.push({
            label,
            icon: this.getIconForSection(label),
            mediaContent: {
              items: items.map((item: Item) => ({
                item,
                imageUrl: null,
                title: null,
              })),
            },
            courseContent: null, // Will be populated later by linking to drawer content
          });
        });

        // Build course object
        const course: QuranCourse = {
          title,
          imageUrl: absoluteImageUrl,
          buttons: courseButtons,
          sections: courseSections,
        };

        currentCourses.push(course);
        courseGlobalIndex++;
      });
    });

    // Don't forget to add the last section
    if (currentCourses.length > 0) {
      sections.push({
        title: currentSectionTitle,
        courses: currentCourses,
      });
    }

    // Now process test URLs asynchronously
    if (testUrlsToScrape.length > 0) {
      console.log(`  📝 Scraping ${testUrlsToScrape.length} test page(s)...`);

      for (const testInfo of testUrlsToScrape) {
        try {
          const testScraper = new TestScraper(this.httpClient, testInfo.url);
          const testContent = await testScraper.scrape();

          if (testContent) {
            // Find the course across all sections
            let globalIndex = 0;
            let found = false;

            for (const section of sections) {
              for (const course of section.courses) {
                if (globalIndex === testInfo.courseIndex) {
                  // Add test section to this course
                  course.sections.splice(testInfo.sectionIndex, 0, {
                    label: 'Tests',
                    icon: this.getIconForSection('Tests'),
                    mediaContent: testContent,
                    courseContent: null,
                  });
                  found = true;
                  break;
                }
                globalIndex++;
              }
              if (found) break;
            }
          }
        } catch (error) {
          console.error(`  ⚠️  Failed to scrape test page ${testInfo.url}:`, error);
        }
      }
    }

    const totalCourses = sections.reduce((sum, s) => sum + s.courses.length, 0);
    console.log(`✓ Extracted ${totalCourses} Quran courses in ${sections.length} sections`);
    return sections;
  }

  /**
   * Get icon identifier for a section label
   */
  private getIconForSection(label: string): string | null {
    const lower = label.toLowerCase();
    if (lower.includes('tafseer')) return 'book';
    if (lower.includes('tajweed')) return 'quran';
    // Check 'latest' before 'test' since 'latest' contains 'test'
    if (lower.includes('latest')) return 'broadcast';
    if (lower.includes('lecture')) return 'book';
    if (lower.includes('test')) return 'edit';
    return null;
  }
}
