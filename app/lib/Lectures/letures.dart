import 'package:arrahma_mobile_app/drawer/main_drawer.dart';
import 'package:flutter/material.dart';
import 'models/leture_list.dart';

class Lectures extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff124570),
        centerTitle: true,
        title: Text(
          'Lectures',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
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
    const Lecture(
      title: 'Quranic Tafseer',
      pageRoute: '/quran_tafseer',
    ),
    const Lecture(
      title: 'Youth Courses',
      pageRoute: '/youth_course',
    ),
    const Lecture(
      title: 'Tazkeer',
      pageRoute: '/tazkeer',
    ),
    const Lecture(
      title: 'Wirasat Course',
      pageRoute: '/wirasat_course',
    ),
    const Lecture(
      title: 'Weekly Gems',
      pageRoute: '/weekly_gems',
    ),
    const Lecture(
      title: 'Assorted Lectures',
      pageRoute: '/assorted_lectures',
    ),
    const Lecture(
      title: 'Ramadan Special',
      pageRoute: '/ramadan_special',
    ),
    const Lecture(
      title: 'Special Series',
      pageRoute: '/speical_series',
    ),
    const Lecture(
      title: 'Pashto Course',
      pageRoute: '/pashto_course',
    ),
    const Lecture(
      title: 'Lectures on Death',
      pageRoute: '/lectures_on_death',
    ),
    const Lecture(
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
        color: const Color(0xff124570),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              lecture.title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
