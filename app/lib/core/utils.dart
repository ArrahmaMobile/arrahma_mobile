import 'package:arrahma_mobile_app/Media_Player/media_player.dart';
import 'package:arrahma_mobile_app/features/media_player/models/media_data.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';

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
    Launch.url(item.url);
  }
}
