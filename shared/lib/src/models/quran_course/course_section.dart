import 'package:dart_json_mapper/dart_json_mapper.dart';

import '../surah.dart';

@jsonSerializable
class CourseSection {
  const CourseSection({
    required this.label,
    this.icon,
    this.content,
  });

  final String label;
  final String? icon;
  final MediaContent? content; // For now, use MediaContent for all content types
}
