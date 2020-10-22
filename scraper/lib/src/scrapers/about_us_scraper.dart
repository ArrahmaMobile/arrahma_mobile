import 'package:html2md/html2md.dart' as html2md;

import '../scraper_base.dart';
import '../utils.dart';

class AboutUsScraper extends ScraperBase<String> {
  const AboutUsScraper(IScraper scraper) : super(scraper);

  @override
  Future<String> scrape() async {
    final aboutUsUrl = scraper.document
        .querySelectorAll('.container_nav .nav > li > a')
        .firstWhere((e) => e.text.toLowerCase() == 'About Us'.toLowerCase(),
            orElse: () => null)
        .attributes['href']
        .toAbsolute(scraper.currentUrl);
    final doc = await scraper.navigateTo(aboutUsUrl);
    final content = doc.querySelector('#aboutuscontent').outerHtml;
    final contentMarkdown = html2md.convert(content);
    return contentMarkdown;
  }
}
