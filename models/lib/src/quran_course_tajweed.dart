import 'package:arrahma_mobile_app/all_courses/quran_courses/models/surah.dart';

class QuranCourseTajweed {
  const QuranCourseTajweed({this.introductionUrl, this.items});
  final String introductionUrl;
  final List<QuranCourseTajweedItem> items;
}

class QuranCourseTajweedItem {
  const QuranCourseTajweedItem({this.title, this.surahs});
  final String title;
  final List<Surah> surahs;
}
