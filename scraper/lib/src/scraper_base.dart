import 'dart:async';

import 'package:arrahma_shared/shared.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:scraper/src/scrapers/about_us_scraper.dart';
import 'package:scraper/src/scrapers/media_scraper.dart';
import 'package:scraper/src/scrapers/quran_course_scraper.dart';
import 'package:arrahma_shared/src/app_metadata.dart';
import 'package:scraper/src/worker.dart';
import 'utils.dart';

abstract class IScraper {
  Document get document;
  String get currentUrl;
  Future<Document> navigateTo(String relativeUrl);
  Future<String> download(String url, [String contentType]);
}

class Scraper extends Worker<String, Document> implements IScraper {
  Scraper(this.client) : super(maxSimultaneousJobCount: 5);
  final Client client;
  final _cachedDocs = <String, Document>{};

  final _baseUrl = Uri.parse('https://arrahma.org');
  String get baseUrl => _baseUrl.toString();

  String _currentUrl;
  @override
  String get currentUrl => _currentUrl;
  @override
  Document get document => _cachedDocs[currentUrl];

  @override
  Future<Document> performWork(String url) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final normalizedUrl = _baseUrl.resolve(url).toString();
    if (_cachedDocs.containsKey(normalizedUrl)) {
      return _cachedDocs[normalizedUrl];
    }
    try {
      print('Navigating to $normalizedUrl');
      final html = await download(normalizedUrl, 'text/html');
      if (html == null) return null;
      final document = parse(html);
      if (document == null) {
        print('Unable to parse html content from $url');
        return null;
      }
      _cachedDocs[normalizedUrl] = document;
      _currentUrl = normalizedUrl;
      return document;
    } catch (err) {
      return null;
    }
  }

  @override
  Future<String> download(String url, [String contentType]) async {
    final response = await client.get(Uri.parse(url)).catchError((err) => null);
    if (response == null ||
        response.statusCode != 200 ||
        contentType == null ||
        !response.headers['content-type'].startsWith(contentType)) {
      print('Unable to download data from $url');
      return null;
    }
    return response.body;
  }

  @override
  Future<Document> navigateTo(String url) async {
    return add(url);
  }

  Future<AppData> initiate() async {
    final doc = await navigateTo('');
    if (doc == null) return null;
    return AppData(
      logoUrl: document
          .querySelector('.header img')
          .attributes['src']
          .toAbsolute(baseUrl)
          .removeQueryString(),
      quickLinks: document
          .querySelectorAll('#message1 > *')
          .asMap()
          .entries
          .map((messageEntry) => QuickLink(
                title: messageEntry.value.parentNode.nodes
                    .whereType<Text>()
                    .elementAt(messageEntry.key)
                    .text
                    .cleanedText,
                link: Utils.getItemByUrl(
                    messageEntry.value.attributes['href'].toAbsolute(baseUrl)),
              ))
          .toList(),
      banners: document
          .querySelectorAll('#slider a')
          .map((banner) => HeadingBanner(
                imageUrl: banner
                    .querySelector('img')
                    .attributes['src']
                    .toAbsolute(baseUrl)
                    .removeQueryString(),
                item: Utils.getItemByUrl(
                    banner.attributes['href'].toAbsolute(baseUrl)),
              ))
          .toList(),
      broadcastItems: document.querySelectorAll('.column6 .box4').map((banner) {
        final aTag = banner.querySelector('a');
        final link =
            aTag != null ? aTag.attributes['href'].toAbsolute(baseUrl) : null;
        final host = link != null ? Uri.parse(link).host.split('.')[0] : null;
        final type = host != null
            ? BroadcastType.values.firstWhere(
                (type) => type.toString().split('.')[1].toLowerCase() == host,
                orElse: () => null)
            : null;
        return BroadcastItem(
          type: type ?? BroadcastType.Other,
          item: link != null
              ? Utils.getItemByUrl(link)
              : Item(
                  isDirectSource: true,
                  type: ItemType.Other,
                  data: 'tel:7124321001;ext=491760789',
                ),
          imageUrl: banner
              .querySelector('img')
              ?.attributes['src']
              ?.toAbsolute(baseUrl)
              ?.removeQueryString(),
        );
      }).toList(),
      socialMediaItems:
          document.querySelectorAll('.column3footer a').map((socialMediaItem) {
        final link = socialMediaItem.attributes['href'].toAbsolute(baseUrl);
        final imageUrl = socialMediaItem
            .querySelector('img')
            ?.attributes['src']
            ?.toAbsolute(baseUrl)
            ?.removeQueryString();
        return SocialMediaItem(
            item: Utils.getItemByUrl(link), imageUrl: imageUrl);
      }).toList(),
      drawerItems: (await performAsyncOp(
        document.querySelectorAll('#container_nav ul#nav > li'),
        scrapeDrawerItem,
      ))
          .where((i) => i != null)
          .toList(),
      aboutUsMarkdown: await AboutUsScraper(this).scrape(),
      courses: await QuranCourseScraper(this).scrape(),
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

  Future<DrawerItem> scrapeDrawerItem(Element item) async {
    final firstChild = item.children.first;
    final anchorTag =
        firstChild.localName == 'a' ? firstChild : item.querySelector('a');
    final link = Utils.getItemByUrl(
      anchorTag.attributes['href'].toAbsolute(baseUrl),
    );
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
          .toList(),
    );
    if (drawerItem.content == null &&
        drawerItem.media == null &&
        drawerItem.children.isEmpty &&
        drawerItem.link.type == ItemType.WebPage &&
        !isLinkExternal) return null;
    return drawerItem;
  }
}

abstract class ScraperBase<T> {
  const ScraperBase(this.scraper);
  final IScraper scraper;
  Future<T> scrape();
}

class AdHocScraper<T> extends ScraperBase<T> {
  const AdHocScraper(this.scraperFn, IScraper scraper) : super(scraper);
  final T Function() scraperFn;

  @override
  Future<T> scrape() async => scraperFn();
}
