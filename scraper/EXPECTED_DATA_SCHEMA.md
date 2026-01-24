# Expected Data Schema for Arrahmah.org Scraper

This document defines the expected data structure that the scraper should output based on the website analysis.

---

## 1. QuranCourse Model

```typescript
interface QuranCourse {
  id: string;                    // Unique identifier
  name: string;                  // e.g., "Tafseer 2025", "Quran 102"
  year: number;                  // e.g., 2025
  language: string;              // "urdu", "english", "pashtu", "farsi"
  courseType: string;            // "fast-paced", "steady-paced", "archived", "language-specific"
  registrationStatus: string;    // "open", "closed"
  instructor?: string;           // e.g., "Najiha Hashmi"

  // Resource URLs
  detailsPdfUrl?: string;        // Course details PDF
  registrationFormUrl?: string;  // Registration form URL
  tafseerUrl?: string;          // Link to tafseer page
  tajweedUrl?: string;          // Link to tajweed page
  testsUrl?: string;            // Link to tests page
  latestLectureUrl?: string;    // Latest lecture audio URL

  // Course structure
  juzList: Juz[];               // Array of 30 Juz (for Quran courses)

  // Metadata
  description?: string;
  featured: boolean;            // Is it on homepage?
  displayOrder: number;         // Order on homepage
  createdAt: Date;
  updatedAt: Date;
}
```

---

## 2. Juz Model

```typescript
interface Juz {
  id: string;
  courseId: string;              // Foreign key to QuranCourse
  juzNumber: number;             // 1-30
  juzName: string;               // Arabic name, e.g., "الم"
  juzNameTransliteration?: string;

  // Resources
  practiceWordsPdf1Url?: string;  // Practice words part 1
  practiceWordsPdf2Url?: string;  // Practice words part 2

  // Content sections
  introductionLessons: Lesson[];  // Introduction/orientation lessons
  surahs: Surah[];               // Surahs in this Juz

  displayOrder: number;
  createdAt: Date;
  updatedAt: Date;
}
```

---

## 3. Surah Model

```typescript
interface Surah {
  id: string;
  juzId: string;                 // Foreign key to Juz
  surahNumber: number;           // 1-114
  surahName: string;             // Arabic name, e.g., "الفاتحۃ"
  surahNameTransliteration: string; // e.g., "Al-Fatiha"
  surahNameEnglish?: string;     // e.g., "The Opening"

  // Surah-level content
  fazilatlLesson?: Lesson;       // Introduction/virtues lesson

  // Lessons in this Surah
  lessons: Lesson[];

  displayOrder: number;
  createdAt: Date;
  updatedAt: Date;
}
```

---

## 4. Lesson Model

```typescript
interface Lesson {
  id: string;
  surahId?: string;              // Foreign key (optional for intro lessons)
  juzId?: string;                // Direct link to Juz for intro lessons

  lessonNumber?: number;
  title: string;                 // e.g., "Lesson 1: Surah Al-Fatiha Ayah 1"
  titleArabic?: string;          // Arabic title if available
  ayahRange?: string;            // e.g., "1-5", "21-25"
  ayahStart?: number;
  ayahEnd?: number;

  lessonDate: Date;              // Date lesson was published
  lessonType: string;            // "introduction", "fazilat", "regular", "taooz", "basmalah"

  // Audio resources (can have multiple)
  audioFiles: AudioFile[];

  // PDF resources
  rootWordsPdfUrl?: string;
  referenceMaterialPdfUrl?: string;
  additionalPdfs?: string[];

  // Metadata
  duration?: number;             // In seconds if available
  transcript?: string;
  notes?: string;

  displayOrder: number;
  createdAt: Date;
  updatedAt: Date;
}
```

---

## 5. AudioFile Model

```typescript
interface AudioFile {
  id: string;
  lessonId: string;              // Foreign key to Lesson

  url: string;                   // Full audio URL
  fileType: string;              // "translation", "tafseer", "qna", "women-class"
  partNumber?: number;           // 1, 2 for multi-part lectures

  // Audio metadata
  duration?: number;             // In seconds
  fileSize?: number;             // In bytes
  format?: string;               // "mp3", "m4a"

  // Hosting info
  hostingDomain: string;         // "arrahmah-media.org", "filedn.com"
  backupUrl?: string;            // Alternative URL if available

  displayOrder: number;
  createdAt: Date;
  updatedAt: Date;
}
```

---

## 6. TajweedCourse Model

```typescript
interface TajweedCourse {
  id: string;
  name: string;                  // e.g., "Adv Tajweed 2025"
  year?: number;
  courseType: string;            // "advance", "regular", "qaida"

  // Course resources
  qaidaPdfUrl?: string;

  // Levels (for Advanced courses)
  levels: TajweedLevel[];

  // For simple courses without levels
  lessons?: TajweedLesson[];

  createdAt: Date;
  updatedAt: Date;
}
```

---

## 7. TajweedLevel Model

```typescript
interface TajweedLevel {
  id: string;
  courseId: string;              // Foreign key to TajweedCourse
  levelName: string;             // "Foundation Level", "Level 1", "Level 2"
  levelNumber: number;           // 0, 1, 2

  lessons: TajweedLesson[];

  displayOrder: number;
  createdAt: Date;
  updatedAt: Date;
}
```

---

## 8. TajweedLesson Model

```typescript
interface TajweedLesson {
  id: string;
  levelId?: string;              // Foreign key (optional)
  courseId?: string;             // Direct link if no levels

  dateRange: string;             // e.g., "Dec 15-21, 2025"
  classNumber?: number;          // Class 1, Class 2 within a date range

  // Lecture resources
  lectureVideos: VideoResource[];

  // Practice resources
  practiceSurahs: VideoResource[];
  practiceVideos: VideoResource[];

  // Additional resources
  lessonPdfUrl?: string;

  displayOrder: number;
  createdAt: Date;
  updatedAt: Date;
}
```

---

## 9. VideoResource Model

```typescript
interface VideoResource {
  id: string;

  url: string;                   // YouTube URL
  platform: string;              // "youtube", "vimeo"
  videoId?: string;              // Extracted video ID

  title?: string;
  description?: string;
  surahName?: string;            // e.g., "Bayyinah", "Zilzaal"
  ayahRange?: string;            // e.g., "1-3"

  // Timing information
  startTime?: string;            // e.g., "1st 10 min", "12-23 min"
  duration?: number;             // In seconds

  resourceType: string;          // "lecture", "practice-surah", "practice-exercise"

  displayOrder: number;
  createdAt: Date;
  updatedAt: Date;
}
```

---

## 10. Subject Model

```typescript
interface Subject {
  id: string;
  name: string;                  // e.g., "Sahih al-Bukhari"
  nameArabic?: string;
  category: string;              // "hadith", "seerah", "aqeedah", "fiqh"

  instructor?: string;           // e.g., "Ustadh Fuwad Bhutvi"

  lessons: SubjectLesson[];

  description?: string;
  detailsPdfUrl?: string;
  registrationUrl?: string;

  createdAt: Date;
  updatedAt: Date;
}
```

---

## 11. SubjectLesson Model

```typescript
interface SubjectLesson {
  id: string;
  subjectId: string;             // Foreign key to Subject

  lessonNumber: number;
  title: string;
  titleArabic?: string;

  // Resources
  videoUrl?: string;             // YouTube or other
  pdfUrl?: string;
  audioUrl?: string;

  // Status
  available: boolean;            // false for "coming soon"

  displayOrder: number;
  createdAt: Date;
  updatedAt: Date;
}
```

---

## 12. Lecture Model (for Weekly Gems, Assorted Lectures, etc.)

```typescript
interface Lecture {
  id: string;
  category: string;              // "weekly-gems", "assorted", "ramadan", "hajj", "namaz", "death"

  title: string;
  titleArabic?: string;
  date?: Date;

  // Resources
  audioUrl?: string;
  videoUrl?: string;
  pdfUrl?: string;

  // Metadata
  duration?: number;
  description?: string;
  tags?: string[];

  displayOrder: number;
  createdAt: Date;
  updatedAt: Date;
}
```

---

## 13. NavigationMenu Model

```typescript
interface NavigationMenu {
  id: string;
  name: string;                  // "Tafseer", "Tajweed", etc.
  slug: string;                  // "tafseer", "tajweed"

  menuItems: NavigationMenuItem[];

  displayOrder: number;
  createdAt: Date;
  updatedAt: Date;
}

interface NavigationMenuItem {
  id: string;
  menuId: string;                // Foreign key
  parentId?: string;             // For nested items

  label: string;
  url: string;

  // Sub-items (recursive)
  children?: NavigationMenuItem[];

  displayOrder: number;
  createdAt: Date;
  updatedAt: Date;
}
```

---

## 14. Announcement Model (Carousel/Ticker)

```typescript
interface Announcement {
  id: string;
  type: string;                  // "carousel", "ticker"

  title: string;
  description?: string;

  // Visual
  imageUrl?: string;

  // Action
  actionText?: string;           // "Click for Details", "Join Now"
  actionUrl?: string;

  // Display settings
  active: boolean;
  startDate?: Date;
  endDate?: Date;

  displayOrder: number;
  createdAt: Date;
  updatedAt: Date;
}
```

---

## 15. LiveStream Model

```typescript
interface LiveStream {
  id: string;
  platform: string;              // "youtube", "mixlr", "facebook"
  title: string;

  streamUrl: string;

  schedule?: string;             // e.g., "11 AM EST Every Tues"
  description?: string;

  active: boolean;

  displayOrder: number;
  createdAt: Date;
  updatedAt: Date;
}
```

---

## 16. Resource Model (Generic)

```typescript
interface Resource {
  id: string;
  type: string;                  // "pdf", "audio", "video", "image"
  category: string;              // "course-detail", "practice-words", "root-words", "flyer"

  url: string;
  backupUrl?: string;

  title?: string;
  description?: string;

  // File metadata
  fileSize?: number;
  format?: string;

  // Associated entity
  relatedEntityType?: string;    // "course", "lesson", "announcement"
  relatedEntityId?: string;

  createdAt: Date;
  updatedAt: Date;
}
```

---

## 17. RegistrationForm Model

```typescript
interface RegistrationForm {
  id: string;
  courseId?: string;             // Foreign key if course-specific

  formType: string;              // "internal", "google-form", "external-portal"
  formUrl: string;

  title: string;
  status: string;                // "open", "closed"

  openDate?: Date;
  closeDate?: Date;

  createdAt: Date;
  updatedAt: Date;
}
```

---

## 18. Testimonial Model

```typescript
interface Testimonial {
  id: string;
  studentName: string;
  studentNameArabic?: string;

  courseName?: string;           // e.g., "Fehmul Quran"

  testimonialText: string;
  fullTestimonialUrl?: string;   // Link to full testimonial page

  photoUrl?: string;

  featured: boolean;             // Display on homepage?
  displayOrder: number;

  createdAt: Date;
  updatedAt: Date;
}
```

---

## Complete Data Hierarchy Example

Here's how a complete Tafseer 2025 course would be structured:

```typescript
{
  quranCourse: {
    id: "tafseer-2025",
    name: "Tafseer 2025",
    year: 2025,
    language: "urdu",
    courseType: "fast-paced",
    registrationStatus: "open",
    detailsPdfUrl: "https://www.arrahmah.org/ATQ2025.pdf",
    registrationFormUrl: "https://arrahmah.org/q2025/form.php",
    tafseerUrl: "https://arrahmah.org/tafseer2025/juz1.php",
    juzList: [
      {
        id: "juz-1",
        juzNumber: 1,
        juzName: "الم",
        practiceWordsPdf1Url: "https://www.arrahmah.org/practise-words/2019/juz1-part1.pdf",
        practiceWordsPdf2Url: "https://www.arrahmah.org/practise-words/2019/juz1-part2.pdf",
        introductionLessons: [
          {
            id: "intro-1",
            title: "Class Orientation",
            lessonDate: "2025-11-07",
            lessonType: "introduction",
            audioFiles: [
              {
                url: "https://arrahmah-media.org/tafseer2025/nov7-25-class-orientation.mp3",
                fileType: "tafseer"
              }
            ]
          }
        ],
        surahs: [
          {
            id: "surah-1",
            surahNumber: 1,
            surahName: "الفاتحۃ",
            surahNameTransliteration: "Al-Fatiha",
            fazilatlLesson: {
              id: "fatiha-fazilat",
              title: "Surah Al-Fatiha ki Fazilat",
              lessonDate: "2025-11-14",
              lessonType: "fazilat",
              audioFiles: [
                {
                  url: "https://arrahmah-media.org/tafseer2025/juz1/fatiha_fazilat.mp3",
                  fileType: "tafseer"
                }
              ]
            },
            lessons: [
              {
                id: "lesson-1",
                lessonNumber: 1,
                title: "Lesson 1: Surah Al-Fatiha Ayah 1",
                ayahRange: "1",
                ayahStart: 1,
                ayahEnd: 1,
                lessonDate: "2025-11-26",
                lessonType: "regular",
                audioFiles: [
                  {
                    url: "https://arrahmah-media.org/taf2025/juz1/nov26-25-fatiha_1.mp3",
                    fileType: "tafseer"
                  }
                ]
              },
              {
                id: "lesson-2",
                lessonNumber: 2,
                title: "Lesson 2: Surah Al-Fatiha Ayah 2-5",
                ayahRange: "2-5",
                ayahStart: 2,
                ayahEnd: 5,
                lessonDate: "2025-12-05",
                lessonType: "regular",
                rootWordsPdfUrl: "../root_words/2025/r1.pdf",
                audioFiles: [
                  {
                    url: "https://arrahmah-media.org/tafseer2025/juz1/fatiha2-5(wm).mp3",
                    fileType: "women-class"
                  },
                  {
                    url: "https://arrahmah-media.org/tafseer2025/juz1/fatiha2-5part1(t).mp3",
                    fileType: "tafseer",
                    partNumber: 1
                  },
                  {
                    url: "https://arrahmah-media.org/tafseer2025/juz1/fatiha_2-5part2(t).mp3",
                    fileType: "tafseer",
                    partNumber: 2
                  }
                ]
              }
            ]
          },
          {
            id: "surah-2",
            surahNumber: 2,
            surahName: "البقرۃ",
            surahNameTransliteration: "Al-Baqarah",
            lessons: [
              // ... more lessons
            ]
          }
        ]
      }
      // ... Juz 2-30
    ]
  }
}
```

---

## Validation Rules

### Required Fields by Entity:

**QuranCourse:**
- ✓ name
- ✓ year
- ✓ language
- ✓ courseType
- ✓ registrationStatus

**Juz:**
- ✓ juzNumber
- ✓ juzName

**Surah:**
- ✓ surahNumber
- ✓ surahName
- ✓ surahNameTransliteration

**Lesson:**
- ✓ title
- ✓ lessonDate
- ✓ lessonType
- ✓ At least one audioFile or videoResource

**AudioFile:**
- ✓ url
- ✓ fileType

**TajweedCourse:**
- ✓ name
- ✓ courseType

**Subject:**
- ✓ name
- ✓ category

### Data Integrity Checks:

1. **Lesson Ordering:**
   - Lessons should be sequential by lessonNumber
   - Dates should be chronological

2. **Ayah Ranges:**
   - ayahStart <= ayahEnd
   - Ranges should be valid for the surah

3. **URLs:**
   - All URLs should be valid and reachable
   - Audio/PDF URLs should return appropriate content-type

4. **Relationships:**
   - All foreign keys should reference existing entities
   - Parent-child relationships should be valid

---

**Schema Version:** 1.0
**Last Updated:** January 19, 2026
**Based on:** arrahmah.org website analysis
