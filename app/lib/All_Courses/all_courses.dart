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
          children:
              _courses.map((course) => _buildCourse(context, course)).toList(),
        ),
      ),
    );
  }

  final _courses = [
    Course(
        title: 'Adv Taleemul Quran',
        imageUrl: 'assets/images/courses/adv_taleemul_quran.png',
        pageRoute: '/taleemmul-quran'),
    Course(
        title: 'Adv Taleemul Quran',
        imageUrl: 'assets/images/courses/adv_taleemul_quran.png',
        pageRoute: '/taleemmul-quran'),
    Course(
        title: 'Adv Taleemul Quran',
        imageUrl: 'assets/images/courses/adv_taleemul_quran.png',
        pageRoute: '/taleemmul-quran'),
    Course(
        title: 'Adv Taleemul Quran',
        imageUrl: 'assets/images/courses/adv_taleemul_quran.png',
        pageRoute: '/taleemmul-quran'),
    Course(
        title: 'Adv Taleemul Quran',
        imageUrl: 'assets/images/courses/adv_taleemul_quran.png',
        pageRoute: '/taleemmul-quran'),
    Course(
        title: 'Adv Taleemul Quran',
        imageUrl: 'assets/images/courses/adv_taleemul_quran.png',
        pageRoute: '/taleemmul-quran'),
    Course(
        title: 'Adv Taleemul Quran',
        imageUrl: 'assets/images/courses/adv_taleemul_quran.png',
        pageRoute: '/taleemmul-quran'),
    Course(
        title: 'Adv Taleemul Quran',
        imageUrl: 'assets/images/courses/adv_taleemul_quran.png',
        pageRoute: '/taleemmul-quran'),
    Course(
        title: 'Adv Taleemul Quran',
        imageUrl: 'assets/images/courses/adv_taleemul_quran.png',
        pageRoute: '/taleemmul-quran'),
    Course(
        title: 'Adv Taleemul Quran',
        imageUrl: 'assets/images/courses/adv_taleemul_quran.png',
        pageRoute: '/taleemmul-quran'),
    Course(
        title: 'Adv Taleemul Quran',
        imageUrl: 'assets/images/courses/adv_taleemul_quran.png',
        pageRoute: '/taleemmul-quran'),
  ];

  Widget _buildCourse(BuildContext context, Course course) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, course.pageRoute);
      },
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
