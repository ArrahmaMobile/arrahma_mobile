import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_course_page.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';

class CourseItem extends StatelessWidget {
  const CourseItem({Key key, this.course}) : super(key: key);
  final QuranCourse course;

  @override
  Widget build(BuildContext context) {
    return _buildCourse(context, course);
  }

  Widget _buildCourse(BuildContext context, QuranCourse course) {
    return GestureDetector(
      onTap: () {
        Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (_) => QuranCoursePage(
              course: course,
            ),
          ),
        );
      },
      child: Column(
        children: <Widget>[
          if (course.imageUrl.startsWith('http'))
            Image(
              image: ImageUtils.fromNetworkWithCached(
                course.imageUrl,
              ),
              width: 80,
              height: 80,
            )
          else
            Image.asset(
              course.imageUrl,
              width: 80,
              height: 80,
            ),
          Text(
            course.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
