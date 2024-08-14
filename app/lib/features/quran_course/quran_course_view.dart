import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../common/media_content_view.dart';
import 'quran_surah_view.dart';

class QuranCourseView extends StatefulWidget {
  const QuranCourseView({
    super.key,
    required this.course,
    this.initialTabIndex,
  });
  final QuranCourse course;
  final int? initialTabIndex;

  @override
  _QuranCourseViewState createState() => _QuranCourseViewState();
}

class _QuranCourseViewState extends State<QuranCourseView> {
  int? _tabSelected;

  int get tabCount => _getTabs().length;

  int get selectedTabIndex =>
      _tabSelected ??
      ((tabCount / 2).round() - 1).clamp(0, tabCount - 1).toInt();

  @override
  void initState() {
    super.initState();
    _tabSelected = widget.initialTabIndex;
  }

  List<Widget> _getTabs() {
    return [
      if (widget.course.courseDetails != null)
        MediaContentView(
          content: widget.course.courseDetails!,
        ),
      if (widget.course.registration != null)
        MediaContentView(
          content: widget.course.registration!,
        ),
      if (widget.course.tafseer != null)
        QuranSurahView(
          content: widget.course.tafseer!,
        ),
      if (widget.course.tajweed != null)
        QuranSurahView(
          content: widget.course.tajweed!,
        ),
      if (widget.course.lectures != null)
        QuranSurahView(
          content: widget.course.lectures!,
        ),
      if (widget.course.tests != null)
        MediaContentView(content: widget.course.tests!),
      if (widget.course.otherContent != null)
        MediaContentView(content: widget.course.otherContent!)
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
        Expanded(
          child: KeyedSubtree(
            key: ValueKey(selectedTabIndex),
            child: _getTab(selectedTabIndex),
          ),
        ),
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
                      BottomNavigationBarItem(
                        icon: const Icon(
                          Icons.library_books,
                        ),
                        label: widget.course.courseDetails!.title,
                      ),
                    if (widget.course.registration != null)
                      BottomNavigationBarItem(
                        icon: const Icon(
                          Icons.app_registration,
                        ),
                        label: widget.course.registration!.title,
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
                          FontAwesomeIcons.bookQuran,
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
                    if (widget.course.otherContent != null)
                      BottomNavigationBarItem(
                        icon: const Icon(
                          FontAwesomeIcons.table,
                        ),
                        label: widget.course.otherContent!.title,
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
