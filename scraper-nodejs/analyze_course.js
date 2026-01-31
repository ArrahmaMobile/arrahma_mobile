const fs = require('fs');

// Read the file
const data = JSON.parse(fs.readFileSync('./data/scraped_data.json', 'utf8'));

// Find the first course
let firstCourse = null;
for (const item of data.appData.drawerItems) {
    if (item.content && item.content.surahs) {
        firstCourse = item.content;
        break;
    }
}

if (firstCourse) {
    console.log("=".repeat(80));
    console.log("FIRST COURSE TITLE:");
    console.log("=".repeat(80));
    console.log(`ID: ${firstCourse.id}`);
    console.log(`Title: ${firstCourse.title}`);
    console.log();

    console.log("=".repeat(80));
    console.log("COURSE OBJECT STRUCTURE (Schema):");
    console.log("=".repeat(80));
    console.log("Top-level fields in course object:");
    Object.keys(firstCourse).forEach(key => {
        const type = Array.isArray(firstCourse[key]) ? 'Array' : typeof firstCourse[key];
        console.log(`  - ${key}: ${type}`);
    });
    console.log();

    console.log("=".repeat(80));
    console.log("SURAHS ARRAY STRUCTURE:");
    console.log("=".repeat(80));
    if (firstCourse.surahs && firstCourse.surahs.length > 0) {
        const firstSurah = firstCourse.surahs[0];
        console.log("Fields in a surah object:");
        Object.keys(firstSurah).forEach(key => {
            const type = Array.isArray(firstSurah[key]) ? 'Array' : typeof firstSurah[key];
            console.log(`  - ${key}: ${type}`);
        });
        console.log();

        // Show groups structure if present
        if (firstSurah.groups && firstSurah.groups.length > 0) {
            console.log("Structure of 'groups' array items:");
            Object.keys(firstSurah.groups[0]).forEach(key => {
                console.log(`    - ${key}: ${typeof firstSurah.groups[0][key]}`);
            });
            console.log();
        }

        // Show lessons structure if present
        if (firstSurah.lessons && firstSurah.lessons.length > 0) {
            const firstLesson = firstSurah.lessons[0];
            console.log("Structure of 'lessons' array items:");
            Object.keys(firstLesson).forEach(key => {
                const type = Array.isArray(firstLesson[key]) ? 'Array' : typeof firstLesson[key];
                console.log(`    - ${key}: ${type}`);
            });
            console.log();

            // Show itemGroups structure
            if (firstLesson.itemGroups && firstLesson.itemGroups.length > 0) {
                const firstItemGroup = firstLesson.itemGroups[0];
                console.log("  Structure of 'itemGroups' array items:");
                Object.keys(firstItemGroup).forEach(key => {
                    const type = Array.isArray(firstItemGroup[key]) ? 'Array' : typeof firstItemGroup[key];
                    console.log(`      - ${key}: ${type}`);
                });

                // Find a non-empty items array to show link structure
                const nonEmptyGroup = firstLesson.itemGroups.find(g => g.items && g.items.length > 0);
                if (nonEmptyGroup && nonEmptyGroup.items.length > 0) {
                    console.log("\n        Link object fields (from first non-empty items array):");
                    Object.keys(nonEmptyGroup.items[0]).forEach(key => {
                        console.log(`          - ${key}: ${typeof nonEmptyGroup.items[0][key]}`);
                    });
                }
            }
        }
    }
    console.log();

    console.log("=".repeat(80));
    console.log("FIRST COURSE DATA SAMPLE (First 100 lines):");
    console.log("=".repeat(80));
    const courseJson = JSON.stringify(firstCourse, null, 2);
    const lines = courseJson.split('\n');
    lines.slice(0, 100).forEach((line, i) => {
        console.log(`${String(i + 1).padStart(3)}: ${line}`);
    });

    if (lines.length > 100) {
        console.log(`\n... (${lines.length - 100} more lines)`);
    }
} else {
    console.log("No course found with content and surahs");
}
