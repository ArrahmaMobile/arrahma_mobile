import 'package:arrahma_mobile_app/All_Courses/adv_taleemul_quran/details_tab/adv_taleemul_details_tab.dart';
import 'package:arrahma_mobile_app/All_Courses/adv_taleemul_quran/tafseer_tab/adv_taleemul_juz_detail_page/adv_taleemul_juz_detail_page.dart';
import 'package:arrahma_mobile_app/Drawer/main_drawer.dart';
import 'package:flutter/material.dart';

class AlFurqan extends StatefulWidget {
  @override
  _AlFurqanState createState() => _AlFurqanState();
}

class _AlFurqanState extends State<AlFurqan> {
  int _tabSelected = 0;

  final _pageSelected = [
    AdvTaleemmulQuranDetailsTab(),
    AdvTaleemmulJuzDetailPage(),
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
