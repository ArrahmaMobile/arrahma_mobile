import 'package:arrahma_mobile_app/features/drawer/main_drawer.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';

import 'quran_details_tab/quran_details_tab.dart';
import 'quran_registration_tab/quran_registration_tab.dart';
import 'quran_tafseer_tab/quran_surah_page/quran_surah_page.dart';
import 'quran_test_page/quran_test_page.dart';

class QuranCoursePage extends StatefulWidget {
  const QuranCoursePage({
    Key key,
    @required this.course,
    this.initialTabIndex,
  }) : super(key: key);
  final QuranCourse course;
  final int initialTabIndex;

  @override
  _QuranCoursePageState createState() => _QuranCoursePageState();
}

class _QuranCoursePageState extends State<QuranCoursePage> {
  int _tabSelected;

  int get tabCount => _getTabs().length;

  int get selectedTabIndex => _tabSelected ?? (tabCount - 1);

  @override
  void initState() {
    super.initState();
    _tabSelected = widget.initialTabIndex;
  }

  List<Widget> _getTabs() {
    return [
      if (widget.course.courseDetails != null)
        QuranDetailsTab(
          title: widget.course.title,
          details: widget.course.courseDetails,
        ),
      if (widget.course.registration != null)
        QuranRegistrationTab(
          registration: widget.course.registration,
          title: widget.course.title,
        ),
      if (widget.course.tafseer != null)
        QuranSurahPage(
          surahs: widget.course.tafseer.surahs,
          title: widget.course.title,
        ),
      if (widget.course.tajweed != null)
        QuranSurahPage(
          surahs: widget.course.tajweed.surahs,
          title: widget.course.title,
        ),
      if (widget.course.lectures != null)
        QuranSurahPage(
          surahs: widget.course.lectures.surahs,
          title: widget.course.title,
        ),
      if (widget.course.tests != null)
        QuranTestsPage(
          title: widget.course.title,
        )
    ];
  }

  Widget _getTab(int tabIndex) {
    final tabs = _getTabs();
    return tabs[tabIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      body: _getTab(selectedTabIndex),
      bottomNavigationBar: tabCount <= 1
          ? null
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(
                  height: 2,
                  thickness: 2,
                  color: Colors.grey.shade300,
                ),
                Flexible(
                  child: BottomNavigationBar(
                    elevation: 10,
                    selectedItemColor: const Color(0xff124570),
                    unselectedItemColor: Colors.black,
                    currentIndex: selectedTabIndex,
                    type: BottomNavigationBarType.fixed,
                    items: [
                      if (widget.course.courseDetails != null)
                        const BottomNavigationBarItem(
                          icon: Icon(
                            Icons.library_books,
                          ),
                          label: 'Details',
                        ),
                      if (widget.course.registration != null)
                        const BottomNavigationBarItem(
                          icon: Icon(
                            Icons.book,
                          ),
                          label: 'Registration',
                        ),
                      if (widget.course.tafseer != null)
                        const BottomNavigationBarItem(
                          icon: Icon(
                            Icons.book,
                          ),
                          label: 'Tafseer',
                        ),
                      if (widget.course.tajweed != null)
                        const BottomNavigationBarItem(
                          icon: Icon(
                            Icons.home,
                          ),
                          label: 'Tajweed',
                        ),
                      if (widget.course.lectures != null)
                        const BottomNavigationBarItem(
                          icon: Icon(
                            Icons.home,
                          ),
                          label: 'Lectures',
                        ),
                      if (widget.course.tests != null)
                        const BottomNavigationBarItem(
                          icon: Icon(
                            Icons.home,
                          ),
                          label: 'Tests',
                        ),
                    ],
                    onTap: (index) {
                      setState(() {
                        _tabSelected = index;
                      });
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
