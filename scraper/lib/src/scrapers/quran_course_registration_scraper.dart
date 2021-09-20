import 'package:arrahma_shared/shared.dart';

import '../scraper_base.dart';
import '../utils.dart';

class QuranCourseRegistrationScraper extends ScraperBase<MediaItem> {
  const QuranCourseRegistrationScraper(IScraper scraper, this.registrationUrl)
      : super(scraper);

  final String registrationUrl;

  @override
  Future<MediaItem> scrape() async {
    final doc = await scraper.navigateTo(registrationUrl);
    if (doc == null) return null;
    final url = scraper.currentUrl;
    final formContainer = doc.querySelector('#cus2');
    final formIframe = formContainer?.querySelector('iframe');
    final formSrc = formIframe != null
        ? formIframe.attributes['src'].toAbsolute(url)
        : null;

    return formSrc != null
        ? MediaItem(
            item: Utils.getItemByUrl(formSrc),
          )
        : null;
  }
}
