import 'package:dart_json_mapper/dart_json_mapper.dart';

import '../surah.dart';
import 'quran_course_content.dart';

@jsonSerializable
class CourseSection {
  const CourseSection({
    required this.label,
    this.icon,
    this.mediaContent,
    this.courseContent,
  });

  final String label;
  final String? icon;
  final MediaContent? mediaContent; // For simple link lists (Tafseer PDFs, Tests, etc.)
  final QuranCourseContent? courseContent; // For full Quran course content with surahs

  // Helper to get content regardless of type
  bool get hasContent => mediaContent != null || courseContent != null;
}
