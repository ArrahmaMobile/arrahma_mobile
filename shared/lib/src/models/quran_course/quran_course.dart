// import 'course_tafseer.dart';

import 'package:dart_json_mapper/dart_json_mapper.dart';

import '../models.dart';
import 'course.dart';
import 'quran_course_registration.dart';

@jsonSerializable
class QuranCourseV1 extends Course {
  const QuranCourseV1({
    required super.title,
    required super.imageUrl,
    required this.courseDetails,
    required this.lectures,
    required this.registration,
    required this.tafseer,
    required this.tajweed,
    required this.tests,
    required this.otherContent,
  });
  final QuranCourseDetails? courseDetails;
  final QuranCourseContent? lectures;
  final QuranCourseRegistration? registration;
  final QuranCourseContent? tafseer;
  final QuranCourseContent? tajweed;
  final MediaContent? tests;
  final MediaContent? otherContent;
}
