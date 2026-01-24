import 'package:dart_json_mapper/dart_json_mapper.dart';

import '../models.dart';

@jsonSerializable
class QuranCourse extends Course {
  const QuranCourse({
    required super.title,
    required super.imageUrl,
    required this.buttons,
    required this.sections,
  });

  final List<CourseButton> buttons;
  final List<CourseSection> sections;
}

@jsonSerializable
class QuranCourseGroup extends Course {
  const QuranCourseGroup({
    required super.title,
    required super.imageUrl,
    required this.courses,
  });
  final List<QuranCourse> courses;
}
