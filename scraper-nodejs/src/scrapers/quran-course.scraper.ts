/**
 * Quran Course scraper - extracts course information from homepage
 * V2: Generic structure with buttons and sections
 */

import { BaseScraper } from '../core/scraper-base';
import { QuranCourse, CourseButton, CourseSection as CourseSectionModel, Item, CourseButtonType } from '../types/models';
import { toAbsoluteUrl, normalizeUrl } from '../utils/url.utils';
import { cleanText } from '../utils/text.utils';
import { createItem } from '../utils/content-type.utils';

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
    let currentSectionTitle = 'COURSES WE OFFER'; // Default for first section
    let currentCourses: QuranCourse[] = [];

    // Find all course container sections
    $('.col-12.col-md-9 .container-xxl').each((_: any, containerEl: any) => {
      const $container = $(containerEl);

      // Look for section title
      const sectionTitle = cleanText($container.find('.section-title').first().text());

      // If we found a new section title, save the previous section and start a new one
      if (sectionTitle) {
        if (currentCourses.length > 0) {
          sections.push({
            title: currentSectionTitle,
            courses: currentCourses,
          });
        }
        currentSectionTitle = sectionTitle;
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
            }

            if (!sectionMap.has(sectionKey)) {
              sectionMap.set(sectionKey, []);
            }
            sectionMap.get(sectionKey)!.push(item);
          });
        });

        // Convert map to sections array
        sectionMap.forEach((items, label) => {
          courseSections.push({
            label,
            icon: this.getIconForSection(label),
            content: {
              items: items.map((item: Item) => ({
                item,
                imageUrl: null,
                title: null,
              })),
            },
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
      });
    });

    // Don't forget to add the last section
    if (currentCourses.length > 0) {
      sections.push({
        title: currentSectionTitle,
        courses: currentCourses,
      });
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
