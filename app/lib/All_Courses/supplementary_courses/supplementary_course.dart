import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_details_tab/quran_details_tab.dart';
import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_tafseer_tab/quran_surah_page/quran_surah_page.dart';
import 'package:arrahma_mobile_app/drawer/main_drawer.dart';
import 'package:arrahma_models/models.dart';
import 'package:flutter/material.dart';

class SupplementaryCourse extends StatefulWidget {
  const SupplementaryCourse({Key key, @required this.course}) : super(key: key);
  final QuranCourse course;

  @override
  _SupplementaryCourseState createState() => _SupplementaryCourseState();
}

class _SupplementaryCourseState extends State<SupplementaryCourse> {
  int _tabSelected = 0;

  final _pageSelected = [
    const QuranDetailsTab(
      title: 'Course Detail',
    ),
    const QuranSurahPage(
      surahs: [],
    ),
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
