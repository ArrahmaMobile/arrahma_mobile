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
    return widget.course.sections
        .where((section) => section.hasContent)
        .map((section) {
          // Handle QuranCourseContent (surahs)
          if (section.courseContent != null) {
            return QuranSurahView(
              content: section.courseContent!,
              referrerTitle: widget.course.title,
            );
          }
          // Handle MediaContent (link lists)
          else if (section.mediaContent != null) {
            return MediaContentView(content: section.mediaContent!);
          }
          // Fallback - shouldn't happen due to hasContent check
          return const Center(child: Text('No content available'));
        })
        .toList();
  }

  Widget _getTab(int tabIndex) {
    final tabs = _getTabs();
    return tabs[tabIndex];
  }

  IconData _getIconForSection(String label) {
    final lower = label.toLowerCase();
    if (lower.contains('tafseer')) return Icons.book;
    if (lower.contains('tajweed')) return FontAwesomeIcons.bookQuran;
    if (lower.contains('test')) return FontAwesomeIcons.penToSquare;
    if (lower.contains('lecture')) return Icons.book;
    if (lower.contains('detail')) return Icons.library_books;
    if (lower.contains('regist')) return Icons.app_registration;
    if (lower.contains('latest')) return Icons.fiber_new;
    return FontAwesomeIcons.table;
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
                  items: widget.course.sections
                      .where((section) => section.hasContent)
                      .map((section) => BottomNavigationBarItem(
                            icon: Icon(_getIconForSection(section.label)),
                            label: section.label,
                          ))
                      .toList(),
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
