import 'package:dart_json_mapper/dart_json_mapper.dart';

import '../surah.dart';

@jsonSerializable
class QuranCourseLectures {
  const QuranCourseLectures({required this.surahs});
  final List<Surah> surahs;
}
