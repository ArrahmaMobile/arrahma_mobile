# Scraper Validation Checklist for Arrahmah.org

## Overview
This document provides a comprehensive checklist to validate that the scraper is capturing all necessary data from arrahmah.org.

---

## 1. HOMEPAGE DATA CAPTURE

### ✓ Hero Carousel/Slider Content
- [ ] Slide 1: Latest Lecture announcement
- [ ] Slide 2: Friday Class Announcements
- [ ] Slide 3: Tajweed 2025 instructions
- [ ] Slide 4: Sahih al-Bukhari streaming
- [ ] Slide 5: Course registration PDFs
- [ ] Slide 6: Donation/Umrah announcements
- [ ] Extract: Title, Description, Image URL, Action Link for each slide

### ✓ Scrolling Ticker Bar
- [ ] Sahih al-Bukhari Registration link
- [ ] Courses Registration Form link
- [ ] ATQ Details PDF
- [ ] TQ Details PDF
- [ ] FQ Details PDF
- [ ] Pashtu Flyer PDF
- [ ] Hajj 2026 PDF
- [ ] Additional rotating announcements

### ✓ Live Streaming Section
- [ ] Sahih Bukhari class info (time, platform)
- [ ] YouTube live link
- [ ] hadith.arrahmah.org portal link

### ✓ Live Platform Links
- [ ] Mixlr Live URL
- [ ] YouTube Live URL
- [ ] Facebook Live URL
- [ ] Quran 102 Mixlr URL

---

## 2. COURSE DATA CAPTURE

### ✓ Fast-Paced Courses (3 courses)

**For each of: ATQ, TQ, FQ**
- [ ] Course name
- [ ] Course year (2025)
- [ ] Registration status (Open/Closed)
- [ ] Details PDF URL
- [ ] Registration form URL
- [ ] Tafseer link
- [ ] Tajweed link
- [ ] Tests link

### ✓ Previous Year Courses (3 courses)

**Ahsan ul Bayan:**
- [ ] Course name
- [ ] Registration status (Closed)
- [ ] AB 2016 Tafseer link
- [ ] AB 2017 Tafseer link

**Al-Furqan:**
- [ ] Course name
- [ ] AF 2016 Tafseer link
- [ ] AF 2017 Tafseer link
- [ ] AF 2018 Tafseer link

**Ilm ul Yaqeen:**
- [ ] Course name
- [ ] IQ 2018 Tafseer link

### ✓ Steady-Paced Courses (2 courses)

**Quran 101:**
- [ ] Course name
- [ ] Registration status
- [ ] Details PDF
- [ ] Latest Lecture audio URL
- [ ] Tafseer link
- [ ] Tajweed link
- [ ] Tests link

**Quran 102:**
- [ ] Course name
- [ ] Registration status
- [ ] Details PDF
- [ ] Latest Lecture audio URL
- [ ] Tafseer link
- [ ] Tajweed link
- [ ] Tests link

### ✓ Language-Specific Courses (3 courses)

**English:**
- [ ] Course name
- [ ] Details PDF
- [ ] Registration form
- [ ] Latest Lecture URL
- [ ] Tafseer link
- [ ] Tests link

**Pashtu:**
- [ ] Course name
- [ ] Details PDF
- [ ] Google Form registration link
- [ ] Latest Lecture URL
- [ ] Tafseer link
- [ ] Tajweed link
- [ ] Tests link

**Farsi:**
- [ ] Course name
- [ ] Details image/flyer
- [ ] Google Form registration
- [ ] Lectures link
- [ ] Tests link

---

## 3. NAVIGATION MENU STRUCTURE

### ✓ Tafseer Menu (4 languages × ~10 courses each)

**Tafseer in Urdu:**
- [ ] Tafseer 2025 link
- [ ] Tafseer 2019 link
- [ ] Tafseer 2013 link
- [ ] Tafseer 2007 link
- [ ] Ahsan-ul-Bayan link
- [ ] Al-Furqan link
- [ ] Ilm-ul-Yaqeen link
- [ ] Quran 101 link
- [ ] Quran 102 link
- [ ] Al-Misbah link

**Tafseer in English:**
- [ ] English course link

**Tafseer in Pashto:**
- [ ] Pashto course link

**Tafseer in Farsi:**
- [ ] Farsi course link

### ✓ Tajweed Menu (11 courses)
- [ ] Adv Tajweed 2025
- [ ] Adv Taleem ul Quran
- [ ] Taleem ul Quran
- [ ] Fehm ul Quran
- [ ] Pashtu Fehm ul Quran
- [ ] Quran 101
- [ ] Quran 102
- [ ] English Qaida
- [ ] Noorani Qaida
- [ ] Juz 30 Hifz
- [ ] Taleem ul Quran 2013

### ✓ Subjects Menu (7 items)
- [ ] Sahih al-Bukhari
- [ ] Hadith (submenu items if any)
- [ ] Seearh (submenu items if any)
- [ ] Wirasat Course
- [ ] Seerah e Sahabah
- [ ] Adaab e Zindagi
- [ ] Aqeedah

### ✓ Lectures Menu (10 items)
- [ ] Tazkeer
- [ ] Weekly Gems
- [ ] Assorted Lectures
- [ ] Ramadan
- [ ] Hajj 2024
- [ ] Zilhajj Special (submenu)
- [ ] Special Series (submenu)
- [ ] Lectures on Namaz
- [ ] Lectures on Death
- [ ] Sunnah (submenu)

### ✓ Students' Corner Menu (8 items)
- [ ] Dawah Materials
- [ ] Weekly Update
- [ ] 2025 Tests
- [ ] FQ & TQ Tests
- [ ] ATQ Tests & Assignments
- [ ] Al-Fauz (submenu)
- [ ] Reading Material (submenu)
- [ ] Counseling Service

### ✓ Brothers' Wing Menu (5 items)
- [ ] Course Detail
- [ ] Reg. form
- [ ] Brothers' Testimonials
- [ ] Quran 102 Tafseer
- [ ] Brothers' Tajweed

---

## 4. TAFSEER PAGE DETAILED STRUCTURE

### Example: Tafseer 2025 - Juz 1

#### ✓ Page Metadata
- [ ] Course name: "Quran Tafseer 2025"
- [ ] Current Juz: 1
- [ ] Juz name (Arabic): الم
- [ ] Practice words PDFs (Part 1, Part 2)

#### ✓ Introduction Section
- [ ] Class Orientation
  - Date: 11/7/25
  - Audio URL
- [ ] Ilm ki ahmiat
  - Date: 11/14/25
  - Audio URL

#### ✓ Surah Al-Fatiha Section
- [ ] Surah name (Arabic): الفاتحۃ
- [ ] Surah Al-Fatiha ki Fazilat
  - Date: 11/14/25
  - Audio URL
- [ ] Taooz and Basmalah
  - Date: 11/21/25
  - Audio URL
  - Reference PDF URL
- [ ] Lesson 1: Ayah 1
  - Date: 11/26/25
  - Audio URL
- [ ] Lesson 2: Ayah 2-5
  - Date: 12/5/25
  - Root words PDF
  - Translation audio URL
  - Tafseer audio URLs (multiple)
- [ ] Lesson 3: Ayah 5-6
  - Date: 12/13/25
  - Root words PDF
  - Audio URLs (multiple)

#### ✓ Surah Al-Baqarah Section
- [ ] Surah name (Arabic): البقرۃ
- [ ] Lesson 4: Ayah 1-5
  - Date, Root words PDF, Audio URLs
- [ ] Lesson 5: Ayah 6-13
  - Date, Root words PDF, Audio URLs
- [ ] Lesson 6: Ayah 14-20
  - Date, Root words PDF, Audio URLs
- [ ] Lesson 7: Ayah 21-25
  - Date, Root words PDF, Audio URLs

#### ✓ Data Structure for Each Lesson
- [ ] Lesson number
- [ ] Lesson title/description
- [ ] Date (format: MM/DD/YY)
- [ ] Ayah range (if applicable)
- [ ] Root words PDF URL (if available)
- [ ] Translation audio URL (if available)
- [ ] Tafseer audio URLs (array - can be multiple)
- [ ] Reference material PDF URL (if available)
- [ ] Women's class audio (marked with 'wm')
- [ ] Part 1, Part 2 audio for longer lectures

---

## 5. TAJWEED PAGE STRUCTURE

### Example: Advance Tajweed 2025 - Foundation Level

#### ✓ Page Metadata
- [ ] Course: "Advance Tajweed Lessons"
- [ ] Level: "Foundation Level"
- [ ] Available levels: Foundation, Level 1, Level 2
- [ ] Qaida PDF URL

#### ✓ Lesson Structure (Each Lesson)
- [ ] Date/Class identifier
- [ ] Lecture video(s):
  - YouTube URL
  - Timestamp/duration info
- [ ] Practice surah(s):
  - Surah name
  - YouTube URL
  - Ayah range
- [ ] Practice video URL
- [ ] Additional PDFs (if available)

**Sample Entries to Capture:**
- [ ] Dec 15-21, 2025
- [ ] Dec 21-26, 2025 Class 1
- [ ] Dec 21-26, 2025 Class 2
- [ ] Dec 27-Jan 02, 2025 Class 1
- [ ] Dec 27-Jan 02, 2025 Class 2
- [ ] Jan 03-09, 2026 Class 1
- [ ] Jan 03-09, 2026 Class 2
- [ ] Jan 09-16, 2026
- [ ] Jan 17-24, 2026

---

## 6. SAHIH AL-BUKHARI STRUCTURE

#### ✓ Course Metadata
- [ ] Title: "Sahih al-Bukhari"
- [ ] Instructor: "by Ustadh Fuwad Bhutvi"

#### ✓ Lesson Data
For each lesson:
- [ ] Lesson number
- [ ] Lesson title (Arabic)
- [ ] YouTube video URL (or playlist)
- [ ] PDF URL
- [ ] Completion status (available/coming soon)

**Current Lessons:**
- [ ] Lesson 1: تعریفات وتعارف
- [ ] Lesson 2: (coming soon)
- [ ] Lesson 3: (coming soon)

---

## 7. WEEKLY GEMS PAGE

#### ✓ Data Points per Entry
- [ ] Date
- [ ] Topic/Title
- [ ] Audio URL
- [ ] Duration (if available)
- [ ] Additional metadata

Note: This page has extensive historical data - verify scraper handles pagination or long lists.

---

## 8. ABOUT PAGE CONTENT

#### ✓ Sections to Capture
- [ ] About ArRahmah text
- [ ] Teacher's Profile
  - Name: Najiha Hashmi
  - Arabic name: نجیحہ ہاشمی
  - Biography
  - Credentials
- [ ] Courses description
- [ ] Vision statement
- [ ] ArRahmah's Aim
- [ ] Why ArRahmah

---

## 9. MEDIA FILE VALIDATION

### ✓ Audio Files
Verify scraper handles these URL patterns:
- [ ] `https://arrahmah-media.org/taf2025/juz1/*.mp3`
- [ ] `https://arrahmah-media.org/qna2025/juz1/*.mp3`
- [ ] `https://arrahmah-media.org/latest_lects_n/*.mp3`
- [ ] `https://filedn.com/lYVXaQXjsnDpmndt09ArOXz/latest_lects_n/*.mp3`

### ✓ PDF Files
Verify scraper handles these patterns:
- [ ] Course details: `/*.pdf` (e.g., ATQ2025.pdf)
- [ ] Practice words: `/practise-words/{year}/juz{number}-part{number}.pdf`
- [ ] Root words: `/root_words/{year}/r{number}.pdf`
- [ ] Flyers: `/flyers/*.pdf`
- [ ] Tajweed materials: `/advtajweed2025/qaidah/*.pdf`

### ✓ Video Links
- [ ] YouTube playlist URLs
- [ ] YouTube live stream URLs
- [ ] YouTube individual video URLs
- [ ] Video timestamps/markers

### ✓ Image Files
- [ ] Course flyer images (.jpeg)
- [ ] Carousel images
- [ ] Gallery thumbnails

---

## 10. SPECIAL CONSIDERATIONS

### ✓ Multi-Language Support
- [ ] Arabic text preservation (Surah names, lesson titles)
- [ ] Urdu content
- [ ] English content
- [ ] Pashto references
- [ ] Farsi references

### ✓ Date Formats
Scraper should handle:
- [ ] MM/DD/YY format (11/7/25)
- [ ] Month DD, YYYY format (Dec 15-21, 2025)
- [ ] Date ranges (Dec 27-Jan 02, 2025)

### ✓ Dynamic Content
- [ ] Carousel rotation (6 slides)
- [ ] Ticker scrolling announcements
- [ ] Testimonial rotation
- [ ] Collapsible sidebar widgets

### ✓ External Links
- [ ] Google Forms
- [ ] YouTube platform
- [ ] External portal: hadith.arrahmah.org
- [ ] Social media links
- [ ] Mixlr streaming
- [ ] Facebook Live

### ✓ File Availability
- [ ] Handle "coming soon" content
- [ ] Handle missing resources gracefully
- [ ] Track registration status (open/closed)
- [ ] Verify PDF accessibility

---

## 11. DATA HIERARCHY VALIDATION

### ✓ Course Structure
```
Course
├── Course Name
├── Year
├── Language
├── Registration Status
├── Details PDF
├── Registration Form URL
├── Sections (Juz)
│   ├── Juz Number
│   ├── Juz Name (Arabic)
│   ├── Surahs
│   │   ├── Surah Name
│   │   ├── Lessons
│   │   │   ├── Lesson Number
│   │   │   ├── Date
│   │   │   ├── Ayah Range
│   │   │   ├── Root Words PDF
│   │   │   ├── Audio Files (array)
│   │   │   └── Reference PDFs
```

### ✓ Navigation Hierarchy
```
Main Menu
├── Tafseer
│   ├── Tafseer in Urdu
│   │   ├── Tafseer 2025
│   │   ├── Tafseer 2019
│   │   └── ... (10 items)
│   ├── Tafseer in English
│   ├── Tafseer in Pashto
│   └── Tafseer in Farsi
├── Tajweed (11 direct links)
├── Subjects (7 items, some with submenus)
├── Lectures (10 items, some with submenus)
├── Students' Corner (8 items, some with submenus)
└── Brothers' Wing (5 items)
```

---

## 12. CRITICAL VALIDATION POINTS

### ✓ Must Capture
1. [ ] ALL course names and years
2. [ ] ALL audio lecture URLs
3. [ ] ALL PDF resource URLs
4. [ ] Lesson dates and sequence
5. [ ] Ayah ranges for Quranic content
6. [ ] Registration status and form URLs
7. [ ] Multi-level menu structure
8. [ ] Language variants of same course
9. [ ] Arabic text (Surah names, lesson titles)
10. [ ] External resource links (YouTube, Google Forms)

### ✓ Data Integrity
1. [ ] Preserve lesson order/sequence
2. [ ] Maintain Juz → Surah → Lesson hierarchy
3. [ ] Keep multiple audio files per lesson linked
4. [ ] Associate PDFs with correct lessons
5. [ ] Track course progression (Juz 1 → 30)

### ✓ Completeness Check
1. [ ] Count of courses matches (15+ courses)
2. [ ] All 30 Juz available for main courses
3. [ ] All menu items captured
4. [ ] All resource types represented (audio, PDF, video)
5. [ ] Both active and archived courses included

---

## TESTING RECOMMENDATIONS

1. **Sample Validation:**
   - Pick 3 random courses
   - Verify all lessons captured
   - Check all media URLs accessible
   - Validate data structure matches schema

2. **Edge Cases:**
   - Lessons with multiple audio files
   - Coming soon/unavailable content
   - External links (Google Forms, YouTube)
   - Multi-language content

3. **Performance:**
   - Time to scrape entire site
   - Handle rate limiting
   - Retry failed requests

4. **Data Quality:**
   - No duplicate entries
   - All required fields populated
   - Correct data types
   - Valid URLs

---

**Checklist Version:** 1.0
**Last Updated:** January 19, 2026
**Based on:** Live website exploration and documentation
