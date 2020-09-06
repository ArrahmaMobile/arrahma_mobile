import 'package:html/dom.dart';

import 'package:arrahma_shared/shared.dart';

import '../utils.dart';
import '../scraper_base.dart';

class QuranCourseJuzTemplateScraper implements ScraperBase<QuranCourseContent> {
  QuranCourseJuzTemplateScraper(String contentUrl, {this.useHeading = false})
      : contentUrl = Uri.parse(contentUrl).normalizePath();

  final Uri contentUrl;
  final bool useHeading;

  static const INTRO_TOKEN = 'Introduction';

  @override
  Future<QuranCourseContent> scrape(IScraper scraper) async {
    var juzNumber = 0;
    var url, prevUrl;

    QuranCourseContent content;
    do {
      prevUrl = url;
      url = _getUrl(++juzNumber);
      if (prevUrl == url) break;
      final doc = await scraper.navigateTo(url);
      if (doc == null) break;
      final body = doc.querySelector('#main');
      if (body == null) break;
      content ??= QuranCourseContent(
        title: body.querySelector('#mainheading1').text.cleanedText,
        surahs: [],
      );

      final allNodes = body.querySelectorAll('#table1 div');
      final firstHeading = allNodes
          .asMap()
          .entries
          .firstWhere((entry) => entry.value.id == 'mainheading2');
      final hasIntro = juzNumber == 1 &&
          firstHeading.value.text.cleanedText.toUpperCase() ==
              INTRO_TOKEN.toUpperCase();
      if (hasIntro) {
        final surah = _extractLessons(url, allNodes, firstHeading.key, true);
        content.surahs.add(Surah(
            name: INTRO_TOKEN,
            lessons: surah.lessons,
            groupNames: surah.groupNames));
      }
      final surahNodes = allNodes.asMap().entries.where((entry) =>
          entry.value.id == (useHeading ? 'mainheading2' : 'surahname'));
      final surahs = surahNodes.map((e) {
        final title = e.value.text.cleanedText;
        final surah = _extractLessons(url, allNodes, e.key);
        return Surah(
            name: title, lessons: surah.lessons, groupNames: surah.groupNames);
      }).toList();
      if (content.surahs.isNotEmpty &&
          content.surahs.last.name == surahs.first.name) {
        content.surahs.last.lessons.addAll(surahs.first.lessons);
        surahs.removeAt(0);
      }
      content.surahs.addAll(surahs);
    } while (url != prevUrl);

    return content;
  }

  Surah _extractLessons(String url, List<Element> nodes, int index,
      [bool isIntro = false]) {
    final lessons = <Lesson>[];
    final groupNames = <String>[];

    String title;
    List<List<String>> groupItems;
    final addPreviousLesson = () => title != null
        ? lessons.add(Lesson(
            title: title,
            itemGroups: groupItems
                .map((group) => ItemGroup(items: group ?? []))
                .toList(),
          ))
        : null;

    var skipCount = 0, skipped = 0;
    while (++index < nodes.length &&
        nodes[index].id != (isIntro ? 'mainheading2' : 'surahname')) {
      final element = nodes[index];
      if (element.id.endsWith('tafseerb')) {
        final groupName = element.text.cleanedText;
        if (groupName != '') {
          groupNames.add(groupName);
        } else {
          skipCount++;
        }
      } else if (element.id.endsWith('ayah')) {
        addPreviousLesson();
        title = element.text.cleanedText;
        groupItems = [];
        skipped = 0;
      } else if (element.id.endsWith('ayahb')) {
        if (skipped++ < skipCount) continue;
        final links = element.children.isNotEmpty
            ? element
                .querySelectorAll('a > img')
                .map((tag) => tag.parent.attributes['href'].toAbsolute(url))
                .toList()
            : <String>[];
        groupItems.add(links);
      }
    }
    addPreviousLesson();
    return Surah(lessons: lessons, groupNames: groupNames);
  }

  String _getUrl(int page) {
    var url = contentUrl.toString();
    final lastSegment = contentUrl.pathSegments.last;
    if (lastSegment.contains('juz')) {
      final updatedLastSegment =
          lastSegment.replaceFirst(RegExp(r'juz(\d)+'), 'juz${page}');
      final newSegments = [
        ...contentUrl.pathSegments
            .sublist(0, contentUrl.pathSegments.length - 1),
        updatedLastSegment
      ];
      url = contentUrl.replace(pathSegments: newSegments).toString();
    }
    return url;
  }
}
