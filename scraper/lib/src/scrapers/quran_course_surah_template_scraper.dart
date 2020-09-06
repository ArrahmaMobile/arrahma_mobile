import 'package:arrahma_shared/shared.dart';
import 'package:scraper/src/scrapers/quran_course_juz_template_scraper.dart';

import '../utils.dart';
import '../scraper_base.dart';

class QuranCourseSurahTemplateScraper
    implements ScraperBase<QuranCourseContent> {
  QuranCourseSurahTemplateScraper(String contentUrl)
      : contentUrl = Uri.parse(contentUrl).normalizePath();

  final Uri contentUrl;

  static const INTRO_TOKEN = 'Introduction';

  @override
  Future<QuranCourseContent> scrape(IScraper scraper) async {
    final url = contentUrl.toString();
    final doc = await scraper.navigateTo(url);
    if (doc == null) return null;
    final body = doc.querySelector('#main');
    if (body == null) return null;
    final content = QuranCourseContent(
      title: body.querySelector('#mainheading1').text.cleanedText,
      surahs: [],
    );

    final items = body
        .querySelectorAll('#table1 #ayahc')
        .map(
          (i) => CourseLinkItem(
            name: i.text.cleanedText,
            link: i.querySelector('a').attributes['href'].toAbsolute(url),
          ),
        )
        .toList();

    final surahs = await Future.wait(items.map((item) async {
      final doc = await scraper.navigateTo(item.link);
      if (doc == null) {
        final response = scraper.getResponse(url);
        if (response != null &&
            response.statusCode >= 200 &&
            response.statusCode < 300) {
          return Surah(
            name: item.name,
            groupNames: ['Intro'],
            lessons: [
              Lesson(title: item.name, itemGroups: [
                ItemGroup(items: [item.link])
              ]),
            ],
          );
        }
      } else {
        final content =
            await QuranCourseJuzTemplateScraper(item.link, useHeading: true)
                .scrape(scraper);
        return content.surahs.isNotEmpty ? content.surahs.first : null;
      }
      return null;
    }));
    content.surahs.addAll(surahs);

    return content;
  }
}
