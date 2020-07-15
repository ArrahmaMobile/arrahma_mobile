import 'package:flutter/material.dart';

class WeeklyGemsCourse extends StatefulWidget {
  @override
  _WeeklyGemsCourseState createState() => _WeeklyGemsCourseState();
}

class _WeeklyGemsCourseState extends State<WeeklyGemsCourse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Lectures',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
