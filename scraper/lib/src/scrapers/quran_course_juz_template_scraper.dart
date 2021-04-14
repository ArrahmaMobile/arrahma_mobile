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
    List<String> pages;
    var url, prevUrl;

    QuranCourseContent content;
    do {
      prevUrl = url;
      url = pages != null
          ? pages.length > juzNumber
              ? pages[juzNumber++]
              : prevUrl
          : _getUrl(++juzNumber);
      if (prevUrl == url) break;
      final doc = await scraper.navigateTo(url);
      if (doc == null) break;
      final pageListParent = doc.querySelector('#containerb .contentdua .next');
      if (pageListParent?.children?.isNotEmpty ?? false) {
        pages = pageListParent
            .querySelectorAll('a')
            .where((p) => !['next', 'prev'].any((t) => p.text.contains(t)))
            .map((e) => e.attributes['href'].cleanedUrl.toAbsolute(url))
            .toList();
      }
      var hasTabs = false;
      var body = doc.querySelector(r'#main,#maina,#containerb,#studentportion');
      if (body == null) {
        body = doc.querySelector('#tabs');
        if (body == null) break;
        hasTabs = true;
      }
      final titleEl = body.querySelector('#mainheading1') ??
          body.querySelector('#mainheading2') ??
          body.querySelector('#studentheading') ??
          body.querySelector('#mainheadingdua');
      content ??= QuranCourseContent(
        id: url,
        title: titleEl?.text?.cleanedText,
        surahs: [],
      );

      var allNodes = body.querySelectorAll('#table1 div');
      final isOldLayout = allNodes.isEmpty || url.contains('duas_n');
      allNodes = isOldLayout && allNodes.isEmpty
          ? body
              .querySelectorAll(
                  '#grammarinsidetable div,#innercontainer div,#studentportion2 #studentpresentation div, .contentdua table img')
              .where((e) =>
                  !['titledivision3', 'grammartopic3']
                      .any((id) => e.id == id) &&
                  (e.localName != 'img' ||
                      !e.attributes['src'].contains('speaker')))
              .toList()
          : allNodes;
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
        if (surah != null) {
          content.surahs.add(Surah(
              name: INTRO_TOKEN, lessons: surah.lessons, groups: surah.groups));
        }
      }
      final hasMainHeading = allNodes.any((n) => n.id == 'mainheading2');
      final hasSurahHeading = allNodes.any((n) => n.id.startsWith('surahname'));
      final isGroupedByHeading =
          hasTabs || (useHeading && hasMainHeading) || !hasSurahHeading;
      final surahNodes = allNodes.asMap().entries.where((entry) => entry
          .value.id
          .startsWith((isGroupedByHeading ? 'mainheading2' : 'surahname')));
      Surah previousSurahOnPage;
      final surahs = (isOldLayout ? [MapEntry(-1, titleEl)] : surahNodes)
          .map((e) {
            final title = e.value?.text?.cleanedText;
            var surah = _extractLessons(
              url,
              allNodes,
              e.key,
              previousSurahOnPage: previousSurahOnPage,
              isGroupedByHeading: isGroupedByHeading,
              isOldLayout: isOldLayout,
            );
            if (surah == null) return null;
            surah = previousSurahOnPage = Surah(
                name: title.isNullOrWhitespace ? null : title,
                lessons: surah.lessons,
                groups: surah.groups);
            return surah;
          })
          .where((s) => s != null)
          .toList();
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
      {Surah previousSurahOnPage,
      bool isGroupedByHeading = false,
      bool isOldLayout = false}) {
    final lessons = <Lesson>[];
    final groups = <Group>[];
    final groupNameSet = <String>{};

    String title;
    List<List<Item>> groupItems;
    var allowNullLesson = false;
    final addPreviousLesson = () => !title.isNullOrWhitespace || allowNullLesson
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
      if (element.id.endsWith('tafseerb') || element.id == 'titledivision4') {
        final groupName = element.text.cleanedText;
        if (groupName != '' &&
            (!isOldLayout || !groupNameSet.contains(groupName))) {
          groups.add(Group(name: groupName));
          groupNameSet.add(groupName);
        } else {
          // skipCount++;
        }
      } else if (['duatopic'].any((id) => element.id == id)) {
        final text = element.text.cleanedText;
        final item =
            Item(data: text, type: ItemType.Title, isDirectSource: true);
        if (groupItems.isEmpty ||
            groupItems.first.first.type != ItemType.Title) {
          groupItems.insert(0, []);
        }
        groupItems[0].add(item);
      } else if (['ayah', 'column1', 'column7', 'tajweedc', 'topic']
              .any((id) => element.id.endsWith(id)) ||
          ['surahname1', 'presentationtitle', 'duatopica']
              .any((id) => element.id == id) ||
          ['surahname', 'seerahheading']
              .any((className) => element.className == className)) {
        // TITLE
        addPreviousLesson();
        title = element.text.cleanedText;
        groupItems = [];
        skipped = 0;
        if (element.id == 'duatopica') {
          final link = element.querySelector('a');
          final duaUrl = link.attributes['href']?.cleanedUrl?.toAbsolute(url);
          if (duaUrl != null) groupItems.add([Utils.getItemByUrl(duaUrl)]);
        }
      } else if (['ayahb', 'hb', 'tajweedd', 'topic1', 'grammartopic4']
              .any((id) => element.id.endsWith(id)) ||
          element.id.contains('column') ||
          ['d3', 'presentationlink'].any((id) => element.id == id)) {
        // Items
        if (skipped++ < skipCount) continue;
        final links = element.children.isNotEmpty
            ? element
                .querySelectorAll('a > img')
                .map((tag) =>
                    tag.parent.attributes['href'].cleanedUrl.toAbsolute(url))
                .toList()
            : <String>[];
        groupItems.add(links.map((l) => Utils.getItemByUrl(l)).toList());
      } else if (url.contains('dua') && element.localName == 'img') {
        addPreviousLesson();
        allowNullLesson = true;
        final imageUrl = element.attributes['src'].toAbsolute(url);
        groupItems = [];
        groupItems.add([Utils.getItemByUrl(imageUrl)]);
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
    if (lessons.isEmpty) return null;
    if (previousSurahOnPage != null && groups.isEmpty) {
      groups.addAll(previousSurahOnPage.groups);
    }
    final lessonGroups = lessons.first.itemGroups;
    final groupCountDiff = groups.length - lessonGroups.length;
    final groupNamesMissing = lessons.isNotEmpty && groupCountDiff.isNegative;
    if (groupNamesMissing) {
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
        if (firstFilledGroup == null) {
          final removeGroup = groups.length == lessons.first.itemGroups.length;
          lessons.forEach((l) => l.itemGroups.removeAt(index));
          if (removeGroup) groups.removeAt(index);
        } else if (firstFilledGroup != null) {
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

  Group getGroupByItem(Item item) {
    final parsedUri = Uri.parse(item.data);
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
