import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_details_tab/quran_details_tab.dart';
import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_registration_tab/quran_registration_tab.dart';
import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_tafseer_tab/quran_juz_page.dart';
import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_tajweed_tab/quran_tajweed_tab.dart';
import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_test_page/quran_test_page.dart';
import 'package:arrahma_mobile_app/drawer/main_drawer.dart';
import 'package:arrahma_models/models.dart';
import 'package:flutter/material.dart';

class QuranCoursePage extends StatefulWidget {
  const QuranCoursePage({Key key, @required this.course}) : super(key: key);
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
        tajweed: widget.course.tajweed,
      ),
      QuranTestsPage(
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
        selectedItemColor: Colors.black,
        currentIndex: _tabSelected,
        type: BottomNavigationBarType.fixed,
        items: [
          if (widget.course.courseDetailPdfUrl != null)
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
          if (widget.course.courseDetailPdfUrl != null)
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
          if (widget.course.registration != null)
            BottomNavigationBarItem(
              icon: Icon(
                Icons.book,
              ),
              title: Text(
                'Registration',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          if (widget.course.tafseer != null)
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              title: Text(
                'Tafseer',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          if (widget.course.tajweed != null)
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              title: Text(
                'Tajweed',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          if (widget.course.tests != null)
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
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
