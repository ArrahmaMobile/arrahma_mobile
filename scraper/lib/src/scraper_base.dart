import 'dart:async';

import 'package:arrahma_shared/shared.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:scraper/src/scrapers/about_us_scraper.dart';
import 'package:scraper/src/scrapers/dua_scraper.dart';
import 'package:scraper/src/scrapers/media_scraper.dart';
import 'package:scraper/src/scrapers/quran_course_scraper.dart';
import 'package:scraper/src/utc_exception.dart';
import 'package:scraper/src/worker.dart';
import 'package:collection/collection.dart';
import 'utils.dart';

abstract class IScraper {
  String get baseUrl;
  Future<Document?> navigateTo(String relativeUrl);
  Future<String?> download(String url, [String contentType]);
}

class Scraper extends Worker<String, Document> implements IScraper {
  Scraper(this.client) : super(maxSimultaneousJobCount: 5);
  final Client client;
  final _cachedDocs = <String, Document>{};

  final _baseUrl = Uri.parse('https://arrahma.org');
  String get baseUrl => _baseUrl.toString();

  int _rateLimitCount = 0;

  @override
  Future<Document?> performWork(String url) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final normalizedUrl = _baseUrl.resolve(url).toString();
    if (_cachedDocs.containsKey(normalizedUrl)) {
      return _cachedDocs[normalizedUrl]!;
    }
    try {
      print('Navigating to $normalizedUrl');
      final html = await download(normalizedUrl, 'text/html');
      if (html == null) return null;
      final document = parse(html);
      _cachedDocs[normalizedUrl] = document;
      return document;
    } catch (err) {
      print('Error occurred while parsing html content: $err');
      return null;
    }
  }

  @override
  Future<String?> download(String url, [String? contentType]) async {
    try {
      final response = await client.get(Uri.parse(url));
      if (response.statusCode != 200 ||
          contentType == null ||
          !response.headers['content-type']!.startsWith(contentType)) {
        print('Unable to download data from $url');
        return null;
      }
      if (response.statusCode == 429) {
        _rateLimitCount++;
        if (_rateLimitCount > 5) {
          throw UnableToContinueException('Rate limited');
        }
        print('Rate limited, waiting for 5 seconds');
        await Future.delayed(const Duration(seconds: 5));
        return download(url, contentType);
      }
      return response.body;
    } catch (err) {
      print('Error occurred: $err');
      if (err is UnableToContinueException) {
        throw err;
      }
      return null;
    }
  }

  @override
  Future<Document?> navigateTo(String url) async {
    return add(url);
  }

  Future<AppData> initiate() async {
    final doc = await navigateTo('');

    if (doc == null) {
      throw Exception('Unable to navigate to the home page');
    }

    final logoUrl = doc
            .querySelector('.header img')
            ?.attributes['src']
            ?.toAbsolute(baseUrl)
            .removeQueryString() ??
        '';

    final quickLinks = doc
        .querySelectorAll('#message1 > *')
        .asMap()
        .entries
        .map((messageEntry) {
          final title = messageEntry.value.parentNode!.nodes
              .whereType<Text>()
              .elementAt(messageEntry.key)
              .text
              .cleanedText;
          final url = (messageEntry.value.localName == 'a'
                  ? messageEntry.value
                  : messageEntry.value.querySelector('a'))
              ?.attributes['href']
              ?.toAbsolute(baseUrl);
          if (url == null) return null;
          return QuickLink(
            title: title.isEmpty ? messageEntry.value.text.cleanedText : title,
            link: Utils.getItemByUrl(url),
          );
        })
        .where((quickLink) => quickLink != null)
        .cast<QuickLink>()
        .toList();

    final banners = doc
        .querySelectorAll('#slider a')
        .map((banner) {
          final imageUrl = banner
              .querySelector('img')
              ?.attributes['src']
              ?.toAbsolute(baseUrl)
              .removeQueryString();
          final link = banner.attributes['href']?.toAbsolute(baseUrl);
          if (imageUrl == null || link == null) return null;
          return HeadingBanner(
            imageUrl: imageUrl,
            item: Utils.getItemByUrl(link)!,
          );
        })
        .where((banner) => banner != null)
        .cast<HeadingBanner>()
        .toList();

    final broadcastItems = doc
        .querySelectorAll('.column6 .box4')
        .map((banner) {
          final aTag = banner.querySelector('a');
          final link = aTag != null
              ? aTag.attributes['href']?.toAbsolute(baseUrl)
              : null;
          final host = link != null ? Uri.parse(link).host.split('.')[0] : null;
          final type = host != null
              ? BroadcastType.values.firstWhereOrNull(
                  (type) => type.toString().split('.')[1].toLowerCase() == host)
              : null;
          final imageUrl = banner
              .querySelector('img')
              ?.attributes['src']
              ?.toAbsolute(baseUrl)
              .removeQueryString();
          if (link == null || imageUrl == null) {
            return null;
          }
          return BroadcastItem(
            type: type ?? BroadcastType.Other,
            item: Utils.getItemByUrl(link)!,
            imageUrl: imageUrl,
          );
        })
        .where((item) => item != null)
        .cast<BroadcastItem>()
        .toList();

    final socialMediaItems = doc
        .querySelectorAll('.column3footer a')
        .map((socialMediaItem) {
          final imageUrl = socialMediaItem
              .querySelector('img')
              ?.attributes['src']
              ?.toAbsolute(baseUrl)
              .removeQueryString();
          if (imageUrl == null) {
            return null;
          }
          final whatsAppMessage =
              'Assalamualaikum, I want to join the Arrahmah WhatsApp group. My name is {name} and my number is {number}.';
          final link = imageUrl.contains('whatsapp')
              ? 'https://wa.me/17323050744?text=${Uri.encodeQueryComponent(whatsAppMessage)}'
              : socialMediaItem.attributes['href']?.toAbsolute(baseUrl);
          if (link == null) return null;
          return SocialMediaItem(
              item: Utils.getItemByUrl(link)!, imageUrl: imageUrl);
        })
        .where((item) => item != null)
        .cast<SocialMediaItem>()
        .toList();

    final drawerItems = (await performAsyncOp(
      doc.querySelectorAll('#container_nav ul#nav > li'),
      scrapeDrawerItem,
    ))
        .where((i) => i != null)
        .cast<DrawerItem>()
        .toList();

    final aboutUsMarkdown = await AboutUsScraper(this).scrape() ?? '';

    final quranCourseList = await QuranCourseScraper(this).scrape();

    final duaCategories = await DuaScraper(this).scrape();

    const courseOrder = ['quran 102', 'quran 101', 'taleemul quran'];

    final courseList = courseOrder
        .map((element) {
          return quranCourseList.firstWhereOrNull(
            (c) => c.title.trim().toLowerCase() == element,
          );
        })
        .where((c) => c != null)
        .cast<QuranCourse>()
        .toList();

    courseList.forEach((c) => quranCourseList.remove(c));

    final allCourses = [...courseList, ...quranCourseList];

    final otherCourseGroups = [
      QuranCourseGroup(
        title: 'Other Courses',
        imageUrl: 'https://arrahma.org/images_n/209.png',
        courses: allCourses.sublist(3),
      )
    ];

    return AppData(
      logoUrl: logoUrl,
      quickLinks: quickLinks,
      banners: banners,
      broadcastItems: broadcastItems,
      socialMediaItems: socialMediaItems,
      drawerItems: drawerItems,
      aboutUsMarkdown: aboutUsMarkdown,
      courses: allCourses.sublist(0, 3),
      otherCourseGroups: otherCourseGroups,
      duaCategories: duaCategories,
    );
  }

  Future<List<TOut>> performAsyncOp<TIn, TOut>(
      List<TIn> arr, Future<TOut> Function(TIn) asyncMap) async {
    var result = <TOut>[];
    for (var item in arr) {
      result.add(await asyncMap(item));
    }
    return result;
  }

  Future<DrawerItem?> scrapeDrawerItem(Element item) async {
    final firstChild = item.children.first;
    final anchorTag =
        firstChild.localName == 'a' ? firstChild : item.querySelector('a');
    final linkUrl = anchorTag?.attributes['href']?.toAbsolute(baseUrl);
    if (anchorTag == null || linkUrl == null) return null;
    final link = Utils.getItemByUrl(
      linkUrl,
    )!;
    final url = Uri.parse(link.data);
    // if (!['tests.php', '#', '.php#'].any((end) => url.toString().endsWith(end)))
    //   return null;
    final pathSegments = url.pathSegments;
    final isLinkExternal = !url.host.contains('arrahma.org');
    final isLinkToContent = !isLinkExternal &&
        pathSegments.isNotEmpty &&
        pathSegments.first != 'index.php' &&
        !pathSegments.first.contains('about') &&
        link.type == ItemType.WebPage;
    final title = anchorTag.text.cleanedText.alphaNumeric;
    final drawerItem = DrawerItem(
      title: title,
      link: link,
      media:
          isLinkToContent ? await MediaScraper(this, link.data).scrape() : null,
      content: isLinkToContent
          ? await QuranCourseScraper(this).scrapeContent(link.data)
          : null,
      children: (await performAsyncOp(
        item.querySelector('ul')?.children ?? <Element>[],
        scrapeDrawerItem,
      ))
          .where((i) => i != null)
          .cast<DrawerItem>()
          .toList(),
    );
    if (drawerItem.content == null &&
        drawerItem.media == null &&
        (drawerItem.children?.isEmpty ?? true) &&
        drawerItem.link?.type == ItemType.WebPage &&
        !isLinkExternal) return null;
    return drawerItem;
  }
}

abstract class ScraperBase<T> {
  const ScraperBase(this.scraper);
  final IScraper scraper;
  Future<T?> scrape();
}

class AdHocScraper<T> extends ScraperBase<T> {
  const AdHocScraper(this.scraperFn, IScraper scraper) : super(scraper);
  final T Function() scraperFn;

  @override
  Future<T> scrape() async => scraperFn();
}
