// import 'course_tafseer.dart';

import 'course_registration.dart';
import 'quran_course_lectures.dart';
import 'quran_course_tafseer.dart';
import 'quran_course_tajweed.dart';
import 'quran_course_test.dart';

class Course {
  const Course({this.title, this.imageUrl});
  final String title;
  final String imageUrl;
}

class QuranCourse extends Course {
  const QuranCourse(
      {String title,
      String imageUrl,
      this.courseDetailPdfUrl,
      this.lectures,
      this.registration,
      this.tafseer,
      this.tajweed,
      this.tests})
      : super(title: title, imageUrl: imageUrl);
  final String courseDetailPdfUrl;
  final QuranCourseLectures lectures;
  final CourseRegistration registration;
  final QuranCourseTafseer tafseer;
  final QuranCourseTajweed tajweed;
  final List<QuranCourseTest> tests;
  // final CourseTafseer tafseer;
}
