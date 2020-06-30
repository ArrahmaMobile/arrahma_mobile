import 'package:flutter/material.dart';

class AdvTaleemmulQuran extends StatefulWidget {
  @override
  _AdvTaleemmulQuranState createState() => _AdvTaleemmulQuranState();
}

class _AdvTaleemmulQuranState extends State<AdvTaleemmulQuran> {
  int _currentIndex = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Adv Taleemmul Quran',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              title: Text('Details'),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            title: Text('Registration'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Tafseer'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Tajweed'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Tests'),
          ),
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
