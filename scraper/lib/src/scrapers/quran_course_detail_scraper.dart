import 'package:html2md/html2md.dart' as html2md;

import 'package:arrahma_shared/shared.dart';

import '../scraper_base.dart';
import '../utils.dart';

class QuranCourseDetailScraper extends ScraperBase<MediaItem> {
  const QuranCourseDetailScraper(IScraper scraper, this.detailUrl)
      : super(scraper);

  final String detailUrl;

  @override
  Future<MediaItem> scrape() async {
    if (detailUrl.endsWith('pdf')) {
      return MediaItem(
        item: Utils.getItemByUrl(detailUrl),
      );
    }
    final doc = await scraper.navigateTo(detailUrl);
    if (doc == null) return null;
    final bodyHtml = doc.querySelector('#main').outerHtml;
    final bodyMarkdown = html2md.convert(bodyHtml,
        styleOptions: {'headingStyle': 'atx'}, ignore: ['script']);
    bodyMarkdown.replaceAll(RegExp(r'^\*\s+'), '* ');

    return MediaItem(
      item: Item(
        type: ItemType.Markdown,
        data: bodyMarkdown,
        isDirectSource: false,
        isExternal: false,
      ),
    );
  }
}
