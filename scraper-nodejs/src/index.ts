/**
 * Main entry point for Arrahmah scraper
 */

import * as fs from 'fs/promises';
import * as path from 'path';
import { HttpClient } from './core/http-client';
import { HomepageScraper } from './scrapers/homepage.scraper';
import { AboutUsScraper } from './scrapers/about-us.scraper';
import { QuranCourseScraper } from './scrapers/quran-course.scraper';
import { DuaScraper } from './scrapers/dua.scraper';
import { AppData, QuranCourseGroup, ScrapedData, QuranCourse, DrawerItem } from './types/models';
import { config } from './config';

/**
 * Main scraper class that orchestrates all scrapers
 */
class ArrahmahScraper {
  private httpClient: HttpClient;

  constructor() {
    this.httpClient = new HttpClient();
  }

  /**
   * Run the complete scraping process
   */
  async scrape(): Promise<AppData> {
    console.log('🚀 Starting Arrahmah scraper...\n');
    console.log(`Base URL: ${config.baseUrl}`);
    console.log(`Max concurrent requests: ${config.maxConcurrentRequests}`);
    console.log(`Rate limit delay: ${config.requestDelay}ms\n`);

    try {
      // Scrape homepage
      console.log('📄 Scraping homepage...');
      const homepageScraper = new HomepageScraper(this.httpClient);
      const homepage = await homepageScraper.scrape();

      // Scrape About Us
      console.log('\n📖 Scraping About Us...');
      const aboutUsScraper = new AboutUsScraper(this.httpClient);
      const aboutUsMarkdown = await aboutUsScraper.scrape();

      // Scrape Quran courses
      console.log('\n📚 Scraping Quran courses...');
      const quranCourseScraper = new QuranCourseScraper(this.httpClient);
      const courseSections = await quranCourseScraper.scrape();

      // Scrape Duas
      console.log('\n🤲 Scraping Duas...');
      const duaScraper = new DuaScraper(this.httpClient);
      const duaCategories = await duaScraper.scrape();

      // Organize courses by sections
      // First section goes into main courses array
      // Remaining sections go into otherCourseGroups
      const topCourses = courseSections.length > 0 ? courseSections[0].courses : [];

      const otherCourseGroups: QuranCourseGroup[] = [];
      for (let i = 1; i < courseSections.length; i++) {
        const section = courseSections[i];
        otherCourseGroups.push({
          title: section.title,
          imageUrl: section.courses[0]?.imageUrl || 'https://arrahmah.org/img/course-default.jpg',
          courses: section.courses,
        });
      }

      // Link courses to their full content from drawer items
      this.linkCoursesToContent([...topCourses, ...otherCourseGroups.flatMap(g => g.courses)], homepage.drawerItems);

      // Assemble app data
      const appData: AppData = {
        logoUrl: homepage.logoUrl,
        quickLinks: homepage.quickLinks,
        banners: homepage.banners,
        broadcastItems: homepage.broadcastItems,
        socialMediaItems: homepage.socialMediaItems,
        drawerItems: homepage.drawerItems,
        aboutUsMarkdown,
        courses: topCourses,
        otherCourseGroups,
        duaCategories,
      };

      console.log('\n✅ Scraping completed successfully!');
      console.log(`\nCache size: ${this.httpClient.getCacheSize()} documents`);

      return appData;
    } catch (error) {
      console.error('\n❌ Scraping failed:', error);
      throw error;
    }
  }

  /**
   * Link courses to their full QuranCourseContent from drawer items
   * Matches course titles to drawer item titles and copies the content
   */
  private linkCoursesToContent(courses: QuranCourse[], drawerItems: DrawerItem[]): void {
    console.log('\n🔗 Linking courses to their full content...');

    for (const course of courses) {
      // Try to find a matching drawer item
      const matchingDrawerItem = this.findDrawerItemByTitle(course.title, drawerItems);

      if (matchingDrawerItem?.content) {
        // Add a new section with the full course content
        course.sections.push({
          label: 'Tafseer',
          icon: 'book',
          mediaContent: null,
          courseContent: matchingDrawerItem.content,
        });
        console.log(`  ✓ Linked "${course.title}" to full content (${matchingDrawerItem.content.surahs.length} surahs)`);
      }
    }
  }

  /**
   * Recursively search for a drawer item by title
   */
  private findDrawerItemByTitle(title: string, items: DrawerItem[]): DrawerItem | null {
    const normalizedTitle = title.toLowerCase().trim();

    for (const item of items) {
      const itemTitle = item.title.toLowerCase().trim();

      // Check for exact match or similar match
      if (itemTitle === normalizedTitle ||
          itemTitle.includes(normalizedTitle) ||
          normalizedTitle.includes(itemTitle)) {
        return item;
      }

      // Search in children
      if (item.children) {
        const found = this.findDrawerItemByTitle(title, item.children);
        if (found) return found;
      }
    }

    return null;
  }

  /**
   * Save scraped data to JSON file (atomic write)
   * Uses a temporary file and rename to prevent corruption during writes
   */
  async saveToFile(appData: AppData, outputPath: string = config.outputPath): Promise<void> {
    const scrapedData: ScrapedData = {
      appData: appData,
      runMetadata: {
        lastUpdate: new Date().toISOString(),
        updateFrequency: 2 * 60 * 60 * 1000, // 2 hours in milliseconds
      },
    };

    // Ensure output directory exists
    const dir = path.dirname(outputPath);
    await fs.mkdir(dir, { recursive: true });

    // Atomic write: write to temp file, then rename
    // This prevents corruption if the file is being read while writing
    const tempPath = `${outputPath}.tmp`;
    const jsonContent = JSON.stringify(scrapedData, null, 2);

    try {
      // Write to temporary file
      await fs.writeFile(tempPath, jsonContent, 'utf-8');

      // Validate JSON before renaming
      JSON.parse(jsonContent);

      // Atomically replace the old file with the new one
      await fs.rename(tempPath, outputPath);

      console.log(`\n💾 Data saved successfully to: ${outputPath}`);
      console.log(`📊 Data size: ${(jsonContent.length / 1024).toFixed(2)} KB`);
    } catch (error) {
      // Clean up temp file if something went wrong
      try {
        await fs.unlink(tempPath);
      } catch {
        // Ignore cleanup errors
      }
      throw error;
    }
  }
}

/**
 * Main execution
 */
async function main() {
  const startTime = Date.now();

  try {
    const scraper = new ArrahmahScraper();
    const appData = await scraper.scrape();
    await scraper.saveToFile(appData);

    const duration = ((Date.now() - startTime) / 1000).toFixed(2);
    console.log(`\n⏱️  Total time: ${duration}s`);
  } catch (error) {
    console.error('\n💥 Fatal error:', error);
    process.exit(1);
  }
}

// Run if executed directly
if (require.main === module) {
  main();
}

export { ArrahmahScraper };
