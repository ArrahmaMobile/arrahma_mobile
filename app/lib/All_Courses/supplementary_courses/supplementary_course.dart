import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_details_tab/quran_details_tab.dart';
import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_tafseer_tab/quran_surah_page/quran_surah_page.dart';
import 'package:arrahma_mobile_app/drawer/main_drawer.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';

class SupplementaryCourse extends StatefulWidget {
  const SupplementaryCourse({
    Key key,
    @required this.course,
    @required this.title,
  }) : super(key: key);
  final QuranCourse course;
  final String title;

  @override
  _SupplementaryCourseState createState() => _SupplementaryCourseState();
}

class _SupplementaryCourseState extends State<SupplementaryCourse> {
  int _tabSelected = 0;

  Widget _getTab(int tabIndex) {
    final tabs = [
      const QuranDetailsTab(
        title: 'widget.course.title',
      ),
      const QuranSurahPage(surahs: []),
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
          const BottomNavigationBarItem(
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
