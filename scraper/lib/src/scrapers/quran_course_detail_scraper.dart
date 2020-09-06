import 'package:html2md/html2md.dart' as html2md;

import 'package:arrahma_shared/shared.dart';

import '../scraper_base.dart';

class QuranCourseDetailScraper implements ScraperBase<QuranCourseDetails> {
  const QuranCourseDetailScraper(this.detailUrl);

  final String detailUrl;

  @override
  Future<QuranCourseDetails> scrape(IScraper scraper) async {
    if (detailUrl.endsWith('pdf')) {
      return QuranCourseDetails(
        type: QuranCourseDetailsType.Pdf,
        details: detailUrl,
      );
    }
    final doc = await scraper.navigateTo(detailUrl);
    if (doc == null) return null;
    final bodyHtml = doc.querySelector('#main').outerHtml;
    final bodyMarkdown = html2md.convert(bodyHtml,
        styleOptions: {'headingStyle': 'atx'}, ignore: ['script']);

    return QuranCourseDetails(
      type: QuranCourseDetailsType.Markdown,
      details: bodyMarkdown,
    );
  }
}
