// import 'course_tafseer.dart';

import 'package:simple_json_mapper/simple_json_mapper.dart';

import '../../models.dart';
import '../course.dart';

@JObj()
class QuranCourse extends Course {
  const QuranCourse({
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
  final MediaContent courseDetails;
  final MediaContent registration;
  final QuranCourseContent tafseer;
  final QuranCourseContent tajweed;
  final QuranCourseContent lectures;
  final MediaContent tests;
  final MediaContent otherContent;
}
