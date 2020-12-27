import 'package:arrahma_shared/shared.dart';

import '../scraper_base.dart';
import '../utils.dart';

class QuranCourseRegistrationScraper
    extends ScraperBase<QuranCourseRegistration> {
  const QuranCourseRegistrationScraper(IScraper scraper, this.registrationUrl)
      : super(scraper);

  final String registrationUrl;

  @override
  Future<QuranCourseRegistration> scrape() async {
    final doc = await scraper.navigateTo(registrationUrl);
    final url = scraper.currentUrl;
    final formContainer = doc.querySelector('#cus2');
    final formIframe = formContainer.querySelector('iframe');
    final formSrc = formIframe.attributes['src'].toAbsolute(url);

    return QuranCourseRegistration(
      type: RegistrationType.WebForm,
      url: formSrc,
    );
  }
}
