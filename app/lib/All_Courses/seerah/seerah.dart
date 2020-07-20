import 'package:arrahma_mobile_app/All_Courses/quran_courses/quran_details_tab/quran_details_tab.dart';
import 'package:arrahma_mobile_app/Our_Nabi/Seerah/seerah.dart';
import 'package:arrahma_mobile_app/drawer/main_drawer.dart';
import 'package:flutter/material.dart';

class SeerahCourse extends StatefulWidget {
  @override
  _SeerahCourseState createState() => _SeerahCourseState();
}

class _SeerahCourseState extends State<SeerahCourse> {
  int _tabSelected = 0;

  final _pageSelected = [
    QuranDetailsTab(),
    Seerah(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      body: _pageSelected[_tabSelected],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        currentIndex: _tabSelected,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.library_books,
            ),
            title: Text(
              'Details',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.book,
            ),
            title: Text(
              'Lectures',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
        onTap: (index) {
          setState(() {
            _tabSelected = index;
          });
        },
      ),
    );
  }
}
