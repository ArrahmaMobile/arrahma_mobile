import 'package:arrahma_shared/shared.dart';
import 'package:html/dom.dart';
import 'package:recase/recase.dart';
import 'package:scraper/src/scrapers/media_scraper.dart';
import 'package:scraper/src/scrapers/quran_course_detail_scraper.dart';
import 'package:scraper/src/scrapers/quran_course_juz_template_scraper.dart';

import '../scraper_base.dart';
import '../utils.dart';
import 'quran_course_registration_scraper.dart';
import 'quran_course_surah_template_scraper.dart';

class QuranCourseScraper extends ScraperBase<List<QuranCourse>> {
  const QuranCourseScraper(IScraper scraper) : super(scraper);

  @override
  Future<List<QuranCourse>> scrape() async {
    final doc = await scraper.navigateTo('');
    final rootUrl = scraper.baseUrl;
    if (doc == null) return [];
    final courseList = doc.querySelectorAll('.column5 .box2');
    final quranCourseList = <QuranCourse>[];
    for (final course in courseList) {
      final quranCourse = await scrapeCourse(rootUrl, course);
      if (quranCourse != null) {
        quranCourseList.add(quranCourse);
      }
    }

    quranCourseList.add(QuranCourse(
      title: 'Weekly Reminder',
      imageUrl: 'assets/images/weekly_dua_sunnat.png',
      lectures: await scrapeContent('https://arrahma.org/sunnah/sunnah.php'),
    ));
    return quranCourseList;
  }

  Future<QuranCourse?> scrapeCourse(String rootUrl, Element course) async {
    final title = course.querySelector('.box_h')?.text.cleanedText;
    final subStrIndex = title != null ? title.indexOf('(') - 1 : -1;
    final normalizedTitle =
        subStrIndex >= 0 ? title?.substring(0, subStrIndex) : title;
    final imageUrl = course
        .querySelector('img')
        ?.attributes['src']
        ?.toAbsolute(rootUrl)
        .removeQueryString();

    final items = course
        .querySelectorAll('a')
        .where((e) => e.text.trim().isNotEmpty && e.attributes['href'] != null)
        .map(
          (i) => CourseLinkItem(
            name: i.text.cleanedText.titleCase,
            links: [i.attributes['href']!.toAbsolute(rootUrl)],
          ),
        )
        .toList();

    Future<MediaItem?>? courseDetails;
    Future<MediaItem?>? registration;
    Future<QuranCourseContent?>? tafseer;
    Future<QuranCourseContent?>? tajweed;
    Future<QuranCourseContent?>? lectures;
    Future<MediaContent?>? tests;
    var otherContents = <MediaContent>[];

    items.forEach((item) {
      if (item.links.isEmpty) return;
      switch (item.name.toUpperCase()) {
        case 'COURSE DETAIL':
        case 'PROGRAM DETAIL':
          courseDetails =
              QuranCourseDetailScraper(scraper, item.links.first).scrape();
          break;
        case 'REGISTRATION':
          registration =
              QuranCourseRegistrationScraper(scraper, item.links.first)
                  .scrape();
          break;
        case 'TAFSEER LINK':
          tafseer =
              QuranCourseJuzTemplateScraper(scraper, item.links.first).scrape();
          break;
        case 'TAJWEED LINK':
          tajweed = QuranCourseSurahTemplateScraper(scraper, item.links.first)
              .scrape();
          break;
        case 'LECTURES':
          lectures = scrapeContent(item.links.first);
          break;
        case 'TESTS':
          tests = MediaScraper(scraper, item.links.first).scrape();
          break;
        default:
          otherContents.add(
            MediaContent(
              title: item.name
                  .replaceAll('Course', '')
                  .replaceAll('Link', '')
                  .trim(),
              items: [MediaItem(item: Utils.getItemByUrl(item.links.first))],
            ),
          );
          break;
      }
    });

    final courseDetailsVal = await courseDetails;
    final registrationVal = await registration;
    return QuranCourse(
      title: normalizedTitle ?? 'No Title',
      imageUrl: imageUrl ?? '',
      courseDetails: courseDetailsVal != null
          ? MediaContent(title: 'Details', items: [courseDetailsVal])
          : null,
      registration: registrationVal != null
          ? MediaContent(title: 'Registration', items: [registrationVal])
          : null,
      tafseer: await tafseer,
      tajweed: await tajweed,
      lectures: await lectures,
      tests: await tests,
      otherContent: otherContents.length == 1
          ? otherContents.first
          : otherContents.isNotEmpty
              ? MediaContent(
                  title: 'Other',
                  items: otherContents
                      .where((c) => c.items != null)
                      .expand((c) => c.items!)
                      .toList(),
                )
              : null,
    );
  }

  Future<QuranCourseContent?> scrapeContent(String url) async {
    final doc = await scraper.navigateTo(url);
    final isSurahPage = doc?.querySelector(r'[id$="ayahc"]') != null;
    return await (isSurahPage
        ? QuranCourseSurahTemplateScraper(scraper, url).scrape()
        : QuranCourseJuzTemplateScraper(scraper, url).scrape());
  }
}
