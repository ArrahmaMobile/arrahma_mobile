import 'package:audio_service/audio_service.dart';

class MediaData {
  const MediaData({
    required this.sourceUrl,
    required this.title,
    required this.group,
  });
  final String sourceUrl;
  final String title;
  final String group;

  MediaItem toMediaItem() {
    return MediaItem(id: sourceUrl, title: title, album: group);
  }
}
