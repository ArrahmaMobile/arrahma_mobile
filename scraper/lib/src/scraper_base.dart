import 'package:arrahma_shared/shared.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:scraper/src/scrapers/quran_course_scraper.dart';
import 'package:arrahma_shared/src/app_metadata.dart';
import 'utils.dart';

abstract class IScraper {
  Document get document;
  String get currentUrl;
  Response getResponse(String url);
  Future<Document> navigateTo(String relativeUrl);
}

abstract class IScraperRegistrar {
  void register(ScraperBase<dynamic> scraper);
}

class Scraper implements IScraper, IScraperRegistrar {
  Scraper(this.client);
  final BaseClient client;
  final _scrapers = <ScraperBase<dynamic>>[];
  final _cachedDocs = <String, Document>{};
  final _cachedResponses = <String, Response>{};
  final _baseUrl = Uri.parse('http://arrahma.org');

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
    logger.info('Navigating to $normalizedUrl');
    final response = await client.get(normalizedUrl).catchError((err) => null);
    _cachedResponses[normalizedUrl] = response;
    if (response == null ||
        response.statusCode != 200 ||
        !response.headers['content-type'].startsWith('text/html')) return null;
    final document = parse(response.body);
    _cachedDocs[normalizedUrl] = document;
    _currentUrl = normalizedUrl;
    return document;
  }

  Future<AppData> initiate() async {
    final doc = await navigateTo('');
    if (doc == null) return null;
    return AppData(
      logoUrl: document
          .querySelector('.header img')
          .attributes['src']
          .toAbsolute(currentUrl),
      banners: document
          .querySelectorAll('#slider a')
          .map((banner) => HeadingBanner(
                imageUrl: banner
                    .querySelector('img')
                    .attributes['src']
                    .toAbsolute(currentUrl),
                linkUrl: banner.attributes['href'].toAbsolute(currentUrl),
              ))
          .toList(),
      broadcastItems: document.querySelectorAll('.column6 .box4').map((banner) {
        final aTag = banner.querySelector('a');
        final link = aTag != null ? aTag.attributes['href'] : null;
        final host = link != null ? Uri.parse(link).host.split('.')[0] : null;
        final type = host != null
            ? BroadcastType.values.firstWhere(
                (type) => type.toString().split('.')[1].toLowerCase() == host,
                orElse: () => null)
            : null;
        return BroadcastItem(
            type: type ?? BroadcastType.Other,
            linkUrl: link,
            imageUrl: banner
                .querySelector('img')
                ?.attributes['src']
                ?.toAbsolute(currentUrl));
      }).toList(),
      socialMediaItems:
          document.querySelectorAll('.column3footer a').map((socialMediaItem) {
        final link = socialMediaItem.attributes['href'];
        final imageUrl = socialMediaItem
            .querySelector('img')
            ?.attributes['src']
            ?.toAbsolute(currentUrl);
        return SocialMediaItem(linkUrl: link, imageUrl: imageUrl);
      }).toList(),
      courses: await QuranCourseScraper().scrape(this),
    );
  }

  @override
  void register(ScraperBase<dynamic> scraper) {
    _scrapers.add(scraper);
  }
}

abstract class ScraperBase<T> {
  const ScraperBase();
  Future<T> scrape(IScraper scraper);
}

class AdHocScraper<T> extends ScraperBase<T> {
  const AdHocScraper(this.scraperFn);
  final T Function(IScraper scraper) scraperFn;

  @override
  Future<T> scrape(IScraper scraper) async => scraperFn(scraper);
}
