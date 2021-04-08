import 'package:arrahma_mobile_app/core/utils.dart';
import 'package:arrahma_mobile_app/features/quran_course/quran_course_view.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';
import 'package:recase/recase.dart';

class CourseItem extends StatelessWidget {
  CourseItem({Key key, this.course}) : super(key: key);
  final Course course;

  ScreenUtils _screenUtils;

  @override
  Widget build(BuildContext context) {
    _screenUtils = ScreenUtils.getInstance(context);
    return _buildCourse(context, course);
  }

  Widget _buildCourse(BuildContext context, Course course) {
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
        else if (course is StaticQuranCourse) course.onTap();
      },
      child: Column(
        children: <Widget>[
          if (course.imageUrl.startsWith('http'))
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
              width: _screenUtils.getWidth(80),
              height: _screenUtils.getWidth(80),
            ),
          Text(
            course.title.titleCase,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: _screenUtils.getSp(14),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
