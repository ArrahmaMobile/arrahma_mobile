import 'package:arrahma_mobile_app/All_Courses/quran_courses/quran_details_tab/quran_details_tab.dart';
import 'package:arrahma_mobile_app/All_Courses/quran_courses/quran_registration_tab/quran_registration_tab.dart';
import 'package:arrahma_mobile_app/All_Courses/quran_courses/quran_tafseer_tab/quran_tafseer_tab.dart';
import 'package:arrahma_mobile_app/All_Courses/quran_courses/quran_tajweed_tab/quran_tajweed_tab.dart';
import 'package:arrahma_mobile_app/All_Courses/quran_courses/quran_test_page/quran_test_page.dart';
import 'package:arrahma_mobile_app/drawer/main_drawer.dart';
import 'package:flutter/material.dart';

class CourseInPashtu extends StatefulWidget {
  @override
  _CourseInPashtuState createState() => _CourseInPashtuState();
}

class _CourseInPashtuState extends State<CourseInPashtu> {
  int _tabSelected = 2;

  final _pageSelected = [
    QuranDetailsTab(),
    QuranRegistrationTab(),
    QuranTafseerTab(),
    QuranTajweedTab(),
    QuranTestsPage()
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
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.book,
            ),
            title: Text(
              'Registration',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            title: Text(
              'Tafseer',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            title: Text(
              'Tajweed',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            title: Text(
              'Tests',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
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
