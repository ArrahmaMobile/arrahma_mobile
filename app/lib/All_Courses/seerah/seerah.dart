import 'package:arrahma_mobile_app/All_Courses/adv_taleemul_quran/details_tab/adv_taleemul_details_tab.dart';
import 'package:arrahma_mobile_app/Drawer/main_drawer.dart';
import 'package:flutter/material.dart';

import 'lecture_tab/lecture_tab.dart';

class SeerahCourse extends StatefulWidget {
  @override
  _SeerahCourseState createState() => _SeerahCourseState();
}

class _SeerahCourseState extends State<SeerahCourse> {
  int _tabSelected = 0;

  final _pageSelected = [
    AdvTaleemmulQuranDetailsTab(),
    LectureTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      body: _pageSelected[_tabSelected],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabSelected,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.library_books,
              color: Colors.black,
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
              color: Colors.black,
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
