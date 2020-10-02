import 'package:audio_service/audio_service.dart';

class MediaData {
  const MediaData({
    this.sourceUrl,
    this.title,
    this.group,
    this.contextKey,
    this.localPath,
  });
  final String sourceUrl;
  final String title;
  final String group;
  final String contextKey;
  final String localPath;

  MediaData copyWith({String title, String path}) {
    return MediaData(
      sourceUrl: sourceUrl,
      title: title ?? this.title,
      group: group,
      contextKey: contextKey,
      localPath: path ?? localPath,
    );
  }

  MediaItem toMediaItem() {
    return MediaItem(id: sourceUrl, title: title, album: group);
  }
}
