import 'package:flutter/material.dart';
import 'models/leture_list.dart';
// import 'Assorted_Lectures/assorted_lectures.dart';
// import 'Lectures_on_Death/lectures_on_deaths.dart';
// import 'Quran_Tafseer/quran_tafseer.dart';
// import 'Ramadan_Speical/ramadan_special.dart';
// import 'Speical_Series/special_series.dart';
// import 'Tazkeer/tazkeer.dart';
// import 'Weekly_Gems/weekly_gems.dart';
// import 'Wirasat_Course/wirasat_course.dart';
// import 'Youth_Course/youth_course.dart';
// import 'Pashto_Course/pashto_course.dart';

class Lectures extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //AppBar -- Rending a navigation bae with title
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
          _lectures.map((lecture) => _buildLeture(context, lecture)).toList(),
    );
  }

  final _lectures = [
    Leture(
      text: 'Pashto Course',
      icon: Icons.access_alarm,
    ),
    Leture(
      text: 'Pashto Course',
      icon: Icons.access_alarm,
    ),
    Leture(
      text: 'Pashto Course',
      icon: Icons.access_alarm,
    ),
    Leture(
      text: 'Pashto Course',
      icon: Icons.access_alarm,
    ),
    Leture(
      text: 'Pashto Course',
      icon: Icons.access_alarm,
    ),
    Leture(
      text: 'Pashto Course',
      icon: Icons.access_alarm,
    ),
    Leture(
      text: 'Pashto Course',
      icon: Icons.access_alarm,
    ),
    Leture(
      text: 'Pashto Course',
      icon: Icons.access_alarm,
    ),
    Leture(
      text: 'Pashto Course',
      icon: Icons.access_alarm,
    ),
    Leture(
      text: 'Pashto Course',
      icon: Icons.access_alarm,
    ),
    Leture(
      text: 'Pashto Course',
      icon: Icons.access_alarm,
    ),
  ];

  Widget _buildLeture(BuildContext context, Leture lecture) {
    return GestureDetector(
      onTap: () {},
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
