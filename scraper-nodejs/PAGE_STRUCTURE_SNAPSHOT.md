# Arrahmah Tafseer 2025 - Page Structure Snapshot

## URL: https://arrahmah.org/tafseer2025/juz1.php

## Overall Page Organization

The page is organized into the following sections:

### 1. INTRODUCTION SECTION
The introduction contains general orientation and knowledge-related lessons:

#### Introduction Group Items:
1. **Class Orientation** (11/7/25)
   - Audio: speaker icon (mp3)
   
2. **Ilm ki ahmiat** (11/14/25)
   - Audio: speaker icon (mp3)

---

### 2. CONTENT SECTIONS BY JUZZ AND SURAH

The page then organizes content by Juzz and Surah combinations.

#### Example: Juz 1 Structure:

**Header: Juz 1 الم**
(Dark blue background: #0a2e4f, Gold text: #e7a834)

---

#### SURAH AL-FATIHA الفاتحۃ
(Light background: #ecece3, Dark text: #0a2e4f)

Surah-level items:
1. **Surah Al-Fatiha ki Fazilat** (11/14/25)
   - Audio: speaker icon

2. **Taooz and Basmalah** (11/21/25)
   - Audio: speaker icon
   - PDF: reference material

3. **Lesson 1: Surah Al-Fatiha Ayah 1** (11/26/25)
   - Audio: speaker icon

4. **Lesson 2: Surah Al-Fatiha Ayah 2-5** (12/5/25)
   - Root Words: PDF
   - Translation: Audio
   - Tafseer: Audio (Part 1 & Part 2)

5. **Lesson 3: Surah Al-Fatiha Ayah 5-6** (12/13/25)
   - Root Words: PDF
   - Translation: Audio
   - Tafseer: Audio (Part 1 & Part 2)

---

#### SURAH AL-BAQARAH البقرة
(Light background: #ecece3, Dark text: #0a2e4f)

Surah-level items:
1. **Lesson 4: Surah Al-Baqarah Ayah 1-5** (12/19/25)
   - Root Words: PDF
   - Translation: Audio
   - Tafseer: Audio (Part 1 & Part 2)

2. **Lesson 5: Surah Al-Baqarah Ayah 6-13** (1/2/26)
   - Root Words: PDF
   - Translation: Audio
   - Tafseer: Audio (Part 1 & Part 2)

3. **Lesson 6: Surah Al-Baqarah Ayah 14-20** (1/9/26)
   - Root Words: PDF
   - Translation: Audio
   - Tafseer: Audio (Part 1 & Part 2)

4. **Lesson 7: Surah Al-Baqarah Ayah 21-25** (1/16/26)
   - Root Words: PDF
   - Translation: Audio
   - Tafseer: Audio (Part 1 & Part 2)

---

## HTML Structure Pattern

### Item Container Structure:
```html
<div class="container my-3">
  <div class="row g-2 border border-1 p-2 mb-2 align-items-center">
    <!-- Title/Name Column (Left) -->
    <div class="col-12 col-md-5">
      [Lesson Title with Date]
    </div>
    
    <!-- Content Columns (Right) -->
    <div class="col-12 col-md-7">
      <div class="row g-2 text-center">
        <!-- Root Words Column -->
        <div class="col-3 col-md-3">
          [PDF or empty]
        </div>
        
        <!-- Translation Column -->
        <div class="col-3 col-md-3">
          [Audio or empty]
        </div>
        
        <!-- Tafseer Column -->
        <div class="col-3 col-md-3">
          [Audio (single or multiple) or empty]
        </div>
        
        <!-- Reference Material Column -->
        <div class="col-3 col-md-3">
          [PDF or empty]
        </div>
      </div>
    </div>
  </div>
</div>
```

### Group Headers:
**Juzz Header:**
```html
<div style="background-color: #0a2e4f; color: #e7a834">
  <strong>Juz 1 الم</strong>
</div>
```

**Surah Header:**
```html
<div style="background-color: #ecece3; color: #0a2e4f">
  <strong>Surah Al-Fatiha الفاتحۃ</strong>
</div>
```

---

## Data Organization Summary

### Hierarchy:
1. **Introduction Section** (General/Introductory content)
2. **Juzz Grouping** (e.g., Juz 1)
3. **Surah Grouping** (e.g., Surah Al-Fatiha, Surah Al-Baqarah)
4. **Lesson Items** (Individual lessons with media)

### Each Lesson Item Contains:
- **Title**: Lesson description with ayah range and date
- **Root Words**: PDF link or empty
- **Translation**: Audio link or empty
- **Tafseer**: Audio link(s) or empty (can have multiple parts)
- **Reference Material**: PDF link or empty

### Media Types:
- Audio files: `<a href="[mp3-url]"><img src="../images1/speaker_1.png" ...></a>`
- PDF files: `<a href="[pdf-url]"><img src="../images1/pdf.png" ...></a>`

---

## Key Observations:

1. **Introduction items** are simpler - usually just title and audio
2. **Lesson items** follow a 4-column pattern for different content types
3. **Headers use color coding**:
   - Dark blue with gold text for Juzz headers
   - Light tan with dark text for Surah headers
4. **Responsive design**: Mobile shows abbreviated column headers
5. **Multi-part content**: Some lessons have multiple audio files (Part 1, Part 2)
6. **Date tracking**: Each item includes a date (format: MM/DD/YY)
