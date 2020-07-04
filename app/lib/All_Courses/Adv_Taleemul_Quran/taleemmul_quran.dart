import 'package:arrahma_mobile_app/Drawer/main_drawer.dart';
import 'package:flutter/material.dart';

import 'Detail_Tab/details_page.dart';
import 'Registration_Tab/registration_page.dart';
import 'Tafseer_Tab/tafseer_page.dart';
import 'Tajweed_Tab/tajweed_page.dart';
import 'Tests_Tab/tests_page.dart';

class TaleemmulQuran extends StatefulWidget {
  @override
  _TaleemmulQuranState createState() => _TaleemmulQuranState();
}

class _TaleemmulQuranState extends State<TaleemmulQuran> {
  int _tabSelected = 2;

  final _pageSelected = [
    DetailsPage(),
    RegistrationPage(),
    TafseerPage(),
    TajweedPage(),
    TestsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: MainDrawer(),
          body: _pageSelected[_tabSelected],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _tabSelected,
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
                _tabSelected = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
