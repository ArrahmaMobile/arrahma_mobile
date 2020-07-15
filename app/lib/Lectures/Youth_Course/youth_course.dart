import 'package:arrahma_mobile_app/Lectures/Youth_Course/model/youth_course.dart';
import 'package:flutter/material.dart';

class YouthCourse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Youth Course',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            _lecturesList(context),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _lecturesList(BuildContext context) {
    return GridView.count(
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 1,
      children:
          _youthCourse.map((item) => _buildYouthCourse(context, item)).toList(),
    );
  }

  final _youthCourse = [
    YouthCourseItem(
      title: 'Dawra e Quran Eng.2019',
      pageRoute: '',
    ),
    YouthCourseItem(
      title: 'Ten Youth Issues',
      pageRoute: '',
    ),
    YouthCourseItem(
      title: 'Fiqh of Marriage',
      pageRoute: '',
    ),
    YouthCourseItem(
      title: 'Vision Series',
      pageRoute: '',
    )
  ];

  Widget _buildYouthCourse(BuildContext context, YouthCourseItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, item.pageRoute);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            item.title,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
