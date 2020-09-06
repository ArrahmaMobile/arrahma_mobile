import 'package:arrahma_shared/shared.dart';
import 'package:recase/recase.dart';
import 'package:scraper/src/scrapers/quran_course_detail_scraper.dart';
import 'package:scraper/src/scrapers/quran_course_juz_template_scraper.dart';

import '../scraper_base.dart';
import '../utils.dart';
import 'quran_course_registration_scraper.dart';
import 'quran_course_surah_template_scraper.dart';

class QuranCourseScraper implements ScraperBase<List<QuranCourse>> {
  @override
  Future<List<QuranCourse>> scrape(IScraper scraper) async {
    final doc = await scraper.navigateTo('');
    if (doc == null) return [];
    final courseList = doc.querySelectorAll('.column5 .box2');
    return Future.wait(courseList.map((course) async {
      final title = course.querySelector('.box_h').text.cleanedText.titleCase;
      final imageUrl = course
          .querySelector('img')
          .attributes['src']
          .toAbsolute(scraper.currentUrl);

      final items = course
          .querySelectorAll('a')
          .where((e) => e.text?.trim()?.isNotEmpty ?? false)
          .map(
            (i) => CourseLinkItem(
              name: i.text.cleanedText.titleCase,
              link: i.attributes['href'].toAbsolute(scraper.currentUrl),
            ),
          )
          .toList();
      final itemLinkMap =
          items.fold<Map<String, String>>(<String, String>{}, (map, item) {
        map[item.name.toUpperCase()] = item.link;
        return map;
      });

      final courseDetailLink =
          itemLinkMap['COURSE DETAIL'] ?? itemLinkMap['PROGRAM DETAIL'];
      final courseDetails = courseDetailLink != null
          ? QuranCourseDetailScraper(courseDetailLink).scrape(scraper)
          : null;

      final registrationLink = itemLinkMap['REGISTRATION'];
      final registration = registrationLink != null
          ? QuranCourseRegistrationScraper(registrationLink).scrape(scraper)
          : null;

      final tafseerLink = itemLinkMap['TAFSEER LINK'];
      final tafseer = tafseerLink != null
          ? QuranCourseJuzTemplateScraper(tafseerLink).scrape(scraper)
          : null;

      final tajweedLink = itemLinkMap['TAJWEED LINK'];
      final tajweed = tajweedLink != null
          ? QuranCourseSurahTemplateScraper(tajweedLink).scrape(scraper)
          : null;

      return QuranCourse(
        title: title,
        imageUrl: imageUrl,
        courseDetails: await courseDetails,
        registration: await registration,
        tafseer: await tafseer,
        tajweed: await tajweed,
        // lectures: await lectures,
      );
    }).toList());
  }
}
