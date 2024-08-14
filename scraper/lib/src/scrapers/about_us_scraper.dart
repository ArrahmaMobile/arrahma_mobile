import 'package:html2md/html2md.dart' as html2md;

import '../scraper_base.dart';
import 'package:collection/collection.dart';
import '../utils.dart';

class AboutUsScraper extends ScraperBase<String> {
  const AboutUsScraper(IScraper scraper) : super(scraper);

  @override
  Future<String?> scrape() async {
    final homeDoc = await scraper.navigateTo('');
    if (homeDoc == null) return null;
    final aboutUsUrl = homeDoc
        .querySelectorAll('#container_nav #nav > li > a')
        .firstWhereOrNull(
            (e) => e.text.toLowerCase() == 'About Us'.toLowerCase())
        ?.attributes['href']
        ?.toAbsolute(scraper.baseUrl);
    if (aboutUsUrl == null) return null;
    final doc = await scraper.navigateTo(aboutUsUrl);
    if (doc == null) return null;
    final content = doc.querySelector('#aboutuscontent')?.outerHtml;
    if (content == null) return null;
    final contentMarkdown = html2md.convert(content);
    return contentMarkdown;
  }
}
