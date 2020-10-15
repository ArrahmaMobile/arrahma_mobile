// import 'course_tafseer.dart';

import 'package:arrahma_shared/src/models/quran_course/quran_course_content.dart';
import 'package:arrahma_shared/src/models/quran_course/quran_course_details.dart';

import 'quran_course_registration.dart';
import 'quran_course_test.dart';

abstract class Course {
  const Course({this.title, this.imageUrl});
  final String title;
  final String imageUrl;
}

class QuranCourse extends Course {
  const QuranCourse(
      {String title,
      String imageUrl,
      this.courseDetails,
      this.lectures,
      this.registration,
      this.tafseer,
      this.tajweed,
      this.tests})
      : super(title: title, imageUrl: imageUrl);
  final QuranCourseDetails courseDetails;
  final QuranCourseContent lectures;
  final QuranCourseRegistration registration;
  final QuranCourseContent tafseer;
  final QuranCourseContent tajweed;
  final List<QuranCourseTest> tests;
}
