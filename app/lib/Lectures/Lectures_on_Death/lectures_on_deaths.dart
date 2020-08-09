import 'package:flutter/material.dart';

import 'models/lectures_on_death.dart';

class LecturesOnDeath extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff124570),
        centerTitle: true,
        title: Text(
          'Lectures on Deaths',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            shrinkWrap: true,
            childAspectRatio: 1.4,
            children: _course
                .map((course) => _buildCourse(context, course))
                .toList()),
      ),
    );
  }

  final _course = [
    const LectureOnDeaths(
      title: 'Will Form',
      image: 'assets/images/lectures_on_deaths/will_form.jpg',
      imageUrl: '/lectures_on_death',
    ),
    const LectureOnDeaths(
      title: 'Dua For Janaza',
      image: 'assets/images/lectures_on_deaths/dua_for_janaza.jpg',
      imageUrl: '/lectures_on_death',
    ),
    const LectureOnDeaths(
      title: 'Audio Lecture',
      image: 'assets/images/lectures_on_deaths/audio_lecture.jpeg',
      imageUrl: '/lectures_on_death',
    ),
    const LectureOnDeaths(
      title: 'Ghusl After Death',
      image: 'assets/images/lectures_on_deaths/ghusl_after_death.jpg',
      imageUrl: '/lectures_on_death',
    ),
    const LectureOnDeaths(
      title: 'Kafan',
      image: 'assets/images/lectures_on_deaths/kafan.jpg',
      imageUrl: '/lectures_on_death',
    ),
  ];

  Widget _buildCourse(BuildContext context, LectureOnDeaths course) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, course.imageUrl);
      },
      child: Container(
        color: const Color(0xff124570),
        child: Column(
          children: <Widget>[
            Image.asset(
              course.image,
              width: 100,
              height: 100,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              course.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
