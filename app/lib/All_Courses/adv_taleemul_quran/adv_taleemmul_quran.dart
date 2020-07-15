import 'package:arrahma_mobile_app/All_Courses/adv_taleemul_quran/details_tab/adv_taleemul_details_tab.dart';
import 'package:arrahma_mobile_app/All_Courses/adv_taleemul_quran/registration_tab/adv_taleemul_registration_tab.dart';
import 'package:arrahma_mobile_app/All_Courses/adv_taleemul_quran/tafseer_tab/adv_taleemul_tafseer_tab.dart';
import 'package:arrahma_mobile_app/All_Courses/adv_taleemul_quran/tajweed_tab/adv_taleemul_tajweed_tab.dart';
import 'package:arrahma_mobile_app/All_Courses/adv_taleemul_quran/tests_tab/adv_taleemul_tests_tab.dart';
import 'package:arrahma_mobile_app/Drawer/main_drawer.dart';
import 'package:flutter/material.dart';

class AdvTaleemmulQuran extends StatefulWidget {
  @override
  _AdvTaleemmulQuranState createState() => _AdvTaleemmulQuranState();
}

class _AdvTaleemmulQuranState extends State<AdvTaleemmulQuran> {
  int _tabSelected = 2;

  final _pageSelected = [
    AdvTaleemmulQuranDetailsTab(),
    AdvTaleemmulQuranRegistrationTab(),
    AdvTaleemmulTafseerTab(),
    AdvTaleemmulTajweedTab(),
    AdvTaleemmulTestsTab()
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
