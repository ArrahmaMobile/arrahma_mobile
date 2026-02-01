/**
 * Test script for tafseer2025 page scraping
 */

import { HttpClient } from './core/http-client';
import { CourseContentScraper } from './scrapers/course-content.scraper';
import * as fs from 'fs';

async function testTafseer2025() {
  console.log('🧪 Testing tafseer2025 page scraping...\n');

  const httpClient = new HttpClient();

  const scraper = new CourseContentScraper(httpClient, 'https://arrahmah.org/tafseer2025/juz1.php');
  const content = await scraper.scrape();

  if (!content) {
    console.error('❌ Failed to scrape content');
    process.exit(1);
  }

  console.log('\n✅ Scraping completed successfully!\n');
  console.log('📊 Results:');
  console.log(`   Title: ${content.title}`);
  console.log(`   Total Surahs: ${content.surahs.length}\n`);

  // Check Introduction surah
  const introSurah = content.surahs.find(s => s.name === 'Introduction');
  if (introSurah) {
    console.log('📖 Introduction Surah:');
    console.log(`   Groups: ${introSurah.groups.map(g => g.name).join(', ')}`);
    console.log(`   Lessons: ${introSurah.lessons.length}\n`);

    // Check first lesson
    if (introSurah.lessons.length > 0) {
      const firstLesson = introSurah.lessons[0];
      console.log(`   First Lesson: "${firstLesson.title}"`);
      console.log(`   Item Groups: ${firstLesson.itemGroups.length}`);

      firstLesson.itemGroups.forEach((group, idx) => {
        const groupName = introSurah.groups[idx]?.name || `Group ${idx + 1}`;
        console.log(`      ${groupName}: ${group.items.length} items`);
        group.items.forEach(item => {
          console.log(`         - ${item.type}: ${item.data}`);
        });
      });
    }

    // Check second lesson
    if (introSurah.lessons.length > 1) {
      const secondLesson = introSurah.lessons[1];
      console.log(`\n   Second Lesson: "${secondLesson.title}"`);
      console.log(`   Item Groups: ${secondLesson.itemGroups.length}`);

      secondLesson.itemGroups.forEach((group, idx) => {
        const groupName = introSurah.groups[idx]?.name || `Group ${idx + 1}`;
        console.log(`      ${groupName}: ${group.items.length} items`);
        group.items.forEach(item => {
          console.log(`         - ${item.type}: ${item.data}`);
        });
      });
    }
  } else {
    console.log('⚠️  Introduction surah not found!');
  }

  // Save full output for inspection
  fs.writeFileSync(
    'test-tafseer2025-output.json',
    JSON.stringify(content, null, 2)
  );
  console.log('\n💾 Full output saved to test-tafseer2025-output.json');
}

testTafseer2025().catch(console.error);
