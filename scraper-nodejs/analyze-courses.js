const fs = require('fs');
const path = require('path');

const dataPath = path.join(__dirname, 'data', 'scraped_data.json');

// Check if file exists
if (!fs.existsSync(dataPath)) {
  console.log('❌ File does not exist at:', dataPath);
  console.log('\nPlease run the scraper first with: npm run scrape');
  process.exit(1);
}

try {
  // Read and parse JSON
  console.log('📖 Reading file from:', dataPath);
  const fileContent = fs.readFileSync(dataPath, 'utf8');
  const data = JSON.parse(fileContent);

  console.log('\n=== FILE STATISTICS ===');
  console.log('File size:', (fileContent.length / 1024 / 1024).toFixed(2), 'MB');

  // Check structure
  if (!data.appData) {
    console.log('❌ Missing appData in root');
    process.exit(1);
  }

  if (!data.appData.courses) {
    console.log('❌ Missing courses in appData');
    process.exit(1);
  }

  const courses = data.appData.courses;

  console.log('\n=== COURSE COUNT ===');
  console.log('Total courses:', courses.length);

  if (courses.length === 0) {
    console.log('⚠️  No courses found in array');
    process.exit(0);
  }

  const firstCourse = courses[0];

  console.log('\n=== STRUCTURE CHECK ===');
  console.log('Has title:', 'title' in firstCourse);
  console.log('Has imageUrl:', 'imageUrl' in firstCourse);
  console.log('Has buttons:', 'buttons' in firstCourse);
  console.log('Has sections:', 'sections' in firstCourse);

  console.log('\n=== FIRST COURSE KEYS ===');
  console.log(Object.keys(firstCourse));

  console.log('\n=== FIRST COURSE STRUCTURE ===\n');
  console.log(JSON.stringify(firstCourse, null, 2));

} catch (error) {
  console.error('❌ Error:', error.message);
  process.exit(1);
}
