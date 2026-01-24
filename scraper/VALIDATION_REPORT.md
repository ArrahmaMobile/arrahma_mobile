# Quran Courses Data Validation Report
## Date: 2026-01-19

## Summary
Based on comparison between the scraped data at `/Users/shah/Documents/repos/arrahma_mobile/scraper-nodejs/data/scraped_data.json` and the live website at https://arrahmah.org

### Total Courses Found:
- **Scraped Data**: 6 main courses + 5 courses in 2 other groups = 11 total courses
- **Live Website**: 11 courses visible on homepage

---

## MAJOR ISSUES IDENTIFIED

### 1. Button URLs are NULL (CRITICAL)
All button URLs in the scraped data are `null` when they should contain actual URLs.

**Expected vs Actual for each course:**

#### Adv. Taleem ul Quran (ATQ)
- **Scraped**: Details (null), Join Now (null)
- **Live Website**:
  - Details: `https://www.arrahmah.org/ATQ2025.pdf`
  - Join Now: `https://arrahmah.org/q2025/form.php`

#### Taleem ul Quran (TQ)
- **Scraped**: Details (null), Join Now (null)
- **Live Website**:
  - Details: `http://arrahmah.org/TQ2025.pdf`
  - Join Now: `https://arrahmah.org/q2025/form.php`

#### Fehem ul Quran (FQ)
- **Scraped**: Details (null), Join Now (null)
- **Live Website**:
  - Details: `https://www.arrahmah.org/FQ2025.pdf`
  - Join Now: `https://arrahmah.org/q2025/form.php`

#### Ahsan ul Bayan
- **Scraped**: Details (null), Reg. closed (null)
- **Live Website**:
  - Details: `https://www.arrahmah.org/courses_details/ahsan.php`
  - Reg. closed: `#` (inactive)

#### Al-Furqan
- **Scraped**: Details (null), Reg. closed (null)
- **Live Website**:
  - Details: `http://www.arrahmah.org/courses_details/furqan.php`
  - Reg. closed: `#` (inactive)

#### Ilm ul Yaqeen
- **Scraped**: Details (null), Reg. closed (null)
- **Live Website**:
  - Details: `https://www.arrahmah.org/courses_details/ilm.php`
  - Reg. closed: `#` (inactive)

#### Quran 101
- **Scraped**: Details (null), Reg.closed (null)
- **Live Website**:
  - Details: `http://www.arrahmah.org/q101.pdf`
  - Reg.closed: `#` (inactive)

#### Quran 102
- **Scraped**: Details (null), Join Now (null)
- **Live Website**:
  - Details: `https://www.arrahmah.org/q102.pdf`
  - Join Now: `https://www.arrahmah.org/quran102/form.php`

#### Tafseer in English
- **Scraped**: Details (null), Join Now (null)
- **Live Website**:
  - Details: `http://arrahmah.org/eng2022.pdf`
  - Join Now: `https://arrahmah.org/eng-course/form/form.php`

#### Tafseer in Pashtu
- **Scraped**: Details (null), Join Now (null)
- **Live Website**:
  - Details: `http://arrahmah.org/flyers/pashtu2025-c.pdf`
  - Join Now: `https://docs.google.com/forms/d/1unZzQcS6-ViFIbwl7Rdxmhk978jWF4H2w1vh-lZF1ZQ/viewform?edit_requested=true`

#### Tafseer in Farsi
- **Scraped**: Details (null), Join Now (null)
- **Live Website**:
  - Details: `https://arrahmah.org/flyers/farsi(t)_flyer.jpeg`
  - Join Now: `https://docs.google.com/forms/d/e/1FAIpQLSe33m6ueKX3Q-n58yP_24sYXZoMYoxGDrHeqIyfDb8rk5_sqw/viewform`

---

### 2. Section Data is NULL or Empty (CRITICAL)
All course sections have null titles and empty items arrays.

**Expected Section Data (from live website):**

#### Adv. Taleem ul Quran - Expected Sections:
1. **Tafseer**: `https://arrahmah.org/tafseer2025/juz1.php`
2. **Tajweed**: `http://arrahmah.org/atq_taj/atq-baq.php`
3. **Tests**: `http://arrahmah.org/juz-tests.php`

**Scraped**: All sections have `null` title and empty items

#### Taleem ul Quran - Expected Sections:
1. **Tafseer**: `https://arrahmah.org/tafseer2025/juz1.php`
2. **Tajweed**: `http://arrahmah.org/tq_taj/tq-letters.php`
3. **Tests**: `http://arrahmah.org/juz-tests.php`

**Scraped**: All sections have `null` title and empty items

#### Fehem ul Quran - Expected Sections:
1. **Tafseer**: `https://arrahmah.org/tafseer2025/juz1.php`
2. **Tajweed**: `http://arrahmah.org/fq_taj/fq-letters.php`
3. **Tests**: `http://arrahmah.org/juz-tests.php`

**Scraped**: All sections have `null` title and empty items

#### Ahsan ul Bayan - Expected Sections:
1. **AB 2016 Tafseer**: `https://arrahmah.org/ab/juz25.php`
2. **AB 2017 Tafseer**: `https://arrahmah.org/ab/juz24.php`

**Scraped**: Single section with `null` title and empty items

#### Al-Furqan - Expected Sections:
1. **AF 2016 Tafseer**: `https://arrahmah.org/af/juz25.php`
2. **AF 2017 Tafseer**: `https://arrahmah.org/af/juz24.php`
3. **AF 2018 Tafseer**: `https://arrahmah.org/af/juz22.php`

**Scraped**: Single section with `null` title and empty items

#### Ilm ul Yaqeen - Expected Sections:
1. **IQ 2018 Tafseer**: `https://arrahmah.org/iq/juz22.php`

**Scraped**: Single section with `null` title and empty items

#### Quran 101 - Expected Sections:
1. **Latest Lect**: `https://arrahmah-media.org/latest_lects_n/quran101.mp3`
2. **Tafseer**: `http://arrahmah.org/q101_taf/juz15.php`
3. **Tajweed**: `http://arrahmah.org/quran101_taj/ayah_prac.php`
4. **Tests**: `http://arrahmah.org/tests-q101.php`

**Scraped**: All sections have `null` title and empty items

#### Quran 102 - Expected Sections:
1. **Latest Lect**: `https://arrahmah-media.org/latest_lects_n/quran102.mp3`
2. **Tafseer**: `http://arrahmah.org/q102_taf/juz3.php`
3. **Tajweed**: `http://arrahmah.org/quran102_taj/ayah_prac.php`
4. **Tests**: `http://arrahmah.org/tests-q102.php`

**Scraped**: All sections have `null` title and empty items

#### Tafseer in English - Expected Sections:
1. **Latest Lect**: `https://filedn.com/lYVXaQXjsnDpmndt09ArOXz/latest_lects_n/eng.mp3`
2. **Tafseer**: `https://www.arrahmah.org/quran_english/juz7.php`
3. **Tests**: `https://arrahmah.org/tests-english.php`

**Scraped**: All sections have `null` title and empty items

#### Tafseer in Pashtu - Expected Sections:
1. **Latest Lect**: `https://arrahmah-media.org/latest_lects_n/pashtu.mp3`
2. **Tafseer**: `http://arrahmah.org/pashtu_2019_n/juz30.php`
3. **Tajweed**: `http://arrahmah.org/pashtu_taj_n/pashtu.php`
4. **Tests**: `http://arrahmah.org/testsp_n.php`

**Scraped**: All sections have `null` title and empty items

#### Tafseer in Farsi - Expected Sections:
1. **Lectures**: `http://arrahmah.org/farsi/fq/juz3.php`
2. **Tests**: `#` (inactive)

**Scraped**: All sections have `null` title and empty items

---

### 3. MISSING COURSES (CRITICAL)
The user requested validation of specific historical Tafseer courses that are NOT present in the scraped data:

#### Missing Tafseer Courses:
- **Tafseer 2025 (Urdu)** - This is the CURRENT/ACTIVE course, accessed via the main 2025 courses (ATQ, TQ, FQ)
  - URL: `https://arrahmah.org/tafseer2025/juz1.php`
  - Status: Currently running (Jan 2026)
  
- **Tafseer 2022 (English)** - Found as "Tafseer in English"
  - Status: ✓ PRESENT in scraped data
  
- **Tafseer 2019 (Urdu)** - NOT FOUND in main courses
  - Expected to be an archived/historical course
  
- **Tafseer 2013 (Urdu)** - NOT FOUND
  - Expected to be an archived course
  
- **Tafseer 2007 (Urdu)** - NOT FOUND  
  - Expected to be an archived course

#### Note on Historical Courses:
The older Tafseer courses (2007, 2013, 2019) may be:
1. Archived and only accessible via navigation menu dropdown
2. Listed in a sidebar "Tafseer Courses" accordion section
3. Not displayed on the main homepage

These courses were NOT captured by the scraper, which only scraped the homepage course cards.

---

## CORRECT DATA VERIFICATION

### Verified Correct:
1. **Course Titles**: ✓ All 11 course titles are correct
2. **Course Images**: ✓ All image URLs are correct
3. **Button Labels**: ✓ Button labels are correct ("Details", "Join Now", "Reg. closed")
4. **Button States**: ✓ Active/Inactive states are correct

---

## RECOMMENDATION

### High Priority Fixes Required:
1. **Fix button URL extraction** - All button `link.data` fields must be populated with actual URLs from the website
2. **Fix section data extraction** - Section titles and item links are completely missing
3. **Add historical Tafseer courses** - Need to scrape from navigation menu or sidebar, not just homepage cards

### Data Completeness:
- Current scraper coverage: ~40% (titles and images only)
- Missing critical data: 60% (button URLs, section links, historical courses)


---

## ADDITIONAL FINDINGS

### Other Course Section: "SUBJECTS WE OFFER COMING SOON"
The website has a section titled "SUBJECTS WE OFFER COMING SOON" with the following courses:

1. **Sahih al-Bukhari (Hadith Class)** - ACTIVE
   - Details: `https://arrahmah.org/hadith2026-flyer.pdf`
   - Join Now: `https://hadith.arrahmah.org/hadith`
   - Sections:
     - lessons: `https://arrahmah.org/sahih-al-bukhari/lessons.php`
     - Tests: `https://hadith.arrahmah.org/hadith/login`
     - Attendance: `https://hadith.arrahmah.org/hadith/login`

2. **Additional Coming Soon Courses** (5 total)
   - All have placeholder buttons (Details: "#", Join Now: "#")
   - These appear to be placeholders for future courses

**Status in Scraped Data**: NOT PRESENT

This section is completely missing from the scraped data.

---

## COURSE COUNT SUMMARY

### Homepage Courses:
| Section | Live Website | Scraped Data | Status |
|---------|-------------|--------------|--------|
| COURSES WE OFFER (Main) | 3 | 3 | ✓ Present |
| COURSES WE OFFER (Closed) | 3 | 3 | ✓ Present |
| STEADY-PACED Courses | 2 | 2 | ✓ Present |
| Courses IN OTHER LANGUAGES | 3 | 3 | ✓ Present |
| SUBJECTS WE OFFER COMING SOON | 6 | 0 | ✗ Missing |
| **TOTAL** | **17** | **11** | **6 Missing** |

### Historical Tafseer Courses (from requirements):
| Course | Expected Location | Scraped Data | Status |
|--------|------------------|--------------|--------|
| Tafseer 2025 (Urdu) | Active via ATQ/TQ/FQ | Via main courses | ✓ Accessible |
| Tafseer 2022 (English) | Active | Present as "Tafseer in English" | ✓ Present |
| Tafseer 2019 (Urdu) | Archive/Menu | Not found | ✗ Missing |
| Tafseer 2013 (Urdu) | Archive/Menu | Not found | ✗ Missing |
| Tafseer 2007 (Urdu) | Archive/Menu | Not found | ✗ Missing |
| Ahsan-ul-Bayan (Urdu) | Homepage | Present | ✓ Present |
| Al-Furqan (Urdu) | Homepage | Present | ✓ Present |
| Ilm-ul-Yaqeen (Urdu) | Homepage | Present | ✓ Present |
| Quran 101 (Urdu) | Homepage | Present | ✓ Present |
| Quran 102 (Urdu) | Homepage | Present | ✓ Present |
| Pashtu courses | Homepage | Present | ✓ Present |
| Farsi course | Homepage | Present | ✓ Present |
| Tajweed/Hifz courses | Via main courses (sections) | Sections empty | ✗ Data Missing |

---

## FINAL VALIDATION SUMMARY

### Critical Issues (Must Fix):
1. ✗ **All button URLs are NULL** - 22 button URLs missing
2. ✗ **All section data is NULL/empty** - ~35+ section links missing
3. ✗ **6 courses from "SUBJECTS WE OFFER COMING SOON" not scraped**
4. ✗ **Historical Tafseer courses (2007, 2013, 2019) not found**

### What Works:
1. ✓ Course titles are correct (11/11)
2. ✓ Course images are correct (11/11)
3. ✓ Button labels are correct
4. ✓ Button active/inactive states are correct
5. ✓ Course groupings are correct

### Overall Data Quality:
- **Structural Data**: 100% correct (titles, images, groupings)
- **Functional Data**: 0% correct (all URLs missing)
- **Completeness**: 65% (11 of 17 homepage courses captured)
- **Historical Courses**: 0% (none of the archived courses captured)

### Scraper needs to:
1. Extract href attributes from button links
2. Extract href attributes from section item links  
3. Scrape the "SUBJECTS WE OFFER COMING SOON" section
4. Scrape historical courses from navigation menu or sidebar accordion

