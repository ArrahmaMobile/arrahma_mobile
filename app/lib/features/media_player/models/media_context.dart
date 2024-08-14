import 'media_data.dart';

class MediaContext {
  const MediaContext({
    required this.mediaItems,
    required this.index,
    required this.totalDuration,
    required this.playedDuration,
  });
  final List<MediaData> mediaItems;
  final int index;
  final Duration totalDuration;
  final Duration playedDuration;
}
