import 'package:flutter/material.dart';

class SpecialSeries extends StatefulWidget {
  @override
  _SpecialSeriesState createState() => _SpecialSeriesState();
}

class _SpecialSeriesState extends State<SpecialSeries> {
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
              title: Text('Gumnaam Ki Diary'),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Medan-Mehshar Me Meri Kahani'),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Meri Aakhari Saansain'),
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Asma ul Husna'),
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
