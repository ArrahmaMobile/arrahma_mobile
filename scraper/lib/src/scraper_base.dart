import 'dart:async';

import 'package:arrahma_shared/shared.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:scraper/src/scrapers/about_us_scraper.dart';
import 'package:scraper/src/scrapers/quran_course_scraper.dart';
import 'package:arrahma_shared/src/app_metadata.dart';
import 'utils.dart';

abstract class IScraper {
  Document get document;
  String get currentUrl;
  Response getResponse(String url);
  Future<Document> navigateTo(String relativeUrl);
}

class Scraper implements IScraper {
  Scraper(this.client);
  final BaseClient client;
  final _cachedDocs = <String, Document>{};
  final _cachedRequests = <String, Future<Document>>{};
  final _cachedResponses = <String, Response>{};
  final _baseUrl = Uri.parse('https://arrahma.org');

  String _currentUrl;
  @override
  String get currentUrl => _currentUrl;
  @override
  Document get document => _cachedDocs[currentUrl];

  @override
  Response getResponse(String url) => _cachedResponses[url];

  @override
  Future<Document> navigateTo(String url) async {
    final normalizedUrl = _baseUrl.resolve(url).toString();
    if (_cachedDocs.containsKey(normalizedUrl)) {
      return _cachedDocs[normalizedUrl];
    }
    final completer = Completer<Document>();
    _cachedRequests[normalizedUrl] = completer.future;
    if (_cachedRequests.isNotEmpty && _cachedRequests.length % 6 == 0) {
      print('Pausing to avoid request burst and rate limiting...');
      await Future<dynamic>.delayed(const Duration(seconds: 5));
    }
    print('Navigating to $normalizedUrl');
    try {
      final response =
          await client.get(normalizedUrl).catchError((err) => null);
      _cachedResponses[normalizedUrl] = response;
      if (response == null ||
          response.statusCode != 200 ||
          !response.headers['content-type'].startsWith('text/html')) {
        return null;
      }
      final document = parse(response.body);
      _cachedDocs[normalizedUrl] = document;
      _currentUrl = normalizedUrl;
      completer.complete(document);
      return document;
    } catch (err) {
      completer.completeError(err);
    }
    return null;
  }

  Future<AppData> initiate() async {
    final doc = await navigateTo('');
    if (doc == null) return null;
    return AppData(
      logoUrl: document
          .querySelector('.header img')
          .attributes['src']
          .toAbsolute(currentUrl)
          .removeQueryString(),
      drawerItems: document
          .querySelectorAll('.container_nav .nav > li a')
          .map((item) => scrapeDrawerItem(item))
          .toList(),
      quickLinks: document
          .querySelectorAll('#message1 > *')
          .asMap()
          .entries
          .map((messageEntry) => QuickLink(
                title: messageEntry.value.parentNode.nodes
                    .whereType<Text>()
                    .elementAt(messageEntry.key)
                    .text,
                link: Utils.getItemByUrl(messageEntry.value.attributes['href']
                    .toAbsolute(currentUrl)),
              ))
          .toList(),
      banners: document
          .querySelectorAll('#slider a')
          .map((banner) => HeadingBanner(
                imageUrl: banner
                    .querySelector('img')
                    .attributes['src']
                    .toAbsolute(currentUrl)
                    .removeQueryString(),
                item: Utils.getItemByUrl(
                    banner.attributes['href'].toAbsolute(currentUrl)),
              ))
          .toList(),
      broadcastItems: document.querySelectorAll('.column6 .box4').map((banner) {
        final aTag = banner.querySelector('a');
        final link = aTag != null
            ? aTag.attributes['href'].toAbsolute(currentUrl)
            : null;
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
              ?.toAbsolute(currentUrl)
              ?.removeQueryString(),
        );
      }).toList(),
      socialMediaItems:
          document.querySelectorAll('.column3footer a').map((socialMediaItem) {
        final link = socialMediaItem.attributes['href'].toAbsolute(currentUrl);
        final imageUrl = socialMediaItem
            .querySelector('img')
            ?.attributes['src']
            ?.toAbsolute(currentUrl)
            ?.removeQueryString();
        return SocialMediaItem(
            item: Utils.getItemByUrl(link), imageUrl: imageUrl);
      }).toList(),
      aboutUsMarkdown: await AboutUsScraper(this).scrape(),
      courses: await QuranCourseScraper(this).scrape(),
    );
  }

  DrawerItem scrapeDrawerItem(Element item) {
    return DrawerItem(
      title: item.text,
      link: Utils.getItemByUrl(item.attributes['href']),
      children: item
          .querySelectorAll('ul li a')
          .map((item) => scrapeDrawerItem(item))
          .toList(),
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
