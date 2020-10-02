import 'media_data.dart';

class MediaContext {
  const MediaContext({
    this.mediaItems,
    this.index,
    this.totalDuration,
    this.playedDuration,
  });
  final List<MediaData> mediaItems;
  final int index;
  final Duration totalDuration;
  final Duration playedDuration;
}
