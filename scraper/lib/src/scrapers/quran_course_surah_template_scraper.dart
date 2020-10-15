import 'package:arrahma_shared/shared.dart';
import 'package:scraper/src/scrapers/quran_course_juz_template_scraper.dart';

import '../utils.dart';
import '../scraper_base.dart';

class QuranCourseSurahTemplateScraper extends ScraperBase<QuranCourseContent> {
  QuranCourseSurahTemplateScraper(IScraper scraper, String contentUrl)
      : contentUrl = Uri.parse(contentUrl).normalizePath(),
        super(scraper);

  final Uri contentUrl;

  static const INTRO_TOKEN = 'Introduction';

  @override
  Future<QuranCourseContent> scrape() async {
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
            groups: [Group(name: 'Intro')],
            lessons: [
              Lesson(title: item.name, itemGroups: [
                GroupItem(items: [
                  Item(
                    isDirectSource: true,
                    url: item.link,
                    type: ItemType.Audio,
                  )
                ])
              ]),
            ],
          );
        }
      } else {
        final content = await QuranCourseJuzTemplateScraper(scraper, item.link,
                useHeading: true)
            .scrape();
        return content.surahs.isNotEmpty
            ? content.surahs.first.update(name: item.name)
            : null;
      }
      return null;
    }));
    content.surahs.addAll(surahs);

    return content;
  }
}
