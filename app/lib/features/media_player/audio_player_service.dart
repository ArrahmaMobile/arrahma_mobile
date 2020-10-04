import 'dart:async';

import 'package:arrahma_mobile_app/features/media_player/models/media_context.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter_framework/flutter_framework.dart';
import 'package:just_audio/just_audio.dart';

import 'models/media_data.dart';

class CoreAudioPlayerService {
  CoreAudioPlayerService();

  // final player = AudioPlayer();

  // final _audioController = StreamController<MediaData>.broadcast();

  // int get currentIndex => player.currentIndex;

  Stream<PlaybackState> get playbackStateStream =>
      AudioService.playbackStateStream;
  // Stream<Duration> get totalDurationStream => player.durationStream;
  // Stream<Duration> get playedDurationStream => player.positionStream;

  Stream<MediaItem> get audioStream => AudioService.currentMediaItemStream;
  Stream<List<MediaItem>> get queueStream => AudioService.queueStream;

  // Future playWithContext(MediaContext context,
  //     {bool shouldStart = true}) async {
  //   final duration = await queue(context.mediaItems);
  //   if (context.playedDuration.inSeconds >= 0 &&
  //       context.playedDuration < duration)
  //     await player.seek(context.playedDuration);
  //   if (shouldStart) player.play();
  // }

  Future<void> stop() async {
    return AudioService.stop();
  }

  Future<bool> start(List<MediaData> mediaItems, int index) async {
    if (AudioService.running) await stop();
    final items = mediaItems.map((i) => i.toMediaItem().toJson()).toList();
    return AudioService.start(
        backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
        androidNotificationChannelName: 'Arrahma Audio Service',
        // Enable this if you want the Android service to exit the foreground state on pause.
        //androidStopForegroundOnPause: true,
        androidNotificationColor: 0xFF2196f3,
        androidNotificationIcon: 'mipmap/ic_launcher',
        androidEnableQueue: true,
        params: <String, dynamic>{'items': items, 'index': index ?? 0});
  }

  Future<void> pause() {
    return AudioService.pause();
  }

  Future<void> play() async {
    return AudioService.play();
  }

  // bool checkLocalCache(String path) => path != null && File(path).existsSync();

  void dispose() {
    stop();
    // _audioController.close();
  }
}

class AudioPlayerService extends CoreAudioPlayerService {
  // with StoppableService {
  AudioPlayerService(this._storageService, this._apiService) {
    _init();
  }

  final IStorageService _storageService;
  final ApiService _apiService;

  MediaContext _audioContext;

  Future _init() async {
    // _audioContext = await _storageService.get<MediaContext>();
    // if (_audioContext != null)
    //   playWithContext(_audioContext, shouldStart: false);
  }

  // Future<MediaData> download(MediaData audio, {bool force = false}) async {
  //   final isAlreadyCached = checkLocalCache(audio.localPath);
  //   if (isAlreadyCached && !force) return audio;
  //   final lookupKey = md5.convert(utf8.encode(audio.sourceUrl));
  //   var cleanedTitle = audio.title.replaceAll(RegExp(r'[^\w\s]'), '');
  //   cleanedTitle =
  //       cleanedTitle.length > 8 ? cleanedTitle.substring(0, 8) : cleanedTitle;
  //   final directory = await getDownloadsDirectory();
  //   final cachedPath = '${directory.path}/$cleanedTitle-$lookupKey.mp3';
  //   final completer = Completer<Uint8List>();
  //   _apiService.downloadFile(
  //       audio.sourceUrl, (bytes) => completer.complete(bytes));
  //   final bytes = await completer.future;
  //   await File(cachedPath).writeAsBytes(bytes);
  //   return audio.withLocalPath(cachedPath);
  // }

  // @override
  // Future<void> stop() async {
  //   super.stop();
  //   _storageService.set(_audioContext);
  // }
}

// NOTE: Your entrypoint MUST be a top-level function.
Future _audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

/// This task defines logic for playing a list of podcast episodes.
class AudioPlayerTask extends BackgroundAudioTask {
  // final _corePlayerService = CoreAudioPlayerService();
  // AudioPlayer get _player => _corePlayerService.player;
  final _player = AudioPlayer();
  AudioProcessingState _skipState;
  Seeker _seeker;
  StreamSubscription<PlaybackEvent> _eventSubscription;

  List<MediaItem> _queue;
  List<MediaItem> get queue => _queue;
  int get index => _player.currentIndex;
  MediaItem get mediaItem => index == null ? null : queue[index];

  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    final items = params['items'] != null
        ? (params['items'] as List)
            .map((dynamic item) =>
                MediaItem.fromJson(item as Map<dynamic, dynamic>))
            .toList()
        : <MediaItem>[];
    final index = params['index'] != null ? params['index'] as int : 0;
    _queue = items;
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Broadcast media item changes.
    _player.currentIndexStream.listen((index) {
      if (index != null) AudioServiceBackground.setMediaItem(queue[index]);
    });
    // Propagate all events from the audio player to AudioService clients.
    _eventSubscription = _player.playbackEventStream.listen((event) {
      _broadcastState();
    });
    // Special processing for state transitions.
    _player.processingStateStream.listen((state) {
      switch (state) {
        case ProcessingState.completed:
          // In this example, the service stops when reaching the end.
          onStop();
          break;
        case ProcessingState.ready:
          // If we just came from skipping between tracks, clear the skip
          // state now that we're ready to play.
          _skipState = null;
          break;
        default:
          break;
      }
    });

    // Load and broadcast the queue
    AudioServiceBackground.setQueue(queue);
    try {
      await _player.load(ConcatenatingAudioSource(
        children:
            queue.map((item) => AudioSource.uri(Uri.parse(item.id))).toList(),
      ));
      // In this example, we automatically start playing on start.
      if (index != 0) _player.seek(Duration.zero, index: index);
      onPlay();
    } catch (e) {
      print("Error: $e");
      onStop();
    }
  }

  @override
  Future<void> onSkipToQueueItem(String mediaId) async {
    // Then default implementations of onSkipToNext and onSkipToPrevious will
    // delegate to this method.
    final newIndex = queue.indexWhere((item) => item.id == mediaId);
    if (newIndex == -1) return;
    // During a skip, the player may enter the buffering state. We could just
    // propagate that state directly to AudioService clients but AudioService
    // has some more specific states we could use for skipping to next and
    // previous. This variable holds the preferred state to send instead of
    // buffering during a skip, and it is cleared as soon as the player exits
    // buffering (see the listener in onStart).
    _skipState = newIndex > index
        ? AudioProcessingState.skippingToNext
        : AudioProcessingState.skippingToPrevious;
    // This jumps to the beginning of the queue item at newIndex.
    _player.seek(Duration.zero, index: newIndex);
  }

  @override
  Future<void> onPlay() => _player.play();

  @override
  Future<void> onPause() => _player.pause();

  @override
  Future<void> onSeekTo(Duration position) => _player.seek(position);

  @override
  Future<void> onFastForward() => _seekRelative(fastForwardInterval);

  @override
  Future<void> onRewind() => _seekRelative(-rewindInterval);

  @override
  Future<void> onSeekForward(bool begin) async => _seekContinuously(begin, 1);

  @override
  Future<void> onSeekBackward(bool begin) async => _seekContinuously(begin, -1);

  @override
  Future<void> onStop() async {
    await _player.pause();
    await _player.dispose();
    _eventSubscription.cancel();
    // It is important to wait for this state to be broadcast before we shut
    // down the task. If we don't, the background task will be destroyed before
    // the message gets sent to the UI.
    await _broadcastState();
    // Shut down this task
    await super.onStop();
  }

  /// Jumps away from the current position by [offset].
  Future<void> _seekRelative(Duration offset) async {
    var newPosition = _player.position + offset;
    // Make sure we don't jump out of bounds.
    if (newPosition < Duration.zero) newPosition = Duration.zero;
    if (newPosition > mediaItem.duration) newPosition = mediaItem.duration;
    // Perform the jump via a seek.
    await _player.seek(newPosition);
  }

  /// Begins or stops a continuous seek in [direction]. After it begins it will
  /// continue seeking forward or backward by 10 seconds within the audio, at
  /// intervals of 1 second in app time.
  void _seekContinuously(bool begin, int direction) {
    _seeker?.stop();
    if (begin) {
      _seeker = Seeker(_player, Duration(seconds: 10 * direction),
          Duration(seconds: 1), mediaItem)
        ..start();
    }
  }

  /// Broadcasts the current state to all clients.
  Future<void> _broadcastState() async {
    await AudioServiceBackground.setState(
      controls: [
        MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: [
        MediaAction.seekTo,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      ],
      processingState: _getProcessingState(),
      playing: _player.playing,
      position: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
    );
  }

  /// Maps just_audio's processing state into into audio_service's playing
  /// state. If we are in the middle of a skip, we use [_skipState] instead.
  AudioProcessingState _getProcessingState() {
    if (_skipState != null) return _skipState;
    switch (_player.processingState) {
      case ProcessingState.none:
        return AudioProcessingState.stopped;
      case ProcessingState.loading:
        return AudioProcessingState.connecting;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
      default:
        throw Exception("Invalid state: ${_player.processingState}");
    }
  }
}

class Seeker {
  final AudioPlayer player;
  final Duration positionInterval;
  final Duration stepInterval;
  final MediaItem mediaItem;
  bool _running = false;

  Seeker(
    this.player,
    this.positionInterval,
    this.stepInterval,
    this.mediaItem,
  );

  Future start() async {
    _running = true;
    while (_running) {
      Duration newPosition = player.position + positionInterval;
      if (newPosition < Duration.zero) newPosition = Duration.zero;
      if (newPosition > mediaItem.duration) newPosition = mediaItem.duration;
      player.seek(newPosition);
      await Future<dynamic>.delayed(stepInterval);
    }
  }

  void stop() {
    _running = false;
  }
}
