import 'package:audio_service/audio_service.dart';

class MediaData {
  const MediaData({
    this.sourceUrl,
    this.title,
    this.group,
  });
  final String sourceUrl;
  final String title;
  final String group;

  MediaItem toMediaItem() {
    return MediaItem(id: sourceUrl, title: title, album: group);
  }
}
