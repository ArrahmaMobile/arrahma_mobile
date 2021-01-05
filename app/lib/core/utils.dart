import 'package:arrahma_mobile_app/features/common/themed_app_bar.dart';
import 'package:arrahma_mobile_app/features/media_player/media_player_view.dart';
import 'package:arrahma_mobile_app/features/media_player/models/media_data.dart';
import 'package:arrahma_mobile_app/features/quran_course/quran_course_view.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';

import 'package:inherited_state/inherited_state.dart';

class Utils {
  static void pushView(BuildContext context, String title, Widget view,
      {bool replace = false, Color backgroundColor}) {
    NavigationUtils.pushNoResultView(
      context,
      view,
      safeArea: false,
      appBar: title != null
          ? ThemedAppBar(
              title: title,
              backgroundColor: backgroundColor,
            )
          : null,
      replace: replace,
    );
  }

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
              sourceUrl: urlEntry.value.data,
            ),
          )
          .toList();
      Utils.pushView(
        context,
        null,
        MediaPlayerView(
          mediaItems: mediaItems,
          initialAudioIndex: index,
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
        .firstWhere((cEntry) => cEntry.value?.id == item.data,
            orElse: () => null);
    if (courseContents != null) {
      final course = appData.courses[courseContents.key ~/ 3];
      final courseContentIndex = courseContents.key % 3;
      final tabIndex = courseContentIndex == 2 ? 0 : courseContentIndex;
      Utils.pushView(
        context,
        course.title,
        QuranCourseView(
          course: course,
          initialTabIndex: tabIndex +
              (course.courseDetails != null ? 1 : 0) +
              (course.registration != null ? 1 : 0),
        ),
      );
    } else {
      Launch.url(item.data);
    }
  }
}
