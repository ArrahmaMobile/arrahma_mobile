import 'package:flutter/material.dart';

class GumnaamKiDiary extends StatefulWidget {
  @override
  _GumnaamKiDiaryState createState() => _GumnaamKiDiaryState();
}

class _GumnaamKiDiaryState extends State<GumnaamKiDiary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Gumnaam Ki Diary',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
}
