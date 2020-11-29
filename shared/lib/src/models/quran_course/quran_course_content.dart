import 'package:arrahma_shared/src/models/models.dart';

class QuranCourseContent {
  const QuranCourseContent({
    this.id,
    this.title,
    this.surahs,
  });
  final String id;
  final String title;
  final List<Surah> surahs;
}
