import 'package:flutter/material.dart';

class TaleemmulQuran extends StatefulWidget {
  @override
  _TaleemmulQuranState createState() => _TaleemmulQuranState();
}

class _TaleemmulQuranState extends State<TaleemmulQuran> {
  int _currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Adv Taleemmul Quran',
              style: TextStyle(color: Colors.black),
            ),
            bottom: TabBar(tabs: <Widget>[
              Tab(
                text: 'Juz',
              ),
              Tab(
                text: 'Surah',
              ),
            ]),
          ),
          body: TabBarView(children: <Widget>[
            Center(
              child: Icon(Icons.access_alarms),
            ),
            Center(
              child: Icon(Icons.accessible),
            )
          ]),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.library_books),
                title: Text('Details'),
              ),
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
        ),
      ),
    );
  }
}
