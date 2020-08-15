import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_details_tab/quran_details_tab.dart';
import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_registration_tab/quran_registration_tab.dart';
import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_tafseer_tab/quran_surah_page/quran_surah_page.dart';
import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_tajweed_tab/quran_tajweed_tab.dart';
import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_test_page/quran_test_page.dart';
import 'package:arrahma_mobile_app/drawer/main_drawer.dart';
import 'package:arrahma_models/models.dart';
import 'package:flutter/material.dart';

class QuranCoursePage extends StatefulWidget {
  const QuranCoursePage({
    Key key,
    @required this.title,
    @required this.course,
  }) : super(key: key);
  final QuranCourse course;
  final String title;

  @override
  _QuranCoursePageState createState() => _QuranCoursePageState();
}

class _QuranCoursePageState extends State<QuranCoursePage> {
  int _tabSelected = 2;

  Widget _getTab(int tabIndex) {
    final tabs = [
      QuranDetailsTab(
        title: widget.course.title,
      ),
      QuranRegistrationTab(
        registration: widget.course.registration,
        title: widget.course.title,
      ),
      QuranSurahPage(
        surahs: widget.course.tafseer.surahs,
      ),
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
        selectedItemColor: const Color(0xff124570),
        unselectedItemColor: Colors.black,
        currentIndex: _tabSelected,
        type: BottomNavigationBarType.fixed,
        items: [
          if (widget.course.courseDetailPdfUrl != null)
            const BottomNavigationBarItem(
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
            const BottomNavigationBarItem(
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
            const BottomNavigationBarItem(
              icon: Icon(
                Icons.book,
              ),
              title: Text(
                'Tafseer',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          if (widget.course.tajweed != null)
            const BottomNavigationBarItem(
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
            const BottomNavigationBarItem(
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
