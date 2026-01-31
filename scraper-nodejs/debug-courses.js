const fs = require('fs');

try {
  const data = JSON.parse(fs.readFileSync('./data/scraped_data.json', 'utf-8'));

  console.log('=== COURSES STRUCTURE ===\n');
  console.log('Number of courses:', data.appData.courses?.length || 0);
  console.log('Number of otherCourseGroups:', data.appData.otherCourseGroups?.length || 0);
  console.log('\n=== FIRST COURSE ===\n');

  if (data.appData.courses && data.appData.courses.length > 0) {
    const firstCourse = data.appData.courses[0];
    console.log('Title:', firstCourse.title);
    console.log('ImageUrl:', firstCourse.imageUrl);
    console.log('Number of buttons:', firstCourse.buttons?.length || 0);
    console.log('Number of sections:', firstCourse.sections?.length || 0);

    console.log('\nButtons:');
    if (firstCourse.buttons) {
      firstCourse.buttons.forEach((btn, i) => {
        console.log(`  ${i + 1}. ${btn.label} (${btn.type}) - Active: ${btn.isActive}`);
      });
    }

    console.log('\nSections:');
    if (firstCourse.sections) {
      firstCourse.sections.forEach((section, i) => {
        console.log(`  ${i + 1}. ${section.label} - Icon: ${section.icon || 'none'}`);
        if (section.content) {
          if (section.content.items) {
            console.log(`     MediaContent with ${section.content.items.length} items`);
          } else if (section.content.surahs) {
            console.log(`     QuranCourseContent with ${section.content.surahs.length} surahs`);
          }
        }
      });
    }

    console.log('\n=== FULL FIRST COURSE JSON (first 2000 chars) ===\n');
    console.log(JSON.stringify(firstCourse, null, 2).substring(0, 2000));
  } else {
    console.log('NO COURSES FOUND!');
  }

} catch (error) {
  console.error('Error:', error.message);
  process.exit(1);
}
