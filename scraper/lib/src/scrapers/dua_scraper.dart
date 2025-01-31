import 'package:arrahma_shared/shared.dart';
import 'package:html/dom.dart';

import '../scraper_base.dart';
import 'package:collection/collection.dart';
import '../utils.dart';
import 'quran_course_surah_template_scraper.dart';
import 'dart:convert';

class DuaScraper extends ScraperBase<List<DuaCategory>> {
  const DuaScraper(IScraper scraper) : super(scraper);

  @override
  Future<List<DuaCategory>> scrape() async {
    final cats = <DuaCategory>[];
    final duaPageUrl = 'duas/duas.php';
    final doc = await scraper.navigateTo(duaPageUrl);
    if (doc == null) return cats;

    final topCats = doc.querySelectorAll('div.container a');

    for (final cat in topCats) {
      final img = cat.querySelector('img');
      if (img == null) continue;

      final imageUrl =
          img.attributes['src']!.toAbsolute(scraper.baseUrl + '/' + duaPageUrl);

      final url = cat.attributes['href']!.toAbsolute(scraper.baseUrl);

      final urlIsDuaPage = url.contains('/duas/pages/');

      if (urlIsDuaPage) {
        final scrapedData = (await scrapeDuaPage(url))?.copyWith(
          imageUrl: imageUrl,
        );

        if (scrapedData != null) cats.add(scrapedData);
      } else {
        final scrapedData =
            await QuranCourseSurahTemplateScraper(scraper, url).scrape();
        if (scrapedData != null) {
          final nestedCats = <DuaCategory>[];
          for (final dua in scrapedData.surahs) {
            final duaData =
                await scrapeDuaPage(dua.lessons[0].itemGroups[0].items[0].data);
            if (duaData != null) nestedCats.add(duaData);
          }
          cats.add(DuaCategory(
            title: scrapedData.title ?? '',
            titleUrdu: '',
            imageUrl: imageUrl,
            categories: nestedCats,
            duas: [],
          ));
        }
      }
    }

    final listItems = doc
        .querySelectorAll('#table1 #ayahc')
        .map((i) {
          final links =
              i.querySelectorAll('a').where((i) => i.children.isNotEmpty);

          final filteredLinks = links.where((i) =>
              i.attributes['href'] != null &&
              i.attributes['href']!.contains('/duas/pages/'));

          return filteredLinks.toList().map(
              (link) => link.attributes['href']!.toAbsolute(scraper.baseUrl));
        })
        .toList()
        .flattenedToList;

    for (final link in listItems) {
      final scrapedData = await scrapeDuaPage(link);
      if (scrapedData != null) cats.add(scrapedData);
    }

    final remainingCats =
        await QuranCourseSurahTemplateScraper(scraper, 'duas/duas.php')
            .scrape();
    if (remainingCats == null) return cats;

    // cats.addAll(remainingCats.surahs.map((c) => c.));

    return cats;
  }

  String? _extractText(Element? parent, String selector) {
    final element = parent?.querySelector(selector);
    if (element == null) return null;
    final text = element.text.trim();
    // Make sure it is utf-8 encoded

    try {
      final latin1Bytes = text.codeUnits;

      final intermediate = latin1.decode(latin1Bytes);

      final utf8Bytes = intermediate.codeUnits;
      final fixed = utf8.decode(utf8Bytes);

      return text.isEmpty ? null : fixed;
    } catch (e) {
      return text.isEmpty ? null : text;
    }
  }

  Future<DuaCategory?> scrapeDuaPage(String url) async {
    final document = await scraper.navigateTo(url);

    final frame = document?.querySelector('div.frame');
    if (frame == null) {
      return null;
    }

    // Header section
    final header = frame.querySelector('.header');
    // If text is empty, _extractText(...) returns null
    final title = _extractText(header, 'h1.category-title') ?? '';
    final titleUrdu = _extractText(header, 'p.category-title-urdu') ?? '';

    final notes = null;

    // Content blocks
    final contentDivs = frame.querySelectorAll('div.content');
    final duass = <Dua>[];

    for (int i = 0; i < contentDivs.length; i++) {
      final contentDiv = contentDivs[i];

      // Here we extract or store null:
      final rawTitle = _extractText(contentDiv, 'h2.dua-title');
      final rawTitleUrdu = _extractText(contentDiv, 'p.dua-title-urdu');
      final rawDuaArabic = _extractText(contentDiv, 'p.dua-arabic');
      final rawDuaEnglish = _extractText(contentDiv, 'p.dua-english');
      final rawDuaUrdu = _extractText(contentDiv, 'p.dua-urdu');

      // If there is absolutely no Arabic text, set it to an empty string (or handle as needed)
      // But "dua" is required, so we assume there's at least something there.
      final String duaArabic = rawDuaArabic ?? '';

      final dua = Dua(
        id: '${i + 1}', // generate an ID
        title: rawTitle,
        titleUrdu: rawTitleUrdu,
        dua: duaArabic,
        duaEnglish: rawDuaEnglish,
        duaUrdu: rawDuaUrdu,
        // If you have "notes" stored somewhere, parse them here too
        notes: null,
      );

      duass.add(dua);
    }

    return DuaCategory(
      title: title,
      titleUrdu: titleUrdu,
      notes: notes,
      duas: duass,
    );
  }
}
