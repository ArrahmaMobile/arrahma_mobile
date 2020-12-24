import 'package:arrahma_mobile_app/features/course/course_item.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';

class CourseView extends StatelessWidget {
  const CourseView({Key key, @required this.courses}) : super(key: key);
  final List<Course> courses;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(10.0),
      crossAxisCount: 3,
      crossAxisSpacing: 20,
      mainAxisSpacing: 8,
      shrinkWrap: true,
      childAspectRatio: .90,
      children: courses.map((c) => CourseItem(course: c)).toList(),
    );
  }
}
