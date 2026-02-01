/**
 * Comprehensive test script to verify scraping works for ALL pages on arrahmah.org
 */

import { HttpClient } from './core/http-client';
import { UniversalCourseScraper } from './scrapers/universal-scraper';

interface TestPage {
  name: string;
  url: string;
  category: string;
}

const TEST_PAGES: TestPage[] = [
  // Tafseer in Urdu
  { name: 'ATQ 2025 Tafseer', url: 'https://arrahmah.org/tafseer2025/juz1.php', category: 'Tafseer Urdu' },
  { name: 'AB 2016 Tafseer', url: 'https://arrahmah.org/ab/juz25.php', category: 'Tafseer Urdu' },
  { name: 'AB 2017 Tafseer', url: 'https://arrahmah.org/ab/juz24.php', category: 'Tafseer Urdu' },
  { name: 'AF 2016 Tafseer', url: 'https://arrahmah.org/af/juz25.php', category: 'Tafseer Urdu' },
  { name: 'AF 2017 Tafseer', url: 'https://arrahmah.org/af/juz24.php', category: 'Tafseer Urdu' },
  { name: 'AF 2018 Tafseer', url: 'https://arrahmah.org/af/juz22.php', category: 'Tafseer Urdu' },
  { name: 'IQ 2018 Tafseer', url: 'https://arrahmah.org/iq/juz22.php', category: 'Tafseer Urdu' },
  { name: 'Quran 101 Tafseer', url: 'http://arrahmah.org/q101_taf/juz15.php', category: 'Tafseer Urdu' },
  { name: 'Quran 102 Tafseer', url: 'http://arrahmah.org/q102_taf/juz3.php', category: 'Tafseer Urdu' },

  // Tafseer in English
  { name: 'English Tafseer', url: 'https://www.arrahmah.org/quran_english/juz7.php', category: 'Tafseer English' },

  // Tafseer in Pashto
  { name: 'Pashtu Tafseer', url: 'http://arrahmah.org/pashtu_2019_n/juz30.php', category: 'Tafseer Pashto' },

  // Tafseer in Farsi
  { name: 'Farsi Tafseer', url: 'http://arrahmah.org/farsi/fq/juz3.php', category: 'Tafseer Farsi' },

  // Tajweed Pages
  { name: 'Adv Tajweed 2025', url: 'https://arrahmah.org/advtajweed2025/level-foundation.php', category: 'Tajweed' },
  { name: 'Adv Taleem ul Quran Tajweed', url: 'https://arrahmah.org/atq_taj/atq-baq.php', category: 'Tajweed' },
  { name: 'Taleem ul Quran Tajweed', url: 'https://arrahmah.org/tq_taj/tq-letters.php', category: 'Tajweed' },
  { name: 'Fehm ul Quran Tajweed', url: 'https://arrahmah.org/fq_taj/fq-letters.php', category: 'Tajweed' },
  { name: 'Pashtu Tajweed', url: 'https://arrahmah.org/pashtu_taj_n/pashtu.php', category: 'Tajweed' },
  { name: 'Quran 101 Tajweed', url: 'https://arrahmah.org/quran101_taj/ayah_prac.php', category: 'Tajweed' },
  { name: 'Quran 102 Tajweed', url: 'https://arrahmah.org/quran102_taj/ayah_prac.php', category: 'Tajweed' },
  { name: 'English Qaida', url: 'https://arrahmah.org/eng-qaida/qaida.php', category: 'Tajweed' },
  { name: 'Juz 30 Hifz', url: 'http://arrahmah.org/hifz_n/juz30.php', category: 'Tajweed' },
  { name: 'Taleem ul Quran 2013', url: 'https://arrahmah.org/tajweed_n/juz30.php', category: 'Tajweed' },

  // Subjects
  { name: 'Sahih al-Bukhari', url: 'https://arrahmah.org/sahih-al-bukhari/lessons.php', category: 'Subjects' },
  { name: 'Wirasat Course', url: 'http://www.arrahmah.org/inheritance_n/inheritance.php', category: 'Subjects' },
  { name: 'Seerah e Sahabah', url: 'https://arrahmah.org/seerah_sahabah/seerah_sahabah.php', category: 'Subjects' },
  { name: 'Adaab e Zindagi', url: 'https://arrahmah.org/adaab_zin/adaab_zin.php', category: 'Subjects' },
  { name: 'Aqeedah', url: 'https://arrahmah.org/aqeeda/aqeedah.php', category: 'Subjects' },

  // Lectures
  { name: 'Tazkeer', url: 'https://arrahmah.org/tazkeer/tazkeer.php', category: 'Lectures' },
  { name: 'Weekly Gems', url: 'https://arrahmah.org/weekly_gems.php', category: 'Lectures' },
  { name: 'Assorted Lectures', url: 'https://arrahmah.org/assorted_lectures.php', category: 'Lectures' },
  { name: 'Ramadan', url: 'https://arrahmah.org/ramadan_n/ramadan_daily_2025.php', category: 'Lectures' },
  { name: 'Hajj 2024', url: 'https://arrahmah.org/hajj2024/hajj2024.php', category: 'Lectures' },
  { name: 'Lectures on Namaz', url: 'https://arrahmah.org/namaz_n.php', category: 'Lectures' },
  { name: 'Lectures on Death', url: 'https://arrahmah.org/death_n.php', category: 'Lectures' },
];

async function testPage(page: TestPage, httpClient: HttpClient): Promise<{ success: boolean; error?: string; details?: any }> {
  try {
    console.log(`\n${'='.repeat(80)}`);
    console.log(`Testing: ${page.name}`);
    console.log(`Category: ${page.category}`);
    console.log(`URL: ${page.url}`);
    console.log(`${'='.repeat(80)}`);

    const scraper = new UniversalCourseScraper(httpClient, page.url);
    const content = await scraper.scrape();

    if (!content) {
      console.log(`❌ FAILED: No content returned`);
      return { success: false, error: 'No content returned' };
    }

    const totalLessons = content.surahs.reduce((sum, s) => sum + s.lessons.length, 0);

    console.log(`✅ SUCCESS`);
    console.log(`   Surahs: ${content.surahs.length}`);
    console.log(`   Total Lessons: ${totalLessons}`);

    // Show first surah details
    if (content.surahs.length > 0) {
      const firstSurah = content.surahs[0];
      console.log(`   First Surah: ${firstSurah.name}`);
      console.log(`   Groups: ${firstSurah.groups.map(g => g.name).join(', ')}`);

      if (firstSurah.lessons.length > 0) {
        const firstLesson = firstSurah.lessons[0];
        console.log(`   First Lesson: ${firstLesson.title}`);
        console.log(`   Item Groups: ${firstLesson.itemGroups.length}`);

        // Show sample items
        firstLesson.itemGroups.forEach((group, i) => {
          if (group.items.length > 0) {
            console.log(`     Group ${i + 1}: ${group.items.length} items (${group.items[0].type})`);
          }
        });
      }
    }

    return {
      success: true,
      details: {
        surahs: content.surahs.length,
        lessons: totalLessons,
      }
    };

  } catch (error: any) {
    console.log(`❌ ERROR: ${error.message}`);
    return { success: false, error: error.message };
  }
}

async function runAllTests() {
  console.log('🚀 Starting comprehensive arrahmah.org scraper tests...\n');

  const httpClient = new HttpClient();
  const results: { [category: string]: { passed: number; failed: number; pages: Array<{ name: string; success: boolean; error?: string }> } } = {};

  let totalPassed = 0;
  let totalFailed = 0;

  for (const page of TEST_PAGES) {
    const result = await testPage(page, httpClient);

    if (!results[page.category]) {
      results[page.category] = { passed: 0, failed: 0, pages: [] };
    }

    results[page.category].pages.push({
      name: page.name,
      success: result.success,
      error: result.error,
    });

    if (result.success) {
      results[page.category].passed++;
      totalPassed++;
    } else {
      results[page.category].failed++;
      totalFailed++;
    }

    // Small delay between requests
    await new Promise(resolve => setTimeout(resolve, 500));
  }

  // Print summary
  console.log(`\n\n${'='.repeat(80)}`);
  console.log('📊 TEST SUMMARY');
  console.log(`${'='.repeat(80)}`);

  Object.entries(results).forEach(([category, stats]) => {
    console.log(`\n${category}:`);
    console.log(`  ✅ Passed: ${stats.passed}`);
    console.log(`  ❌ Failed: ${stats.failed}`);

    if (stats.failed > 0) {
      console.log(`  Failed pages:`);
      stats.pages.filter(p => !p.success).forEach(p => {
        console.log(`    - ${p.name}: ${p.error}`);
      });
    }
  });

  console.log(`\n${'='.repeat(80)}`);
  console.log(`OVERALL: ${totalPassed}/${TEST_PAGES.length} tests passed`);
  console.log(`${'='.repeat(80)}\n`);

  if (totalFailed > 0) {
    process.exit(1);
  }
}

runAllTests().catch(error => {
  console.error('Fatal error:', error);
  process.exit(1);
});
