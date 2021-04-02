import 'package:arrahma_mobile_app/features/common/basic_webview.dart';
import 'package:arrahma_mobile_app/features/common/simple_image_view.dart';
import 'package:arrahma_mobile_app/features/common/simple_pdf_view.dart';
import 'package:arrahma_mobile_app/features/common/themed_app_bar.dart';
import 'package:arrahma_mobile_app/features/media_player/media_player_view.dart';
import 'package:arrahma_mobile_app/features/quran_course/quran_course_view.dart';
import 'package:arrahma_mobile_app/features/tawk/models/visitor.dart';
import 'package:arrahma_mobile_app/features/tawk/tawk.dart';
import 'package:arrahma_shared/shared.dart' hide MediaItem;
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';

import 'package:inherited_state/inherited_state.dart';
import 'package:share/share.dart';

class Utils {
  static void pushView(BuildContext context, Widget view,
      {String title,
      bool replace = false,
      bool keepPadding = false,
      Color backgroundColor,
      List<Widget> actions}) {
    NavigationUtils.pushNoResultView(
      context,
      view,
      safeArea: false,
      padding: keepPadding ? null : EdgeInsets.zero,
      appBar: title != null
          ? ThemedAppBar(
              title: title,
              backgroundColor: backgroundColor,
              actions: actions,
            )
          : null,
      replace: replace,
    );
  }

  static void pushContactSupportView(BuildContext context) {
    Utils.pushView(
      context,
      const Tawk(
        directChatLink: 'https://tawk.to/chat/59840e124471ce54db652823/default',
        visitor: TawkVisitor(
          name: '',
          email: '',
        ),
      ),
      title: 'Chat With Us',
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
      MediaPlayerView(
        mediaItems: items,
        initialAudioIndex: index,
      ),
      backgroundColor: Colors.white,
      title: '',
    );
    return;
  }

  static void openUrl(BuildContext context, Item item,
      {bool fromMenu = false}) {
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
        SimplePdfView(
          url: item.data,
          title: title,
        ),
      );
      return;
    }
    if (item.type == ItemType.Image) {
      Utils.pushView(
        context,
        SimpleImageView(
          url: item.data,
          title: title,
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
        QuranCourseView(
          course: course,
          initialTabIndex: tabIndex +
              (course.courseDetails != null ? 1 : 0) +
              (course.registration != null ? 1 : 0),
        ),
        title: course.title,
      );
    } else {
      if (fromMenu)
        Utils.pushView(
          context,
          BasicWebView(url: item.data),
          title: title,
        );
      else
        Launch.url(item.data);
    }
  }

  static Widget shareActionButton(String title, List<String> data,
      [List<String> mimeTypes]) {
    return IconButton(
      icon: const Icon(Icons.share),
      disabledColor: Colors.grey,
      onPressed: data != null
          ? () {
              Share.shareFiles(
                data,
                mimeTypes: mimeTypes,
                text: title,
              );
            }
          : null,
    );
  }
}
