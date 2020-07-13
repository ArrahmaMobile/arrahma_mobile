import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:scraper/src/courses.dart';
import 'package:scraper/src/models/app_metadata.dart';
import 'models/banner.dart';
import 'models/broadcast_link.dart';
import 'utils.dart';

abstract class IScraper {
  Document get document;
  String get currentUrl;
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
  final _baseUrl = Uri.parse('https://arrahma.org');

  String _currentUrl;
  @override
  String get currentUrl => _currentUrl;
  @override
  Document get document => _cachedDocs[currentUrl];

  @override
  Future<Document> navigateTo(String url) async {
    final normalizedUrl = _baseUrl.resolve(url).toString();
    if (_cachedDocs.containsKey(normalizedUrl)) {
      return _cachedDocs[normalizedUrl];
    }
    final response = await client.get(normalizedUrl);
    if (response.statusCode != 200) return null;
    final document = parse(response.body);
    _cachedDocs[normalizedUrl] = document;
    _currentUrl = normalizedUrl;
    return document;
  }

  Future<AppMetadata> initiate() async {
    await navigateTo('');
    return AppMetadata(
      logoUrl: document
          .querySelector('.header img')
          .attributes['src']
          .toAbsolute(currentUrl),
      banners: document
          .querySelectorAll('#slider a')
          .map((banner) => Banner(
                imageUrl: banner
                    .querySelector('img')
                    .attributes['src']
                    .toAbsolute(currentUrl),
                link: banner.attributes['href'].toAbsolute(currentUrl),
              ))
          .toList(),
      broadcastLinks: document.querySelectorAll('.column6 .box4').map((banner) {
        final aTag = banner.querySelector('a');
        final link = aTag != null ? aTag.attributes['href'] : null;
        final host = link != null ? Uri.parse(link).host.split('.')[0] : null;
        final type = host != null
            ? BroadcastType.values.firstWhere(
                (type) => type.toString().split('.')[1].toLowerCase() == host,
                orElse: () => null)
            : null;
        return BroadcastLink(
            type: type ?? BroadcastType.Other,
            link: link,
            imageUrl: banner
                .querySelector('img')
                ?.attributes['src']
                ?.toAbsolute(currentUrl));
      }).toList(),
      courses: await CourseScraper().scrape(this),
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
