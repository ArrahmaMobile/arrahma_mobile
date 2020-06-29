import 'package:flutter/material.dart';

import 'models/lectures_on_death.dart';

class LecturesOnDeath extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //AppBar -- Rending a navigation bae with title
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
            children: List<LectureOnDeaths>.filled(
              5,
              LectureOnDeaths(
                title: 'Will form',
                imageUrl: 'assets/images/lectures_on_deaths/will_form.jpg',
              ),
            ).map(_buildCourse).toList()),
      ),
    );
  }

  Widget _buildCourse(LectureOnDeaths course) {
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
