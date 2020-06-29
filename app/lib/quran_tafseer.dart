import 'package:flutter/material.dart';

class QuranTafseer extends StatefulWidget {
  @override
  _QuranTafseerState createState() => _QuranTafseerState();
}

class _QuranTafseerState extends State<QuranTafseer> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quran Tafseer',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xff124570),
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text(
                '2019 New Courses',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title:
                  Text('Tafseer-2013', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title:
                  Text('Tafseer-2007', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title:
                  Text('Ahsan-ul-Bayan', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Al-Furqan', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title:
                  Text('llm-yl-Uaqeen', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Al-Misbah', style: TextStyle(color: Colors.white)),
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
