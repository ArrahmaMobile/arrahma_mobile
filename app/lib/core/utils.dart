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
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:inherited_state/inherited_state.dart';
import 'package:share/share.dart';

class Utils {
  static void pushView(BuildContext context, Widget view,
      {String? title,
      bool replace = false,
      bool keepPadding = false,
      Color? backgroundColor,
      List<Widget>? actions}) {
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
          hash: 'default',
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
      title: '',
    );
    return;
  }

  static Widget? getItemView(Item item) {
    final typeName = EnumUtils.enumToString(item.type);
    final title = item is TitledItem ? item.title : typeName;
    switch (item.type) {
      case ItemType.Pdf:
        return SimplePdfView(url: item.data);
      case ItemType.Image:
        return SimpleImageView(url: item.data);
      case ItemType.Markdown:
        return Markdown(data: item.data);
      case ItemType.Audio:
        return MediaPlayerView(
          mediaItems: [
            MediaItem(
              title: title,
              album: typeName,
              id: item.data,
            )
          ],
        );
      case ItemType.WebPage:
        return BasicWebView(
          url: item.data,
        );

      default:
        return null;
    }
  }

  static void openUrl(BuildContext context, Item item,
      {bool useWebView = false}) {
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
              artUri: item.imageUrl != null ? Uri.parse(item.imageUrl!) : null,
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
        .fold<List<QuranCourseContent>>(
            <QuranCourseContent>[],
            (allC, c) => allC
              ..addAll([c.tafseer, c.tajweed, c.lectures]
                  .where((c) => c != null)
                  .cast()))
        .asMap()
        .entries
        .firstWhereOrNull((cEntry) => cEntry.value.id == item.data);
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
      if (useWebView)
        Utils.pushView(
          context,
          BasicWebView(url: item.data),
          title: title,
        );
      else
        Launch.url(item.data);
    }
  }

  static Widget shareActionButton(String title, List<String>? data,
      [List<String>? mimeTypes]) {
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
