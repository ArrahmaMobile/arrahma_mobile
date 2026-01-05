/**
 * Quran Course scraper - extracts course information from homepage
 */

import { BaseScraper } from '../core/scraper-base';
import { QuranCourse, Item } from '../types/models';
import { toAbsoluteUrl, normalizeUrl } from '../utils/url.utils';
import { cleanText } from '../utils/text.utils';
import { createItem } from '../utils/content-type.utils';

export interface CourseSection {
  title: string;
  courses: QuranCourse[];
}

export class QuranCourseScraper extends BaseScraper<CourseSection[]> {
  async scrape(): Promise<CourseSection[]> {
    console.log('Scraping Quran courses...');

    const $ = await this.navigateTo('');
    if (!$) {
      console.error('Failed to load homepage');
      return [];
    }

    const sections: CourseSection[] = [];
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

        // Extract Details and Registration links
        const buttons = $courseItem.find('.position-absolute a');
        let detailUrl: string | undefined;
        let registrationUrl: string | undefined;

        buttons.each((_: any, btn: any) => {
          const $btn = $(btn);
          const text = cleanText($btn.text());
          const href = $btn.attr('href');

          if (!href || href === '#') return;

          if (text.toLowerCase().includes('detail')) {
            detailUrl = toAbsoluteUrl(href, this.baseUrl);
          } else if (text.toLowerCase().includes('join') || text.toLowerCase().includes('reg')) {
            if (!text.toLowerCase().includes('closed')) {
              registrationUrl = toAbsoluteUrl(href, this.baseUrl);
            }
          }
        });

        // Extract links from bordered sections
        const linkSections = $courseItem.find('.d-flex.border-top');
        const tafseerItems: Item[] = [];
        const tajweedItems: Item[] = [];
        const testItems: Item[] = [];
        const lectureItems: Item[] = [];
        const otherItems: Item[] = [];

        linkSections.each((_: any, section: any) => {
          const $section = $(section);
          $section.find('a').each((_: any, link: any) => {
            const $link = $(link);
            const linkText = cleanText($link.text());
            const href = $link.attr('href');

            if (!href || href === '#') return;

            const absoluteUrl = toAbsoluteUrl(href, this.baseUrl);
            const item = createItem(absoluteUrl);

            const lowerText = linkText.toLowerCase();
            if (lowerText.includes('tafseer')) {
              tafseerItems.push(item);
            } else if (lowerText.includes('tajweed')) {
              tajweedItems.push(item);
            } else if (lowerText.includes('test')) {
              testItems.push(item);
            } else if (lowerText.includes('lect') || lowerText.includes('lecture')) {
              lectureItems.push(item);
            } else {
              otherItems.push(item);
            }
          });
        });

        // Build course object
        const course: QuranCourse = {
          title,
          imageUrl: absoluteImageUrl,
        };

        if (detailUrl) {
          course.courseDetails = {
            type: 'markdown', // or 'html' depending on the content type
            details: detailUrl, // Store URL for now, could be scraped later
          };
        }

        if (registrationUrl) {
          course.registration = {
            type: 'url', // RegistrationType
            url: registrationUrl,
          };
        }

        if (tafseerItems.length > 0) {
          // For now, create empty surahs structure
          // TODO: Properly scrape tafseer content
          course.tafseer = {
            surahs: [],
          };
        }

        if (tajweedItems.length > 0) {
          // For now, create empty surahs structure
          // TODO: Properly scrape tajweed content
          course.tajweed = {
            surahs: [],
          };
        }

        if (lectureItems.length > 0) {
          // For now, create empty surahs structure
          // TODO: Properly scrape lecture content
          course.lectures = {
            surahs: [],
          };
        }

        if (testItems.length > 0) {
          // Tests use MediaContent, not QuranCourseContent
          course.tests = {
            items: testItems.map((item: Item) => ({
              item: item,
              imageUrl: null,
              title: null,
            })),
          };
        }

        if (otherItems.length > 0) {
          // Other content uses MediaContent, not QuranCourseContent
          course.otherContent = {
            items: otherItems.map((item: Item) => ({
              item: item,
              imageUrl: null,
              title: null,
            })),
          };
        }

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
   * Create lessons from items (currently unused, kept for future use)
   */
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  private _createLessonsFromItems(items: Item[]) {
    return items.map((item, index) => ({
      title: `Resource ${index + 1}`,
      groups: [{
        title: 'Resources',
        items: [{
          title: 'Link',
          items: [item],
        }],
      }],
    }));
  }
}
