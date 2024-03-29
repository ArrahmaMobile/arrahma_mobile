// import 'course_tafseer.dart';

import 'package:simple_json_mapper/simple_json_mapper.dart';

import '../models.dart';
import 'course.dart';
import 'quran_course_registration.dart';

@JObj()
class QuranCourseV1 extends Course {
  const QuranCourseV1({
    String title,
    String imageUrl,
    this.courseDetails,
    this.lectures,
    this.registration,
    this.tafseer,
    this.tajweed,
    this.tests,
    this.otherContent,
  }) : super(title: title, imageUrl: imageUrl);
  final QuranCourseDetails courseDetails;
  final QuranCourseContent lectures;
  final QuranCourseRegistration registration;
  final QuranCourseContent tafseer;
  final QuranCourseContent tajweed;
  final MediaContent tests;
  final MediaContent otherContent;
}
