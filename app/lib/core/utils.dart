import 'package:arrahma_mobile_app/features/common/simple_pdf_view.dart';
import 'package:arrahma_mobile_app/features/common/themed_app_bar.dart';
import 'package:arrahma_mobile_app/features/media_player/media_player_view.dart';
import 'package:arrahma_mobile_app/features/quran_course/quran_course_view.dart';
import 'package:arrahma_shared/shared.dart' hide MediaItem;
import 'package:audio_service/audio_service.dart';
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

  static List<MediaItem> itemToMediaItem(List<TitledItem> items, String group) {
    return items
        .asMap()
        .entries
        .where((i) => i.value.type == ItemType.Audio)
        .map(
          (urlEntry) => MediaItem(
            title: urlEntry.value.title,
            album: group,
            id: urlEntry.value.data,
          ),
        )
        .toList();
  }

  static void openAudio(
      BuildContext context, List<MediaItem> items, int index) {
    Utils.pushView(
      context,
      null,
      MediaPlayerView(
        mediaItems: items,
        initialAudioIndex: index,
      ),
    );
    return;
  }

  static void openUrl(BuildContext context, Item item) {
    final typeName = EnumUtils.enumToString(item.type);
    final title = item is TitledItem ? item.title : typeName;
    if (item.type == ItemType.Audio) {
      openAudio(
          context,
          [
            MediaItem(
              title: title,
              album: typeName,
              id: item.data,
            )
          ],
          0);
      return;
    }
    if (item.type == ItemType.Pdf) {
      Utils.pushView(
        context,
        title,
        SimplePdfView(
          url: item.data,
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
