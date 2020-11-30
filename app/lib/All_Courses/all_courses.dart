import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_course_page.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';
import 'package:inherited_state/inherited_state.dart';

class AllCourses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appData = context.on<AppData>();
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff124570),
        centerTitle: true,
        title: const Text(
          'All Courses',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(10.0),
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 8,
        shrinkWrap: true,
        childAspectRatio: .90,
        children: appData.courses
            .map((course) => _buildCourse(context, course))
            .toList(),
      ),
    );
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
