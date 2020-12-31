import 'dart:async';

import 'package:arrahma_shared/shared.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:scraper/src/scrapers/about_us_scraper.dart';
import 'package:scraper/src/scrapers/quran_course_scraper.dart';
import 'package:arrahma_shared/src/app_metadata.dart';
import 'package:scraper/src/worker.dart';
import 'utils.dart';

abstract class IScraper {
  Document get document;
  String get currentUrl;
  Future<Document> navigateTo(String relativeUrl);
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
    await Future.delayed(const Duration(milliseconds: 500));
    final normalizedUrl = _baseUrl.resolve(url).toString();
    if (_cachedDocs.containsKey(normalizedUrl)) {
      return _cachedDocs[normalizedUrl];
    }
    try {
      print('Navigating to $normalizedUrl');
      final response =
          await client.get(normalizedUrl).catchError((err) => null);
      if (response == null ||
          response.statusCode != 200 ||
          !response.headers['content-type'].startsWith('text/html')) {
        return null;
      }
      final document = parse(response.body);
      _cachedDocs[normalizedUrl] = document;
      _currentUrl = normalizedUrl;
      return document;
    } catch (err) {
      return null;
    }
  }

  @override
  Future<Document> navigateTo(String url) async {
    // print('Pausing to avoid request burst and rate limiting...');
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
                  url: 'tel:7124321001;ext=491760789',
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
      drawerItems: await performAsyncOp(
        document.querySelectorAll('#container_nav ul#nav > li'),
        scrapeDrawerItem,
      ),
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
    final url = Uri.parse(link.url);
    final pathSegments = url.pathSegments;
    final isLinkToContent = url.host.contains('arrahma.org') &&
        pathSegments.isNotEmpty &&
        pathSegments.first != 'index.php' &&
        !pathSegments.first.contains('about') &&
        pathSegments.last.endsWith('.php');
    return DrawerItem(
      title: anchorTag.text.cleanedText,
      link: link,
      content: isLinkToContent
          ? await QuranCourseScraper(this).scrapeContent(link.url)
          : null,
      children: await performAsyncOp(
        item.querySelector('ul')?.children ?? <Element>[],
        scrapeDrawerItem,
      ),
    );
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
