const { CourseContentScraper } = require('./dist/scrapers/course-content.scraper');
const { HttpClient } = require('./dist/core/http-client');
const cheerio = require('cheerio');

async function test() {
  console.log('Testing Juz1 scraper (single page)...\n');

  const httpClient = new HttpClient('https://arrahmah.org');

  // Load the page directly
  const html = await httpClient.get('/tafseer2025/juz1.php');
  const $ = cheerio.load(html);

  // Call the scrapeNewStructure method directly
  const scraper = new CourseContentScraper(httpClient, 'https://arrahmah.org/tafseer2025/juz1.php');

  // We need to access the private method, so let's just inline it here
  // Instead, let's create a simpler version that doesn't use the multi-juz logic

  console.log('Page loaded. Checking structure...');
  console.log('Containers with my-3:', $('.container.my-3').length);
  console.log('Containers with my-4:', $('.container.my-4').length);
  console.log('Total containers:', $('.container').length);

  // Check for practice words
  const practiceWordsText = $('h5').text();
  console.log('\nH5 heading:', practiceWordsText);

  const $h5Next = $('h5').parent().next();
  console.log('Next element after h5 parent:', $h5Next.prop('tagName'), $h5Next.attr('class'));
  console.log('Has practice words text:', $h5Next.text().includes('Practice Words'));

  // Check for introduction
  const introStrong = $('strong').filter((i, el) => $(el).text().trim() === 'Introduction');
  console.log('\nIntroduction strong found:', introStrong.length);

  // Check for Juz header
  const juzHeaders = $('.container.my-3').find('.row').filter((i, el) => {
    const style = $(el).attr('style') || '';
    return style.includes('#0a2e4f');
  });
  console.log('Juz headers found:', juzHeaders.length);
  juzHeaders.each((i, el) => {
    console.log(`  ${i + 1}. ${$(el).text().trim().substring(0, 50)}`);
  });

  // Check for Surah headers
  const surahHeaders = $('.container.my-3').find('.row').filter((i, el) => {
    const style = $(el).attr('style') || '';
    return style.includes('#ecece3');
  });
  console.log('\nSurah headers found:', surahHeaders.length);
  surahHeaders.each((i, el) => {
    console.log(`  ${i + 1}. ${$(el).text().trim().substring(0, 50)}`);
  });
}

test().catch(console.error);
