import 'package:html/dom.dart';
import 'package:recase/recase.dart';

import 'package:arrahma_shared/shared.dart';

import '../utils.dart';
import '../scraper_base.dart';

class QuranCourseJuzTemplateScraper extends ScraperBase<QuranCourseContent> {
  QuranCourseJuzTemplateScraper(IScraper scraper, String contentUrl,
      {this.useHeading = false})
      : contentUrl = Uri.parse(contentUrl).normalizePath(),
        super(scraper);

  final Uri contentUrl;
  final bool useHeading;

  static const INTRO_TOKEN = 'Introduction';

  @override
  Future<QuranCourseContent> scrape() async {
    var juzNumber = 0;
    var url, prevUrl;

    QuranCourseContent content;
    do {
      prevUrl = url;
      url = _getUrl(++juzNumber);
      if (prevUrl == url) break;
      final doc = await scraper.navigateTo(url);
      if (doc == null) break;
      var hasTabs = false;
      var body = doc.querySelector('#main');
      if (body == null) {
        body = doc.querySelector('#tabs');
        if (body == null) break;
        hasTabs = true;
      }
      content ??= QuranCourseContent(
        title: body.querySelector('#mainheading1')?.text?.cleanedText,
        surahs: [],
      );

      final allNodes = body.querySelectorAll('#table1 div');
      final firstHeading = allNodes.asMap().entries.firstWhere(
          (entry) => entry.value.id == 'mainheading2',
          orElse: () => null);
      final hasIntro = juzNumber == 1 &&
          firstHeading != null &&
          firstHeading.value.text.cleanedText.toUpperCase() ==
              INTRO_TOKEN.toUpperCase();
      if (hasIntro) {
        final surah = _extractLessons(url, allNodes, firstHeading.key,
            isGroupedByHeading: true);
        content.surahs.add(Surah(
            name: INTRO_TOKEN, lessons: surah.lessons, groups: surah.groups));
      }
      final isGroupedByHeading =
          useHeading || hasTabs || !allNodes.any((n) => n.id == 'surahname');
      final surahNodes = allNodes.asMap().entries.where((entry) =>
          entry.value.id ==
          (isGroupedByHeading ? 'mainheading2' : 'surahname'));
      Surah previousSurahOnPage;
      final surahs = surahNodes.map((e) {
        final title = e.value.text.cleanedText;
        var surah = _extractLessons(url, allNodes, e.key,
            previousSurahOnPage: previousSurahOnPage,
            isGroupedByHeading: isGroupedByHeading);
        surah = previousSurahOnPage =
            Surah(name: title, lessons: surah.lessons, groups: surah.groups);
        return surah;
      }).toList();
      if (content.surahs.isNotEmpty &&
          surahs.isNotEmpty &&
          content.surahs.last.name == surahs.first.name) {
        content.surahs.last.lessons.addAll(surahs.first.lessons);
        surahs.removeAt(0);
      }
      content.surahs.addAll(surahs);
    } while (url != prevUrl);

    return content;
  }

  Surah _extractLessons(String url, List<Element> nodes, int index,
      {Surah previousSurahOnPage, bool isGroupedByHeading = false}) {
    final lessons = <Lesson>[];
    final groups = <Group>[];

    String title;
    List<List<Item>> groupItems;
    final addPreviousLesson = () => !title.isNullOrWhitespace
        ? lessons.add(Lesson(
            title: title,
            itemGroups: groupItems
                .map((group) => GroupItem(items: group ?? []))
                .toList(),
          ))
        : null;

    var skipCount = 0, skipped = 0;
    while (++index < nodes.length &&
        nodes[index].id !=
            (isGroupedByHeading ? 'mainheading2' : 'surahname')) {
      final element = nodes[index];
      if (element.id.endsWith('tafseerb')) {
        final groupName = element.text.cleanedText;
        if (groupName != '') {
          groups.add(Group(name: groupName));
        } else {
          skipCount++;
        }
      } else if (element.id.endsWith('ayah') ||
          ['column1', 'column7'].any((id) => element.id.endsWith(id))) {
        addPreviousLesson();
        title = element.text.cleanedText;
        groupItems = [];
        skipped = 0;
      } else if (element.id.endsWith('ayahb') ||
          element.id.contains('column')) {
        if (skipped++ < skipCount) continue;
        final links = element.children.isNotEmpty
            ? element
                .querySelectorAll('a > img')
                .map((tag) =>
                    tag.parent.attributes['href'].cleanedUrl.toAbsolute(url))
                .toList()
            : <String>[];
        groupItems.add(links.map((l) => getItemByUrl(l)).toList());
      }
    }
    addPreviousLesson();
    groups.asMap().entries.forEach((groupEntry) {
      final lesson = lessons.firstWhere(
          (l) =>
              groupEntry.key < l.itemGroups.length &&
              l.itemGroups[groupEntry.key].items.isNotEmpty,
          orElse: () => null);
      if (lesson != null) {
        final group =
            getGroupByItem(lesson.itemGroups[groupEntry.key].items.first);
        groups[groupEntry.key] =
            Group(name: groupEntry.value?.name ?? group.name);
      }
    });
    final maxGroupsLesson = _getMax(lessons, (l) => l.itemGroups.length);
    lessons.forEach((l) {
      final diff = maxGroupsLesson.itemGroups.length - l.itemGroups.length;
      l.itemGroups.addAll(List.filled(diff.abs(), GroupItem(items: [])));
    });
    final lessonGroups = lessons.first.itemGroups;
    final groupCountDiff = groups.length - lessonGroups.length;
    final groupNamesMissing = lessons.isNotEmpty && groupCountDiff.isNegative;
    if (previousSurahOnPage != null && groups.isEmpty) {
      groups.addAll(previousSurahOnPage.groups);
    } else if (groupNamesMissing) {
      final startGroupIndex = groups.length;
      final indexes = List.generate(
              groupCountDiff.abs(), (index) => startGroupIndex + index)
          .reversed
          .toList();

      indexes.forEach((index) {
        final firstFilledGroup = lessons.firstWhere(
            (l) => l.itemGroups[index].items.isNotEmpty,
            orElse: () => null);
        final diff = groups.length - (index + 1);
        final hasFilled = !diff.isNegative;
        if (firstFilledGroup == null && !hasFilled) {
          lessons.forEach((l) => l.itemGroups.removeAt(index));
        } else {
          if (!hasFilled) {
            groups.addAll(List.filled(diff.abs(), null));
          }
          final group =
              getGroupByItem(firstFilledGroup.itemGroups[index].items.first);
          groups[index] = Group(name: groups[index]?.name ?? group.name);
        }
      });
    }
    return Surah(lessons: lessons, groups: groups);
  }

  Item getItemByUrl(String url) {
    final parsedUri = Uri.parse(url);
    final isDirectSource = parsedUri.pathSegments.isNotEmpty &&
        parsedUri.pathSegments.last.contains('.');
    ItemType type;
    if (isDirectSource) {
      final lastSegment = parsedUri.pathSegments.last.toLowerCase();
      if (lastSegment.endsWith('.pdf')) {
        type = ItemType.Pdf;
      } else if (['.mp3', '.wav'].any((ext) => lastSegment.endsWith(ext))) {
        type = ItemType.Audio;
      } else if (['.mp4'].any((ext) => lastSegment.endsWith(ext))) {
        type = ItemType.Video;
      } else if (['.jpg', '.png', '.jpeg', '.gif']
          .any((ext) => lastSegment.endsWith(ext))) {
        type = ItemType.Image;
      }
      type ??= ItemType.File;
    } else {
      if (['video', 'watch']
          .any((partial) => parsedUri.path.contains(partial))) {
        type = ItemType.Video;
      }
      type ??= ItemType.Website;
    }
    return Item(url: url, type: type, isDirectSource: isDirectSource);
  }

  Group getGroupByItem(Item item) {
    final parsedUri = Uri.parse(item.url);
    final urlHostParts = parsedUri.host.split('.');
    final name = !item.isDirectSource
        ? (['www', 'm'].contains(urlHostParts.first.toLowerCase())
                ? urlHostParts[1]
                : urlHostParts.first)
            .sentenceCase
        : null;
    return Group(name: name ?? Utils.enumToString(item.type));
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

  T _getMax<T>(List<T> items, int Function(T) maxSelector) {
    T max;
    for (final item in items) {
      if (max == null || maxSelector(item) > maxSelector(max)) max = item;
    }
    return max;
  }
}
