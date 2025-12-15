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

/** Course content */
export interface CourseContent {
  id: string;
  title: string;
  surahs: Surah[];
}

/** Media content (placeholder for now) */
export interface MediaContent {
  // TODO: Define based on actual media content structure
  [key: string]: any;
}

/** Navigation drawer item */
export interface DrawerItem {
  title: string;
  link: Item;
  media: MediaContent | null;
  content: CourseContent | null;
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

/** Quran course registration */
export interface QuranCourseRegistration {
  item?: Item;
}

/** Quran course detail */
export interface QuranCourseDetail {
  detailMarkdown?: string;
}

/** Quran course tafseer */
export interface QuranCourseTafseer {
  lessons: QuranCourseLesson[];
}

/** Quran course tajweed */
export interface QuranCourseTajweed {
  lessons: QuranCourseLesson[];
}

/** Quran course lectures */
export interface QuranCourseLectures {
  lessons: QuranCourseLesson[];
}

/** Quran course tests */
export interface QuranCourseTests {
  lessons: QuranCourseLesson[];
}

/** Quran course other materials */
export interface QuranCourseOther {
  lessons: QuranCourseLesson[];
}

/** Complete Quran course */
export interface QuranCourse {
  title: string;
  imageUrl: string;
  registration?: QuranCourseRegistration;
  detail?: QuranCourseDetail;
  tafseer?: QuranCourseTafseer;
  tajweed?: QuranCourseTajweed;
  lectures?: QuranCourseLectures;
  tests?: QuranCourseTests;
  other?: QuranCourseOther;
}

/** Group of Quran courses */
export interface QuranCourseGroup {
  title: string;
  imageUrl: string;
  courses: QuranCourse[];
}

/** Dua (prayer) */
export interface Dua {
  id: string;
  title?: string | null;
  titleUrdu?: string | null;
  dua: string; // Arabic text (required)
  duaEnglish?: string | null;
  duaUrdu?: string | null;
  notes?: string | null;
}

/** Dua category */
export interface DuaCategory {
  title: string;
  titleUrdu?: string;
  imageUrl?: string;
  notes?: string | null;
  duas?: Dua[];
  categories?: DuaCategory[];
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

/** Metadata about scraping run */
export interface RunMetadata {
  timestamp: string;
  version: string;
}

/** Complete scraped data output */
export interface ScrapedData {
  data: AppData;
  metadata: RunMetadata;
}
