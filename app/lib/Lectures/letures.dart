import 'package:arrahma_mobile_app/drawer/main_drawer.dart';
import 'package:flutter/material.dart';
import 'models/leture_list.dart';

class Lectures extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Lectures',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                _lecturesList(context),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _lecturesList(BuildContext context) {
    return GridView.count(
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 1.9,
      children:
          _lectures.map((lecture) => _buildLecture(context, lecture)).toList(),
    );
  }

  final _lectures = [
    Lecture(
      title: 'Quranic Tafseer',
      pageRoute: '/quran_tafseer',
    ),
    Lecture(
      title: 'Youth Courses',
      pageRoute: '/youth_course',
    ),
    Lecture(
      title: 'Tazkeer',
      pageRoute: '/tazkeer',
    ),
    Lecture(
      title: 'Wirasat Course',
      pageRoute: '/wirasat_course',
    ),
    Lecture(
      title: 'Weekly Gems',
      pageRoute: '/weekly_gems',
    ),
    Lecture(
      title: 'Assorted Lectures',
      pageRoute: '/assorted_lectures',
    ),
    Lecture(
      title: 'Ramadan Special',
      pageRoute: '/ramadan_special',
    ),
    Lecture(
      title: 'Special Series',
      pageRoute: '/speical_series',
    ),
    Lecture(
      title: 'Pashto Course',
      pageRoute: '/pashto_course',
    ),
    Lecture(
      title: 'Lectures on Death',
      pageRoute: '/lectures_on_death',
    ),
    Lecture(
      title: 'Lectures on Namaz',
      pageRoute: '/lecture_on_namaz',
    ),
  ];

  Widget _buildLecture(BuildContext context, Lecture lecture) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, lecture.pageRoute);
      },
      child: Container(
        color: Color(0xffdedbdb),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              lecture.title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
