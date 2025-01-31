import 'package:arrahma_mobile_app/core/utils.dart';
import 'package:arrahma_mobile_app/features/course/course_view.dart';
import 'package:arrahma_mobile_app/features/quran_course/quran_course_view.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';
import 'package:recase/recase.dart';

class CourseItem extends StatefulWidget {
  const CourseItem({super.key, required this.course});
  final Course course;

  @override
  State<CourseItem> createState() => _CourseItemState();
}

class _CourseItemState extends State<CourseItem> {
  late ScreenUtils _screenUtils;

  @override
  Widget build(BuildContext context) {
    _screenUtils = ScreenUtils.getInstance(context)!;
    return _buildCourse(context, widget.course);
  }

  Widget _buildCourse(BuildContext context, Course course) {
    final isNetworkImage = course.imageUrl.startsWith('http');
    return GestureDetector(
      onTap: () {
        if (course is QuranCourse)
          Utils.pushView(
            context,
            QuranCourseView(
              course: course,
            ),
            title: course.title.titleCase,
          );
        if (course is QuranCourseGroup)
          Utils.pushView(
            context,
            CourseView(
              courses: course.courses,
            ),
            title: course.title.titleCase,
          );
        if (course is StaticQuranCourse) course.onTap();
      },
      child: Column(
        children: <Widget>[
          if (isNetworkImage)
            Image(
              image: ImageUtils.fromNetworkWithCached(
                course.imageUrl,
              ),
              width: _screenUtils.getWidth(80),
              height: _screenUtils.getWidth(80),
            )
          else
            Image.asset(
              course.imageUrl,
              width: _screenUtils.getWidth(68),
              height: _screenUtils.getWidth(68),
            ),
          Padding(
            padding: isNetworkImage
                ? EdgeInsets.zero
                : const EdgeInsets.only(top: 8.0),
            child: Text(
              course.title.titleCase,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: _screenUtils.getSp(14),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
