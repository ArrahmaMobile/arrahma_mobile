import 'package:arrahma_mobile_app/features/quran_course/quran_course_page.dart';
import 'package:arrahma_mobile_app/features/quran_course/quran_tafseer_tab/quran_surah_page/quran_lesson_page/quran_lesson_page.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';

class CourseItem extends StatelessWidget {
  const CourseItem({Key key, this.course}) : super(key: key);
  final Course course;

  @override
  Widget build(BuildContext context) {
    return _buildCourse(context, course);
  }

  Widget _buildCourse(BuildContext context, Course course) {
    return GestureDetector(
      onTap: () {
        if (course is QuranCourse)
          Navigator.push<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
                builder: (_) => course.lectures != null &&
                        course.lectures.surahs.length == 1
                    ? QuranLessonPage(
                        surah: course.lectures.surahs.first,
                        title: course.lectures.surahs.first.name,
                      )
                    : QuranCoursePage(
                        course: course,
                      )),
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
