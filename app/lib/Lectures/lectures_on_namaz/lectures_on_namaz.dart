import 'package:flutter/material.dart';

class LecturesOnNamaz extends StatefulWidget {
  @override
  _LecturesOnNamazState createState() => _LecturesOnNamazState();
}

class _LecturesOnNamazState extends State<LecturesOnNamaz> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Lectures on Namaz',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
}
