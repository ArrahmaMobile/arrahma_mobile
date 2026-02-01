import 'package:arrahma_mobile_app/core/utils.dart';
import 'package:arrahma_mobile_app/features/media_player/media_player_view.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:audio_service/audio_service.dart' as audio_service;
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MediaContentView extends StatelessWidget {
  const MediaContentView({
    super.key,
    required this.content,
  });

  final MediaContent content;

  @override
  Widget build(BuildContext context) {
    if (content.items?.length == 1 && content.items!.first.item != null) {
      // Embed the single item view directly
      return _buildItemView(context, content.items!.first);
    }
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (content.description != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: MarkdownBody(
                data: content.description!,
              ),
            ),
          ListView.builder(
            itemCount: content.items!.length,
            itemBuilder: (_, index) {
              final item = content.items![index];
              final title = item.title ??
                  '${EnumUtils.enumToString(item.item!.type)} ${index + 1}';
              return ListTile(
                title: Text(title),
                onTap: item.item?.data != null
                    ? () {
                        Utils.openUrl(
                          context,
                          TitledItem.fromItem(
                            title,
                            item.item!,
                          ),
                          useWebView: true,
                        );
                      }
                    : null,
              );
            },
            primary: false,
            shrinkWrap: true,
          ),
        ],
      ),
    );
  }

  Widget _buildItemView(BuildContext context, MediaItem mediaItem) {
    final item = mediaItem.item!;
    final title = mediaItem.title ??
        '${EnumUtils.enumToString(item.type)} 1';

    // Special case for Audio - Utils.getItemView returns null for audio
    if (item.type == ItemType.Audio) {
      return MediaPlayerView(
        mediaItems: [
          audio_service.MediaItem(
            title: title,
            album: 'Media',
            id: item.data,
            artUri: item.imageUrl != null ? Uri.parse(item.imageUrl!) : null,
          )
        ],
        initialAudioIndex: 0,
      );
    }

    // Use shared logic from Utils.getItemView
    final view = Utils.getItemView(item, titleOverride: title);
    return view ?? const Center(child: Text('Unsupported content type'));
  }
}
