import 'package:arrahma_mobile_app/All_Courses/adv_taleemul_quran/details_tab/adv_taleemul_details_tab.dart';
import 'package:arrahma_mobile_app/All_Courses/adv_taleemul_quran/tafseer_tab/adv_taleemul_tafseer_tab.dart';
import 'package:arrahma_mobile_app/Drawer/main_drawer.dart';
import 'package:flutter/material.dart';

class AlMisbah extends StatefulWidget {
  @override
  _AlMisbahState createState() => _AlMisbahState();
}

class _AlMisbahState extends State<AlMisbah> {
  int _tabSelected = 0;

  final _pageSelected = [
    AdvTaleemmulQuranDetailsTab(),
    AdvTaleemmulTafseerTab(),
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
            icon: Icon(Icons.library_books),
            title: Text(
              'Details',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
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
