import 'package:arrahma_mobile_app/All_Courses/quran_courses/quran_details_tab/quran_details_tab.dart';
import 'package:arrahma_mobile_app/All_Courses/quran_courses/quran_registration_tab/quran_registration_tab.dart';
import 'package:arrahma_mobile_app/All_Courses/quran_courses/quran_tafseer_tab/quran_tafseer_tab.dart';
import 'package:arrahma_mobile_app/All_Courses/quran_courses/quran_test_tab/quran_test_tab.dart';
import 'package:arrahma_mobile_app/Drawer/main_drawer.dart';
import 'package:flutter/material.dart';

import 'fehmul_tajweed_tab/fehmul_tajweed_tab.dart';

class FehmulQuran extends StatefulWidget {
  @override
  _FehmulQuranState createState() => _FehmulQuranState();
}

class _FehmulQuranState extends State<FehmulQuran> {
  int _tabSelected = 2;

  final _pageSelected = [
    QuranDetailsTab(),
    QuranRegistrationTab(),
    QuranTafseerTab(),
    FemulTajweedTab(),
    QuranTestsTab()
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
