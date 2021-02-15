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
    final rootUrl = scraper.currentUrl;
    if (doc == null) return [];
    final courseList = doc.querySelectorAll('.column5 .box2');
    final quranCourseList = <QuranCourse>[];
    for (final course in courseList) {
      quranCourseList.add(await scrapeCourse(rootUrl, course));
    }
    quranCourseList.add(QuranCourse(
      title: 'Sunnah, Dua, and Zikr',
      imageUrl: 'assets/images/weekly_dua_sunnat.png',
      lectures: await scrapeContent('https://arrahma.org/sunnah/sunnah.php'),
    ));
    return quranCourseList;
  }

  Future<QuranCourse> scrapeCourse(String rootUrl, Element course) async {
    final title = course.querySelector('.box_h').text.cleanedText;
    final subStrIndex = title.indexOf('(') - 1;
    final normalizedTitle =
        subStrIndex >= 0 ? title.substring(0, subStrIndex) : title;
    final imageUrl = course
        .querySelector('img')
        .attributes['src']
        .toAbsolute(rootUrl)
        .removeQueryString();

    final items = course
        .querySelectorAll('a')
        .where((e) => e.text?.trim()?.isNotEmpty ?? false)
        .map(
          (i) => CourseLinkItem(
            name: i.text.cleanedText.titleCase,
            links: [i.attributes['href'].toAbsolute(scraper.currentUrl)],
          ),
        )
        .toList();
    final itemLinkMap =
        items.fold<Map<String, String>>(<String, String>{}, (map, item) {
      map[item.name.toUpperCase()] = item.links.first;
      return map;
    });

    final courseDetailLink =
        itemLinkMap['COURSE DETAIL'] ?? itemLinkMap['PROGRAM DETAIL'];
    final courseDetails = courseDetailLink != null
        ? QuranCourseDetailScraper(scraper, courseDetailLink).scrape()
        : null;

    final registrationLink = itemLinkMap['REGISTRATION'];
    final registration = registrationLink != null
        ? QuranCourseRegistrationScraper(scraper, registrationLink).scrape()
        : null;

    final tafseerLink = itemLinkMap['TAFSEER LINK'];
    final tafseer = tafseerLink != null
        ? QuranCourseJuzTemplateScraper(scraper, tafseerLink).scrape()
        : null;

    final tajweedLink = itemLinkMap['TAJWEED LINK'];
    final tajweed = tajweedLink != null
        ? QuranCourseSurahTemplateScraper(scraper, tajweedLink).scrape()
        : null;

    final lecutresLink = itemLinkMap['LECTURES'];
    final lectures = lecutresLink != null ? scrapeContent(lecutresLink) : null;

    final testsLink = itemLinkMap['TESTS'];
    final tests =
        testsLink != null ? MediaScraper(scraper, testsLink).scrape() : null;

    return QuranCourse(
      title: normalizedTitle,
      imageUrl: imageUrl,
      courseDetails: await courseDetails,
      registration: await registration,
      tafseer: await tafseer,
      tajweed: await tajweed,
      lectures: await lectures,
      tests: await tests,
    );
  }

  Future<QuranCourseContent> scrapeContent(String url) async {
    final doc = await scraper.navigateTo(url);
    final isSurahPage = doc?.querySelector(r'[id$="ayahc"]') != null;
    return await (isSurahPage
        ? QuranCourseSurahTemplateScraper(scraper, url).scrape()
        : QuranCourseJuzTemplateScraper(scraper, url).scrape());
  }
}
