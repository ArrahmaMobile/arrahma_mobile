/**
 * Test script to verify enhanced scraper works on previously failing pages
 */

import { HttpClient } from './core/http-client';
import { UniversalCourseScraper } from './scrapers/universal-scraper';

const FAILING_PAGES = [
  { name: 'Pashtu Tajweed', url: 'https://arrahmah.org/pashtu_taj_n/pashtu_letters.php' },
  { name: 'Assorted Lectures', url: 'https://arrahmah.org/assorted_lectures.php' },
  { name: 'Lectures on Namaz', url: 'https://arrahmah.org/namaz_n.php' },
  { name: 'Lectures on Death', url: 'https://arrahmah.org/death_n.php' },
];

async function testPage(name: string, url: string, httpClient: HttpClient) {
  console.log(`\n${'='.repeat(80)}`);
  console.log(`Testing: ${name}`);
  console.log(`URL: ${url}`);
  console.log(`${'='.repeat(80)}`);

  const scraper = new UniversalCourseScraper(httpClient, url);
  const content = await scraper.scrape();

  if (!content) {
    console.log(`❌ FAILED: No content returned`);
    return false;
  }

  const totalLessons = content.surahs.reduce((sum, s) => sum + s.lessons.length, 0);

  console.log(`✅ SUCCESS`);
  console.log(`   Surahs/Sections: ${content.surahs.length}`);
  console.log(`   Total Lessons: ${totalLessons}`);

  if (content.surahs.length > 0) {
    const firstSurah = content.surahs[0];
    console.log(`   First Section: ${firstSurah.name}`);
    console.log(`   Groups: ${firstSurah.groups.map(g => g.name).join(', ')}`);

    if (firstSurah.lessons.length > 0) {
      const firstLesson = firstSurah.lessons[0];
      console.log(`   First Lesson: ${firstLesson.title}`);
      console.log(`   Item Groups: ${firstLesson.itemGroups.length}`);
    }
  }

  return true;
}

async function runTests() {
  console.log('🚀 Testing enhanced scraper on previously failing pages...\n');

  const httpClient = new HttpClient();
  let passed = 0;
  let failed = 0;

  for (const page of FAILING_PAGES) {
    const result = await testPage(page.name, page.url, httpClient);
    if (result) {
      passed++;
    } else {
      failed++;
    }
    // Small delay between requests
    await new Promise(resolve => setTimeout(resolve, 500));
  }

  console.log(`\n\n${'='.repeat(80)}`);
  console.log('📊 ENHANCED SCRAPER TEST RESULTS');
  console.log(`${'='.repeat(80)}`);
  console.log(`✅ Passed: ${passed}/${FAILING_PAGES.length}`);
  console.log(`❌ Failed: ${failed}/${FAILING_PAGES.length}`);
  console.log(`${'='.repeat(80)}\n`);

  if (failed > 0) {
    process.exit(1);
  }
}

runTests().catch(error => {
  console.error('Fatal error:', error);
  process.exit(1);
});
