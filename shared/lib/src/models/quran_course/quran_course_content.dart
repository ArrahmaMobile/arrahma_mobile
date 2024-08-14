import 'package:dart_json_mapper/dart_json_mapper.dart';

import '../models.dart';

@jsonSerializable
class QuranCourseContent {
  const QuranCourseContent({
    required this.id,
    required this.title,
    required this.surahs,
  });
  final String id;
  final String? title;
  final List<Surah> surahs;
}
