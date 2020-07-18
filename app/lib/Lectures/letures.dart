import 'package:arrahma_mobile_app/Drawer/main_drawer.dart';
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
      text: 'Quranic Tafseer',
      pageRoute: '/quran_tafseer',
    ),
    Lecture(
      text: 'Youth Courses',
      pageRoute: '/youth_course',
    ),
    Lecture(
      text: 'Tazkeer',
      pageRoute: '/tazkeer',
    ),
    Lecture(
      text: 'Wirasat Course',
      pageRoute: '/wirasat_course',
    ),
    Lecture(
      text: 'Weekly Gems',
      pageRoute: '/weekly_gems',
    ),
    Lecture(
      text: 'Assorted Lectures',
      pageRoute: '/assorted_lectures',
    ),
    Lecture(
      text: 'Ramadan Special',
      pageRoute: '/ramadan_special',
    ),
    Lecture(
      text: 'Special Series',
      pageRoute: '/speical_series',
    ),
    Lecture(
      text: 'Pashto Course',
      pageRoute: '/pashto_course',
    ),
    Lecture(
      text: 'Lectures on Death',
      pageRoute: '/lectures_on_death',
    ),
    Lecture(
      text: 'Lectures on Namaz',
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
              lecture.text,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
