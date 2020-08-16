import 'package:arrahma_mobile_app/all_courses/assorted_lectures/model/assorted_lecture.dart';

class AssortedLectureCategoryItem {
  const AssortedLectureCategoryItem({this.title, this.lectures});
  final String title;
  final List<AssortedLecture> lectures;
}
