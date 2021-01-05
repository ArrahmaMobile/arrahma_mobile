// import 'package:arrahma_shared/shared.dart';

// import '../scraper_base.dart';
// import '../utils.dart';

// class ReadingMaterialScraper extends ScraperBase<QuranCourseContent> {
//   const ReadingMaterialScraper(IScraper scraper, this.url) : super(scraper);

//   final String url;

//   @override
//   Future<QuranCourseContent> scrape() async {
//     final doc = await scraper.navigateTo(url);

//     final content = QuranCourseContent(
//       id: url,
//       title:
//           doc.querySelector('#studentportion #studentheading').text.cleanedText,
//       surahs: [
//         Surah(
//           lessons: [],
//         ),
//       ],
//     );

//     doc
//         .querySelectorAll('#studentportion #studentpresentation div')
//         .forEach((d) {
//           if ([''].any((element) => false))
//         });
//   }
// }
