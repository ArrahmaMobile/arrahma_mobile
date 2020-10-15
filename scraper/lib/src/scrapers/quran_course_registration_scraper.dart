import 'package:arrahma_shared/shared.dart';
import 'package:html2md/html2md.dart' as html2md;

import 'package:arrahma_shared/shared.dart';

import '../scraper_base.dart';

class QuranCourseRegistrationScraper
    extends ScraperBase<QuranCourseRegistration> {
  const QuranCourseRegistrationScraper(IScraper scraper, this.registrationUrl)
      : super(scraper);

  final String registrationUrl;

  @override
  Future<QuranCourseRegistration> scrape() async {
    // final doc = await scraper.navigateTo(registrationUrl);
    // final bodyHtml = doc.querySelector('#main').outerHtml;
    // final bodyMarkdown = html2md.convert(bodyHtml,
    //     styleOptions: {'headingStyle': 'atx'}, ignore: ['script']);

    return null;
  }
}
