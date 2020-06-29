import 'package:flutter/material.dart';

import 'models/course.dart';

class AllCourses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //AppBar -- Rending a navigation bae with title
        centerTitle: true,
        title: Text(
          'All Courses',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            shrinkWrap: true,
            childAspectRatio: .90,
            children: List<Course>.filled(
              12,
              Course(
                title: 'Adv Taleemul Quran',
                imageUrl: 'assets/images/courses/adv_taleemul_quran.png',
              ),
            ).map(_buildCourse).toList()),
      ),
    );
  }

  Widget _buildCourse(Course course) {
    return GestureDetector(
      child: Column(
        children: <Widget>[
          Image.asset(
            course.imageUrl,
            width: 100,
            height: 100,
          ),
          Text(
            course.title,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
