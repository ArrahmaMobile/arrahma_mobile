import 'package:flutter/material.dart';

class PashtoCourse extends StatefulWidget {
  @override
  _PashtoCourseState createState() => _PashtoCourseState();
}

class _PashtoCourseState extends State<PashtoCourse> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Speical Series',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Quran Tafseer 2019'),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Selected Surahs'),
              backgroundColor: Colors.blue),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
