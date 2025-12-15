/**
 * Test script for course content scraper
 */

import { HttpClient } from './core/http-client';
import { CourseContentScraper } from './scrapers/course-content.scraper';

async function test() {
  const httpClient = new HttpClient();
  const scraper = new CourseContentScraper(httpClient, 'https://arrahmah.org/quran2019_n/juz1.php');

  console.log('Testing course content scraper...\n');

  const content = await scraper.scrape();

  if (content) {
    console.log('\n✅ Course Content:');
    console.log(`ID: ${content.id}`);
    console.log(`Title: ${content.title}`);
    console.log(`Surahs: ${content.surahs.length}`);

    content.surahs.forEach((surah, i) => {
      console.log(`\n  Surah ${i + 1}: ${surah.name}`);
      console.log(`    Groups: ${surah.groups.map(g => g.name).join(', ')}`);
      console.log(`    Lessons: ${surah.lessons.length}`);

      if (surah.lessons.length > 0) {
        const firstLesson = surah.lessons[0];
        console.log(`    First lesson: ${firstLesson.title}`);
        console.log(`    Item groups: ${firstLesson.itemGroups.length}`);
        firstLesson.itemGroups.forEach((group, j) => {
          console.log(`      Group ${j + 1}: ${group.items.length} items`);
        });
      }
    });

    // Print JSON for comparison
    console.log('\n\nJSON Output (first 500 chars):');
    console.log(JSON.stringify(content, null, 2).substring(0, 500));
  } else {
    console.log('❌ Failed to scrape content');
  }
}

test().catch(console.error);
