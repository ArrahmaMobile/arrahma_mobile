import 'package:arrahma_mobile_app/all_courses/quran_courses/models/course_registration.dart';
import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_tajweed_tab/model/quran_course_tafseer.dart';
import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_tajweed_tab/model/quran_course_tajweed.dart';
import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_tajweed_tab/model/quran_course_test.dart';

// import 'course_tafseer.dart';

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
