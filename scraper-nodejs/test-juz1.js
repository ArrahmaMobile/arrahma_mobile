const { CourseContentScraper } = require('./dist/scrapers/course-content.scraper');
const { HttpClient } = require('./dist/core/http-client');

async function test() {
  console.log('Testing Juz1 scraper...\n');

  const httpClient = new HttpClient('https://arrahmah.org');
  const scraper = new CourseContentScraper(httpClient, 'https://arrahmah.org/tafseer2025/juz1.php');

  const result = await scraper.scrape();

  if (result) {
    console.log('\n=== RESULT ===');
    console.log('Title:', result.title);
    console.log('Practice Words:', result.practiceWords?.length || 0);
    console.log('Introduction Lessons:', result.introductionLessons?.length || 0);
    console.log('Surahs:', result.surahs.length);

    if (result.practiceWords && result.practiceWords.length > 0) {
      console.log('\n--- Practice Words ---');
      result.practiceWords.forEach((item, i) => {
        console.log(`  ${i + 1}. ${item.data}`);
      });
    }

    if (result.introductionLessons && result.introductionLessons.length > 0) {
      console.log('\n--- Introduction Lessons ---');
      result.introductionLessons.forEach((lesson, i) => {
        console.log(`  ${i + 1}. ${lesson.title}`);
      });
    }

    console.log('\n--- Surahs ---');
    result.surahs.forEach((surah, i) => {
      console.log(`\nSurah ${i + 1}: ${surah.name}`);
      console.log(`  Lessons: ${surah.lessons.length}`);
      surah.lessons.forEach((lesson, li) => {
        console.log(`    ${li + 1}. ${lesson.title}`);
      });
    });
  } else {
    console.log('No result returned');
  }
}

test().catch(console.error);
