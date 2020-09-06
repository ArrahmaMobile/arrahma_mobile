import 'package:arrahma_shared/shared.dart';
import 'package:html2md/html2md.dart' as html2md;

import 'package:arrahma_shared/shared.dart';

import '../scraper_base.dart';

class QuranCourseRegistrationScraper
    implements ScraperBase<QuranCourseRegistration> {
  const QuranCourseRegistrationScraper(this.registrationUrl);

  final String registrationUrl;

  @override
  Future<QuranCourseRegistration> scrape(IScraper scraper) async {
    // final doc = await scraper.navigateTo(registrationUrl);
    // final bodyHtml = doc.querySelector('#main').outerHtml;
    // final bodyMarkdown = html2md.convert(bodyHtml,
    //     styleOptions: {'headingStyle': 'atx'}, ignore: ['script']);

    return null;
  }
}
