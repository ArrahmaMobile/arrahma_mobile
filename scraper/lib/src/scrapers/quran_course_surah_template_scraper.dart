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
  Future<QuranCourseContent?> scrape() async {
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
          .cleanedText,
      surahs: [],
    );

    final items = body.querySelectorAll('#table1 #ayahc').map((i) {
      final links = i.querySelectorAll('a').where((i) => i.children.isNotEmpty);
      return CourseLinkItem(
        name: i.text.cleanedText,
        links: links
            .map((link) => link.attributes['href']?.toAbsolute(url))
            .where((l) => l != null)
            .cast<String>()
            .toList(),
      );
    }).toList();

    final surahs = await Future.wait(
        items.where((i) => i.links.isNotEmpty).map((item) async {
      final linkItem = Utils.getItemByUrl(item.links.first);
      final doc = linkItem?.type == ItemType.WebPage
          ? await scraper.navigateTo(item.links.first)
          : null;
      if (doc == null) {
        final linkItems = item.links
            .map((link) => Utils.getItemByUrl(link))
            .where((l) => l != null)
            .cast<Item>()
            .toList();
        return Surah(
          name: item.name,
          groups: linkItems
              .map((l) => Group(name: Utils.enumToString(l.type)))
              .toList(),
          lessons: [
            Lesson(title: item.name, itemGroups: [GroupItem(items: linkItems)]),
          ],
        );
      } else if (linkItem != null) {
        final content = await QuranCourseJuzTemplateScraper(
                scraper, linkItem.data,
                useHeading: true)
            .scrape();
        return (content?.surahs.isNotEmpty ?? false)
            ? content!.surahs.first.update(name: item.name)
            : null;
      }

      return null;
    }));
    content.surahs.addAll(surahs.where((s) => s != null).cast());

    return content;
  }
}
