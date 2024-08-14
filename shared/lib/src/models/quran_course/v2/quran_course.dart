// import 'course_tafseer.dart';

import 'package:dart_json_mapper/dart_json_mapper.dart';

import '../../models.dart';
import '../course.dart';

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
