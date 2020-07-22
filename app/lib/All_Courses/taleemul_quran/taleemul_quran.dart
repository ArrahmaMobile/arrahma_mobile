import 'package:arrahma_mobile_app/all_courses/quran_courses/models/course_registration.dart';
import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_details_tab/quran_details_tab.dart';
import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_registration_tab/quran_registration_tab.dart';
import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_tafseer_tab/quran_juz_page.dart';
import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_test_page/quran_test_page.dart';
import 'package:arrahma_mobile_app/all_courses/taleemul_quran/tajweed_tab/tajweed_tab.dart';
import 'package:arrahma_mobile_app/drawer/main_drawer.dart';
import 'package:flutter/material.dart';

class TaleemmulQuran extends StatefulWidget {
  @override
  _TaleemmulQuranState createState() => _TaleemmulQuranState();
}

class _TaleemmulQuranState extends State<TaleemmulQuran> {
  int _tabSelected = 2;

  final _pageSelected = [
    QuranDetailsTab(
      pdfUrl: '',
      title: '',
    ),
    QuranRegistrationTab(
      registration: CourseRegistration(),
      title: '',
    ),
    QuranTafseerTab(
      title: '',
    ),
    TaleemulTajweedTab(),
    QuranTestsPage(
      title: '',
    )
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
              'Registration',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
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
