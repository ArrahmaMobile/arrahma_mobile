import 'package:arrahma_mobile_app/features/common/basic_webview.dart';
import 'package:arrahma_mobile_app/features/common/media_content_view.dart';
import 'package:arrahma_mobile_app/features/common/simple_image_view.dart';
import 'package:arrahma_mobile_app/features/common/simple_pdf_view.dart';
import 'package:arrahma_mobile_app/features/common/themed_app_bar.dart';
import 'package:arrahma_mobile_app/features/media_player/media_player_view.dart';
import 'package:arrahma_mobile_app/features/quran_course/quran_surah_view.dart';
import 'package:arrahma_mobile_app/features/tawk/models/visitor.dart';
import 'package:arrahma_mobile_app/features/tawk/tawk.dart';
import 'package:arrahma_mobile_app/services/app.dart';
import 'package:arrahma_shared/shared.dart' hide MediaItem;
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart'
    hide ServerConnectionStatus;
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


  /// Get the widget view for an item without navigation
  /// Returns null if the item should be handled externally (e.g., Audio needs special handling)
  static Widget? getItemView(Item item, {String? titleOverride}) {
    final typeName = EnumUtils.enumToString(item.type);
    final title = titleOverride ?? (item is TitledItem ? item.title : typeName);

    if (item.type == ItemType.Audio) {
      // Audio needs special handling with openAudio
      return null;
    }
    if (item.type == ItemType.Pdf) {
      return SimplePdfView(
        url: item.data,
        title: title,
      );
    }
    if (item.type == ItemType.Image) {
      return SimpleImageView(
        url: item.data,
        title: title,
      );
    }
    if (item.type == ItemType.Markdown) {
      return Markdown(data: item.data);
    }

    // Check if this URL points to content we already have loaded
    if (item.type == ItemType.WebPage) {
      // Check for QuranCourseContent
      final appService = SL.get<AppService>();
      final contentItem =
          appService?.contentRegistry.findContentByUrl(item.data);
      if (contentItem?.content != null) {
        logger
            .verbose('Found content item: $contentItem for url: ${item.data}');
        return QuranSurahView(
          content: contentItem!.content!,
          referrerTitle: contentItem.title,
        );
      }

      // Check for MediaContent
      final mediaItem = appService?.contentRegistry.findMediaByUrl(item.data);
      if (mediaItem?.media != null) {
        logger.verbose('Found media item: $mediaItem for url: ${item.data}');
        return MediaContentView(content: mediaItem!.media!);
      }
    }

    // Fallback: Web view
    return BasicWebView(url: item.data);
  }

  static void openUrl(BuildContext context, Item item,
      {bool useWebView = false}) {
    final typeName = EnumUtils.enumToString(item.type);
    final title = item is TitledItem ? item.title : typeName;

    // Handle audio separately (needs navigation context)
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

    // Get the view widget using shared logic
    final view = getItemView(item, titleOverride: title);

    if (view != null) {
      // For Markdown, we need to wrap it in a title
      if (item.type == ItemType.Markdown) {
        Utils.pushView(context, view, title: title);
      } else if (item.type == ItemType.WebPage) {
        // For WebPage, check if it's a content item to get the right title
        final appService = SL.get<AppService>();
        final contentItem = appService?.contentRegistry.findContentByUrl(item.data);
        final mediaItem = appService?.contentRegistry.findMediaByUrl(item.data);

        if (contentItem?.content != null) {
          Utils.pushView(context, view, title: contentItem!.title);
        } else if (mediaItem?.media != null) {
          Utils.pushView(context, view, title: mediaItem!.title);
        } else if (useWebView) {
          Utils.pushView(context, view, title: title);
        } else {
          // Open externally
          Launch.url(item.data);
        }
      } else {
        // For other types, push without separate title since it's in the view
        Utils.pushView(context, view);
      }
    } else if (!useWebView && item.type != ItemType.Audio) {
      // Fallback: open externally
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
