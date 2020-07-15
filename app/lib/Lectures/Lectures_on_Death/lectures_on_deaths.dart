import 'package:flutter/material.dart';

import 'models/lectures_on_death.dart';

class LecturesOnDeath extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Lectures on Deaths',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            shrinkWrap: true,
            childAspectRatio: .90,
            children: _course
                .map((course) => _buildCourse(context, course))
                .toList()),
      ),
    );
  }

  final _course = [
    LectureOnDeaths(
      title: 'Will Form',
      imageUrl: 'assets/images/lectures_on_deaths/will_form.jpg',
      pageRoute: '',
    ),
    LectureOnDeaths(
      title: 'Dua For Janaza',
      imageUrl: 'assets/images/lectures_on_deaths/dua_for_janaza.jpg',
      pageRoute: '',
    ),
    LectureOnDeaths(
      title: 'Audio Lecture',
      imageUrl: 'assets/images/lectures_on_deaths/audio_lecture.jpeg',
      pageRoute: '',
    ),
    LectureOnDeaths(
      title: 'Ghusl After Death',
      imageUrl: 'assets/images/lectures_on_deaths/ghusl_after_death.jpg',
      pageRoute: '',
    ),
    LectureOnDeaths(
      title: 'Kafan',
      imageUrl: 'assets/images/lectures_on_deaths/kafan.jpg',
      pageRoute: '',
    ),
  ];

  Widget _buildCourse(BuildContext context, LectureOnDeaths course) {
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
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
