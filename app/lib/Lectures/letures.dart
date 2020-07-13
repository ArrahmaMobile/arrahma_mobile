import 'package:flutter/material.dart';
import 'models/leture_list.dart';

class Lectures extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          'Lectures',
          style: TextStyle(color: Colors.white),
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
      icon: Icons.access_alarm,
      pageRoute: '/quran_tafseer',
    ),
    Lecture(
      text: 'Youth Courses',
      icon: Icons.access_alarm,
      pageRoute: '/youth_course',
    ),
    Lecture(
      text: 'Tazkeer',
      icon: Icons.access_alarm,
      pageRoute: '/tazkeer',
    ),
    Lecture(
      text: 'Wirasat Course',
      icon: Icons.access_alarm,
      pageRoute: '/wirasat_course',
    ),
    Lecture(
      text: 'Weekly Gems',
      icon: Icons.access_alarm,
      pageRoute: '/weekly_gems',
    ),
    Lecture(
      text: 'Assorted Lectures',
      icon: Icons.access_alarm,
      pageRoute: '/assorted_lectures',
    ),
    Lecture(
      text: 'Ramadan Special',
      icon: Icons.access_alarm,
      pageRoute: '/ramadan_special',
    ),
    Lecture(
      text: 'Special Series',
      icon: Icons.access_alarm,
      pageRoute: '/speical_series',
    ),
    Lecture(
      text: 'Pashto Course',
      icon: Icons.access_alarm,
      pageRoute: '/pashto_course',
    ),
    Lecture(
      text: 'Lectures on Death',
      icon: Icons.access_alarm,
      pageRoute: '/lectures_on_death',
    ),
    Lecture(
      text: 'Lectures on Namaz',
      icon: Icons.access_alarm,
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
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            Icon(
              lecture.icon,
              size: 50,
            ),
          ],
        ),
      ),
    );
  }
}
