import 'package:arrahma_mobile_app/features/course/course_item.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:inherited_state/inherited_state.dart';

class CourseView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appData = context.on<AppData>();
    return GridView.count(
      padding: const EdgeInsets.all(10.0),
      crossAxisCount: 3,
      crossAxisSpacing: 20,
      mainAxisSpacing: 8,
      shrinkWrap: true,
      childAspectRatio: .90,
      children: appData.courses.map((c) => CourseItem(course: c)).toList(),
    );
  }
}
