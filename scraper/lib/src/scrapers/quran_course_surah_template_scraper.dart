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
      id: url,
      title: (body.querySelector('#mainheading1') ??
              body.querySelector('#mainheading2'))
          ?.text
          ?.cleanedText,
      surahs: [],
    );

    final items = body.querySelectorAll('#table1 #ayahc').map((i) {
      final link = i.querySelector('a');
      return CourseLinkItem(
        name: i.text.cleanedText,
        link: link != null ? link.attributes['href'].toAbsolute(url) : null,
      );
    }).toList();

    final surahs =
        await Future.wait(items.where((i) => i.link != null).map((item) async {
      final doc = item.link.urlPathSegments.last.endsWith('mp3')
          ? null
          : await scraper.navigateTo(item.link);
      if (doc == null) {
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
      } else {
        final content = await QuranCourseJuzTemplateScraper(scraper, item.link,
                useHeading: true)
            .scrape();
        return (content?.surahs?.isNotEmpty ?? false)
            ? content.surahs.first.update(name: item.name)
            : null;
      }
    }));
    content.surahs.addAll(surahs);

    return content;
  }
}
