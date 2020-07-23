// import 'course_tafseer.dart';

import 'course_registration.dart';
import 'quran_course_tafseer.dart';
import 'quran_course_tajweed.dart';
import 'quran_course_test.dart';

class QuranCourse {
  const QuranCourse(
      {this.title,
      this.courseDetailPdfUrl,
      this.registration,
      this.tafseer,
      this.tajweed,
      this.tests});
  final String title;
  final String courseDetailPdfUrl;
  final CourseRegistration registration;
  final List<QuranCourseTafseer> tafseer;
  final QuranCourseTajweed tajweed;
  final List<QuranCourseTest> tests;
  // final CourseTafseer tafseer;
}
