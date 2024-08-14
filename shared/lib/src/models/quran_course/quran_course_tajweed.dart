import 'package:dart_json_mapper/dart_json_mapper.dart';

import '../surah.dart';

@jsonSerializable
class QuranCourseTajweed {
  const QuranCourseTajweed({required this.introductionUrl, required this.items});
  final String introductionUrl;
  final List<QuranCourseTajweedItem> items;
}

@jsonSerializable
class QuranCourseTajweedItem {
  const QuranCourseTajweedItem({required this.title, required this.surahs});
  final String title;
  final List<Surah> surahs;
}
