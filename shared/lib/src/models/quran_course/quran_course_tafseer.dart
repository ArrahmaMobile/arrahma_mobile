import 'package:dart_json_mapper/dart_json_mapper.dart';

import '../surah.dart';

@jsonSerializable
class QuranCourseTafseer {
  const QuranCourseTafseer({required this.title, required this.surahs});
  final String title;
  final List<Surah> surahs;
}
