import 'package:dart_json_mapper/dart_json_mapper.dart';

import '../../models.dart';

@jsonSerializable
class QuranCourse extends Course {
  const QuranCourse({
    required super.title,
    required super.imageUrl,
    this.courseDetails,
    required this.lectures,
    this.registration,
    this.tafseer,
    this.tajweed,
    this.tests,
    this.otherContent,
  });
  final MediaContent? courseDetails;
  final MediaContent? registration;
  final QuranCourseContent? tafseer;
  final QuranCourseContent? tajweed;
  final QuranCourseContent? lectures;
  final MediaContent? tests;
  final MediaContent? otherContent;
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
