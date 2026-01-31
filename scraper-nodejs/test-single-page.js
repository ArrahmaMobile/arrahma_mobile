const cheerio = require('cheerio');
const { HttpClient } = require('./dist/core/http-client');
const { CourseContentScraper } = require('./dist/scrapers/course-content.scraper');
const fs = require('fs');

async function test() {
  console.log('Testing single page scrape (bypassing multi-juz)...\n');

  const httpClient = new HttpClient();

  // Download the page
  const html = await httpClient.download('/tafseer2025/juz1.php');
  if (!html) {
    console.error('Failed to download page');
    return;
  }

  const $ = cheerio.load(html);

  // Remove the Juz selector to force single-page mode
  $('#selectJuz').remove();

  // Create scraper instance and access its scrapeNewStructure method
  const scraper = new CourseContentScraper(httpClient, 'https://arrahmah.org/tafseer2025/juz1.php');

  // Since scrapeNewStructure is private, we need to call scrape() but with modified HTML
  // Instead, let's inline test the logic

  console.log('Page structure:');
  console.log('- container.my-3:', $('.container.my-3').length);
  console.log('- container.my-4:', $('.container.my-4').length);
  console.log('- Standalone rows:', $('body > .row').length);
  console.log('- Has Juz selector:', $('#selectJuz').length > 0);

  // Now scrape it (will use single page mode since we removed selector)
  const tempHtml = $.html();
  fs.writeFileSync('/tmp/test-page.html', tempHtml);

  console.log('\nSaved modified HTML to /tmp/test-page.html');
  console.log('Now calling scraper...\n');
}

test().catch(console.error);
