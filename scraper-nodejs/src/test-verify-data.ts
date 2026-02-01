/**
 * Comprehensive data verification test
 * This test not only checks if scraping succeeds, but verifies the actual data quality
 */

import { HttpClient } from './core/http-client';
import { UniversalCourseScraper } from './scrapers/universal-scraper';
import { QuranCourseContent, Lesson, ItemType } from './types/models';

interface VerificationTest {
  name: string;
  url: string;
  category: string;
  expectedMinLessons: number;
  expectedMinSurahs: number;
  shouldHaveAudioVideo: boolean;
  shouldHaveMultipleGroups?: boolean;
}

const VERIFICATION_TESTS: VerificationTest[] = [
  // Bootstrap-based pages
  {
    name: 'Seerah e Sahabah (Bootstrap)',
    url: 'https://arrahmah.org/seerah_sahabah/seerah_sahabah.php',
    category: 'Bootstrap',
    expectedMinLessons: 40,
    expectedMinSurahs: 1,
    shouldHaveAudioVideo: true,
    shouldHaveMultipleGroups: false
  },
  {
    name: 'Adv Taleem ul Quran Tajweed (Bootstrap Multi-page)',
    url: 'https://arrahmah.org/atq_taj/atq-baq.php',
    category: 'Bootstrap',
    expectedMinLessons: 250,
    expectedMinSurahs: 3,
    shouldHaveAudioVideo: true,
    shouldHaveMultipleGroups: true
  },
  {
    name: 'Sahih al-Bukhari (Bootstrap)',
    url: 'https://arrahmah.org/sahih-al-bukhari/lessons.php',
    category: 'Bootstrap',
    expectedMinLessons: 3,
    expectedMinSurahs: 1,
    shouldHaveAudioVideo: true
  },

  // Tabbed interface
  {
    name: 'Assorted Lectures (Tabbed)',
    url: 'https://arrahmah.org/assorted_lectures.php',
    category: 'Tabbed',
    expectedMinLessons: 200,
    expectedMinSurahs: 10,
    shouldHaveAudioVideo: true
  },

  // Simple list pages
  {
    name: 'Pashtu Tajweed (Simple List)',
    url: 'https://arrahmah.org/pashtu_taj_n/pashtu_letters.php',
    category: 'Simple List',
    expectedMinLessons: 25,
    expectedMinSurahs: 1,
    shouldHaveAudioVideo: true
  },
  {
    name: 'Lectures on Death (Simple List)',
    url: 'https://arrahmah.org/death_n.php',
    category: 'Simple List',
    expectedMinLessons: 5,
    expectedMinSurahs: 1,
    shouldHaveAudioVideo: false // This page has PDFs and PPSX, not audio/video
  },
];

function verifyLesson(lesson: Lesson): string[] {
  const issues: string[] = [];

  // Check title
  if (!lesson.title || lesson.title.length < 3) {
    issues.push(`Invalid title: "${lesson.title}"`);
  }

  // Check for overly long titles (might be scraping errors)
  if (lesson.title && lesson.title.length > 500) {
    issues.push(`Title too long (${lesson.title.length} chars): "${lesson.title.substring(0, 100)}..."`);
  }

  // Check item groups
  if (!lesson.itemGroups || lesson.itemGroups.length === 0) {
    issues.push(`No item groups found for lesson: "${lesson.title}"`);
  } else {
    lesson.itemGroups.forEach((group, idx) => {
      if (!group.items || group.items.length === 0) {
        issues.push(`Empty item group ${idx} in lesson: "${lesson.title}"`);
      } else {
        group.items.forEach(item => {
          // Check URL validity (Item uses 'data' field for URL)
          if (!item.data || !item.data.startsWith('http')) {
            issues.push(`Invalid URL in lesson "${lesson.title}": ${item.data}`);
          }

          // Check type is set
          if (!item.type) {
            issues.push(`Missing type for item in lesson "${lesson.title}": ${item.data}`);
          }

          // Verify URL matches type (relaxed validation)
          const urlLower = item.data.toLowerCase();
          if (item.type === ItemType.Audio) {
            if (!urlLower.includes('.mp3') && !urlLower.includes('.mp4') && !urlLower.includes('.m4a')) {
              issues.push(`Type mismatch: Audio but URL is ${item.data}`);
            }
          }
          if (item.type === ItemType.Video) {
            if (!urlLower.includes('.mp4') && !urlLower.includes('youtube.com') && !urlLower.includes('youtu.be')) {
              issues.push(`Type mismatch: Video but URL is ${item.data}`);
            }
          }
          if (item.type === ItemType.Pdf) {
            if (!urlLower.includes('.pdf') && !urlLower.includes('.ppsx')) {
              issues.push(`Type mismatch: Pdf but URL is ${item.data}`);
            }
          }
        });
      }
    });
  }

  return issues;
}

function verifyContent(content: QuranCourseContent, test: VerificationTest): {
  passed: boolean;
  issues: string[];
  stats: any;
} {
  const issues: string[] = [];

  // Check basic structure
  if (!content.id) issues.push('Missing content ID');
  if (!content.title) issues.push('Missing content title');
  if (!content.surahs) issues.push('Missing surahs array');

  // Check surahs count
  if (content.surahs.length < test.expectedMinSurahs) {
    issues.push(`Expected at least ${test.expectedMinSurahs} surahs, got ${content.surahs.length}`);
  }

  // Count total lessons
  const totalLessons = content.surahs.reduce((sum, s) => sum + s.lessons.length, 0);
  if (totalLessons < test.expectedMinLessons) {
    issues.push(`Expected at least ${test.expectedMinLessons} lessons, got ${totalLessons}`);
  }

  // Verify each surah and lesson
  let audioVideoCount = 0;
  let lessonIssueCount = 0;

  content.surahs.forEach((surah, sIdx) => {
    if (!surah.name) {
      issues.push(`Surah ${sIdx} has no name`);
    }

    if (!surah.lessons || surah.lessons.length === 0) {
      issues.push(`Surah "${surah.name}" has no lessons`);
    }

    if (!surah.groups) {
      issues.push(`Surah "${surah.name}" has no groups`);
    }

    surah.lessons.forEach(lesson => {
      const lessonIssues = verifyLesson(lesson);
      if (lessonIssues.length > 0) {
        lessonIssueCount++;
        // Only show first few lesson issues to avoid spam
        if (lessonIssueCount <= 3) {
          issues.push(...lessonIssues);
        }
      }

      // Count audio/video items
      lesson.itemGroups.forEach(group => {
        group.items.forEach(item => {
          if (item.type === ItemType.Audio || item.type === ItemType.Video) {
            audioVideoCount++;
          }
        });
      });
    });
  });

  if (lessonIssueCount > 3) {
    issues.push(`... and ${lessonIssueCount - 3} more lessons with issues`);
  }

  // Check for audio/video if expected
  if (test.shouldHaveAudioVideo && audioVideoCount === 0) {
    issues.push('Expected audio/video content but found none');
  }

  // Gather stats
  const stats = {
    surahs: content.surahs.length,
    lessons: totalLessons,
    audioVideoItems: audioVideoCount,
    groups: content.surahs[0]?.groups?.length || 0,
    sampleLesson: content.surahs[0]?.lessons[0]?.title || 'N/A',
    sampleUrl: content.surahs[0]?.lessons[0]?.itemGroups[0]?.items[0]?.data || 'N/A'
  };

  return {
    passed: issues.length === 0,
    issues,
    stats
  };
}

async function testPage(test: VerificationTest, httpClient: HttpClient) {
  console.log(`\n${'='.repeat(80)}`);
  console.log(`🔍 VERIFYING: ${test.name}`);
  console.log(`Category: ${test.category}`);
  console.log(`URL: ${test.url}`);
  console.log(`${'='.repeat(80)}`);

  try {
    const scraper = new UniversalCourseScraper(httpClient, test.url);
    const content = await scraper.scrape();

    if (!content) {
      console.log(`❌ FAILED: No content returned`);
      return { success: false, test: test.name };
    }

    const verification = verifyContent(content, test);

    console.log(`\n📊 Statistics:`);
    console.log(`   Surahs/Sections: ${verification.stats.surahs}`);
    console.log(`   Total Lessons: ${verification.stats.lessons}`);
    console.log(`   Audio/Video Items: ${verification.stats.audioVideoItems}`);
    console.log(`   Groups per Surah: ${verification.stats.groups}`);
    console.log(`   Sample Lesson: "${verification.stats.sampleLesson}"`);
    console.log(`   Sample URL: ${verification.stats.sampleUrl.substring(0, 70)}...`);

    if (verification.passed) {
      console.log(`\n✅ PASSED: All data quality checks passed!`);
      return { success: true, test: test.name };
    } else {
      console.log(`\n⚠️  ISSUES FOUND (${verification.issues.length}):`);
      verification.issues.forEach((issue, idx) => {
        console.log(`   ${idx + 1}. ${issue}`);
      });
      return { success: false, test: test.name, issues: verification.issues };
    }

  } catch (error: any) {
    console.log(`\n❌ ERROR: ${error.message}`);
    return { success: false, test: test.name, error: error.message };
  }
}

async function runVerification() {
  console.log('🚀 Starting comprehensive data verification...\n');
  console.log(`Testing ${VERIFICATION_TESTS.length} representative pages across all strategies\n`);

  const httpClient = new HttpClient();
  const results: any[] = [];

  for (const test of VERIFICATION_TESTS) {
    const result = await testPage(test, httpClient);
    results.push(result);

    // Small delay between requests
    await new Promise(resolve => setTimeout(resolve, 1000));
  }

  // Print summary
  console.log(`\n\n${'='.repeat(80)}`);
  console.log('📊 VERIFICATION SUMMARY');
  console.log(`${'='.repeat(80)}`);

  const passed = results.filter(r => r.success).length;
  const failed = results.filter(r => !r.success).length;

  console.log(`\n✅ Passed: ${passed}/${VERIFICATION_TESTS.length}`);
  console.log(`❌ Failed: ${failed}/${VERIFICATION_TESTS.length}`);

  if (failed > 0) {
    console.log(`\nFailed tests:`);
    results.filter(r => !r.success).forEach(r => {
      console.log(`  - ${r.test}`);
      if (r.error) console.log(`    Error: ${r.error}`);
    });
  }

  console.log(`\n${'='.repeat(80)}`);

  if (failed === 0) {
    console.log(`\n🎉 ALL VERIFICATION TESTS PASSED!`);
    console.log(`Scraped data quality is excellent across all page types.`);
  } else {
    console.log(`\n⚠️  Some tests failed. Review issues above.`);
  }

  console.log(`${'='.repeat(80)}\n`);

  process.exit(failed > 0 ? 1 : 0);
}

runVerification().catch(error => {
  console.error('Fatal error:', error);
  process.exit(1);
});
