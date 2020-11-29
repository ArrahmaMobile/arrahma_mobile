import 'package:arrahma_mobile_app/Media_Player/media_player.dart';
import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_course_page.dart';
import 'package:arrahma_mobile_app/features/media_player/models/media_data.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';

import 'package:inherited_state/inherited_state.dart';

class Utils {
  static void openUrl(BuildContext context, String Function(int index) title,
      String group, List<Item> items, int index) {
    final item = items[index];
    if (item.type == ItemType.Audio) {
      final mediaItems = items
          .asMap()
          .entries
          .where((i) => i.value.type == ItemType.Audio)
          .map(
            (urlEntry) => MediaData(
              title: title(urlEntry.key),
              group: group,
              sourceUrl: urlEntry.value.url,
            ),
          )
          .toList();
      Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (_) => MediaPlayerScreen(
            mediaItems: mediaItems,
            initialAudioIndex: index,
          ),
        ),
      );
      return;
    }

    final appData = context.on<AppData>();
    final courseContents = appData.courses
        .fold<List<QuranCourseContent>>(<QuranCourseContent>[],
            (allC, c) => allC..addAll([c.tafseer, c.tajweed, c.lectures]))
        .asMap()
        .entries
        .firstWhere((cEntry) => cEntry.value?.id == item.url,
            orElse: () => null);
    if (courseContents != null) {
      final course = appData.courses[courseContents.key ~/ 3];
      final courseContentIndex = courseContents.key % 3;
      final tabIndex = courseContentIndex == 2 ? 0 : courseContentIndex;
      Navigator.push<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (_) => QuranCoursePage(
            course: course,
            initialTabIndex: tabIndex +
                (course.courseDetails != null ? 1 : 0) +
                (course.registration != null ? 1 : 0),
          ),
        ),
      );
    } else {
      Launch.url(item.url);
    }
  }
}
