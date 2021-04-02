import 'package:arrahma_mobile_app/features/quran_course/quran_details_view.dart';
import 'package:arrahma_mobile_app/features/quran_course/quran_registration_view.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'quran_surah_view.dart';
import '../common/media_content_view.dart';

class QuranCourseView extends StatefulWidget {
  const QuranCourseView({
    Key key,
    @required this.course,
    this.initialTabIndex,
  }) : super(key: key);
  final QuranCourse course;
  final int initialTabIndex;

  @override
  _QuranCourseViewState createState() => _QuranCourseViewState();
}

class _QuranCourseViewState extends State<QuranCourseView> {
  int _tabSelected;

  int get tabCount => _getTabs().length;

  int get selectedTabIndex => _tabSelected ?? (tabCount ~/ 2);

  @override
  void initState() {
    super.initState();
    _tabSelected = widget.initialTabIndex;
  }

  List<Widget> _getTabs() {
    return [
      if (widget.course.courseDetails != null)
        QuranDetailsView(
          courseDetails: widget.course.courseDetails,
        ),
      if (widget.course.registration != null)
        QuranRegistrationView(
          registration: widget.course.registration,
        ),
      if (widget.course.tafseer != null)
        QuranSurahView(
          content: widget.course.tafseer,
        ),
      if (widget.course.tajweed != null)
        QuranSurahView(
          content: widget.course.tajweed,
        ),
      if (widget.course.lectures != null)
        QuranSurahView(
          content: widget.course.lectures,
        ),
      if (widget.course.tests != null)
        MediaContentView(content: widget.course.tests)
    ];
  }

  Widget _getTab(int tabIndex) {
    final tabs = _getTabs();
    return tabs[tabIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: _getTab(selectedTabIndex)),
        if (tabCount > 1)
          Column(
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
                          Icons.app_registration,
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
                          FontAwesomeIcons.quran,
                        ),
                        label: 'Tajweed',
                      ),
                    if (widget.course.lectures != null)
                      const BottomNavigationBarItem(
                        icon: Icon(
                          Icons.book,
                        ),
                        label: 'Lectures',
                      ),
                    if (widget.course.tests != null)
                      const BottomNavigationBarItem(
                        icon: Icon(
                          FontAwesomeIcons.edit,
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
      ],
    );
  }
}
