import 'package:arrahma_mobile_app/All_Courses/quran_courses/quran_details_tab/quran_details_tab.dart';
import 'package:arrahma_mobile_app/All_Courses/quran_courses/quran_registration_tab/quran_registration_tab.dart';
import 'package:arrahma_mobile_app/All_Courses/quran_courses/quran_tafseer_tab/quran_tafseer_tab.dart';
import 'package:arrahma_mobile_app/All_Courses/quran_courses/quran_tajweed_tab/quran_tajweed_tab.dart';
import 'package:arrahma_mobile_app/All_Courses/quran_courses/quran_test_tab/quran_test_tab.dart';
import 'package:arrahma_mobile_app/All_Courses/quran_courses/models/quran_course.dart';
import 'package:arrahma_mobile_app/Drawer/main_drawer.dart';
import 'package:flutter/material.dart';

class QuranCoursePage extends StatefulWidget {
  const QuranCoursePage({Key key, this.course}) : super(key: key);
  final QuranCourse course;

  @override
  _QuranCoursePageState createState() => _QuranCoursePageState();
}

class _QuranCoursePageState extends State<QuranCoursePage> {
  int _tabSelected = 2;

  Widget _getTab(int tabIndex) {
    final tabs = [
      QuranDetailsTab(
          title: widget.course.title, pdfUrl: widget.course.courseDetailPdfUrl),
      QuranRegistrationTab(
        registration: widget.course.registration,
        title: widget.course.title,
      ),
      QuranTafseerTab(title: widget.course.title),
      QuranTajweedTab(
        title: widget.course.title,
        items: widget.course.tajweed,
      ),
      QuranTestsTab(
        title: widget.course.title,
      )
    ];
    return tabs[tabIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      body: _getTab(_tabSelected),
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
              'Registration',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            title: Text(
              'Tafseer',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            title: Text(
              'Tajweed',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            title: Text(
              'Tests',
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
