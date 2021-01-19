import 'package:audio_service/audio_service.dart';
import 'package:rxdart/rxdart.dart';

import 'player/index.dart';

final positionManager =
    PositionManager(positionDataManager: HivePositionDataManager());

// NOTE: Your entrypoint MUST be a top-level function.
void _audioPlayerTaskEntrypoint() {
  AudioServiceBackground.run(() => PositionedAudioTask.standard());
}

class ScreenState {
  const ScreenState(
      this.playbackState, this.mediaItem, this.queue, this.queueIndex);
  final PlaybackState playbackState;
  final MediaItem mediaItem;
  final List<MediaItem> queue;
  final int queueIndex;
}

class MediaPlayerService {
  static Stream<ScreenState> get screenStateStream =>
      Rx.combineLatest3<PlaybackState, MediaItem, List<MediaItem>, ScreenState>(
          AudioService.playbackStateStream,
          AudioService.currentMediaItemStream,
          AudioService.queueStream,
          (playbackState, mediaItem, queue) => ScreenState(
              playbackState, mediaItem, queue, queue.indexOf(mediaItem)));
  static Future<void> ensureStarted() async {
    if (!AudioService.running)
      await AudioService.start(
        backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
        androidNotificationChannelName: 'Arrahma Audio Service',
        // Enable this if you want the Android service to exit the foreground state on pause.
        //androidStopForegroundOnPause: true,
        androidNotificationColor: 0xFF2196f3,
        androidNotificationIcon: 'mipmap/ic_launcher',
        androidEnableQueue: true,
      );
  }

  static List<MediaItem> _lastItems;
  static int _lastIndex;

  static Future<void> start(List<MediaItem> items, int index) async {
    await ensureStarted();
    if (items.isNotEmpty) {
      _lastItems = items;
      _lastIndex = index;
      AudioService.updateQueue(items);
      AudioService.skipToQueueItem(items[index].id);
    }
  }

  static Future<void> play() async {
    if (!AudioService.running ||
        (AudioService.queue?.isEmpty ?? true) ||
        AudioService.currentMediaItem == null)
      await start(_lastItems, _lastIndex);
    return AudioService.play();
  }

  static Future<void> stop() {
    return AudioService.stop();
  }

  static Future<void> pause() {
    return AudioService.pause();
  }

  static Future<void> skipToNext() {
    return AudioService.skipToNext();
  }

  static Future<void> skipToPrevious() {
    return AudioService.skipToPrevious();
  }
}
