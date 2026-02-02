/**
 * Data models for Arrahmah scraper
 * These models match the structure expected by the mobile app
 */

/** Content types for items */
export enum ItemType {
  WebPage = 'WebPage',
  Pdf = 'Pdf',
  Audio = 'Audio',
  Video = 'Video',
  Image = 'Image',
}

/** Broadcast platforms */
export enum BroadcastType {
  YouTube = 'YouTube',
  Facebook = 'Facebook',
  Mixlr = 'Mixlr',
  Other = 'Other',
}

/** Generic item with URL and content type - matches API format */
export interface Item {
  isDirectSource: boolean;
  isExternal: boolean;
  type: ItemType;
  data: string; // The URL
  imageUrl: string | null;
  label?: string | null; // Optional descriptive label (e.g., "1st 10 min", "Practice")
}

/** Quick link on homepage */
export interface QuickLink {
  title: string;
  link: Item;
}

/** Banner image with link */
export interface HeadingBanner {
  imageUrl: string;
  item: Item;
  heading?: string;
  title?: string;
}

/** Broadcast item (YouTube, Facebook, etc.) */
export interface BroadcastItem {
  type: BroadcastType;
  item: Item;
  imageUrl: string;
}

/** Social media link */
export interface SocialMediaItem {
  item: Item;
  imageUrl: string;
}

/** Item group containing items */
export interface ItemGroup {
  items: Item[];
}

/** Lesson within a Surah */
export interface Lesson {
  title: string;
  lessonNum: string | null;
  ayahNum: string | null;
  uploadDate: string | null;
  itemGroups: ItemGroup[];
}

/** Group name */
export interface Group {
  name: string;
}

/** Surah with lessons */
export interface Surah {
  name: string;
  arabicName: string | null;
  description: string | null;
  groups: Group[];
  lessons: Lesson[];
}

/** Media item - matches Dart MediaItem */
export interface MediaItem {
  item?: Item | null;
  imageUrl?: string | null;
  title?: string | null;
}

/** Media content - matches Dart MediaContent (moved here before DrawerItem) */
export interface MediaContent {
  title?: string | null;
  description?: string | null;
  items?: MediaItem[] | null;
}

/** Quran course content structure - matches Dart QuranCourseContent (moved here before DrawerItem) */
export interface QuranCourseContent {
  id: string;
  title?: string | null;
  surahs: Surah[];
}

/** Navigation drawer item - matches Dart DrawerItem */
export interface DrawerItem {
  title: string;
  link?: Item | null; // Changed to optional to match Dart
  media?: MediaContent | null;
  content?: QuranCourseContent | null; // Changed from CourseContent to QuranCourseContent
  children?: DrawerItem[];
}

/** Quran course lesson item */
export interface QuranCourseLessonItem {
  title: string;
  items: Item[];
}

/** Quran course lesson group */
export interface QuranCourseLessonGroup {
  title: string;
  items: QuranCourseLessonItem[];
}

/** Quran course lesson */
export interface QuranCourseLesson {
  title: string;
  groups: QuranCourseLessonGroup[];
}

/** Course button/action types */
export type CourseButtonType = 'details' | 'register' | 'join' | 'link';

/** Generic course button/action */
export interface CourseButton {
  label: string; // Button text (e.g., "Details", "Join Now", "Reg.closed")
  type: CourseButtonType;
  isActive: boolean; // true if clickable/open, false if closed/disabled
  url: string;
}

/** Generic course section (Tafseer, Tajweed, Tests, etc.) */
export interface CourseSection {
  label: string; // Section label (e.g., "Tafseer", "Tajweed", "Tests")
  icon?: string | null; // Optional icon identifier
  mediaContent?: MediaContent | null; // For simple link lists (Tafseer PDFs, Tests, etc.)
  courseContent?: QuranCourseContent | null; // For full Quran course content with surahs
}

/** Complete Quran course - Generic V2 structure */
export interface QuranCourse {
  title: string;
  imageUrl: string;
  buttons: CourseButton[]; // All action buttons (Details, Register, etc.)
  sections: CourseSection[]; // All content sections (Tafseer, Tajweed, Tests, etc.)
}

/** Group of Quran courses */
export interface QuranCourseGroup {
  title: string;
  imageUrl: string;
  courses: QuranCourse[];
}

/** Dua (prayer) - matches Dart Dua model */
export interface Dua {
  id: string;
  title?: string | null;
  titleUrdu?: string | null;
  dua: string; // Arabic text (required)
  duaEnglish?: string | null;
  duaUrdu?: string | null;
  notes?: string | null;
}

/** Dua category - matches Dart DuaCategory model */
export interface DuaCategory {
  title: string;
  titleUrdu: string; // Required in Dart, not optional
  imageUrl?: string | null;
  notes?: string | null;
  duas: Dua[]; // Required in Dart, not optional
  categories?: DuaCategory[] | null;
}

/** Main application data */
export interface AppData {
  logoUrl: string;
  quickLinks: QuickLink[];
  banners: HeadingBanner[];
  broadcastItems: BroadcastItem[];
  socialMediaItems: SocialMediaItem[];
  drawerItems: DrawerItem[];
  aboutUsMarkdown: string;
  courses: QuranCourse[];
  otherCourseGroups: QuranCourseGroup[];
  duaCategories: DuaCategory[];
}

/** Metadata about scraping run - matches Dart RunMetadata model */
export interface RunMetadata {
  lastUpdate: string; // ISO timestamp
  updateFrequency?: number; // Duration in milliseconds (optional)
}

/** Complete scraped data output - matches Dart ScrapedData model */
export interface ScrapedData {
  appData: AppData; // Changed from 'data' to 'appData' to match Dart
  runMetadata: RunMetadata; // Changed from 'metadata' to 'runMetadata' to match Dart
}
