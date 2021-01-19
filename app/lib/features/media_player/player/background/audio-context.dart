import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import 'audio-state-base.dart';
import 'audio-states/none-state.dart';

// TODO: The control buttons should be configurable.

const playControl = MediaControl(
  androidIcon: 'drawable/ic_action_play_arrow',
  label: 'Play',
  action: MediaAction.play,
);

const pauseControl = MediaControl(
  androidIcon: 'drawable/ic_action_pause',
  label: 'Pause',
  action: MediaAction.pause,
);

const stopControl = MediaControl(
  androidIcon: 'drawable/ic_action_stop',
  label: 'Stop',
  action: MediaAction.stop,
);

/// just_audio_plugin implements the state pattern.
/// There is one class, [AudioContext] which serves as the center point to the
/// changing states, and several state classes inherited from [MediaStateBase]
/// which define and handle audio events and commands appropriately in
/// accordance to the state which they are designed to handle.

/// Audio settings which effect all audio.
class GeneralPlaybackSettings {
  GeneralPlaybackSettings({this.speed, this.volume});

  /// The current speed.
  final double speed;

  /// The current volume.
  final double volume;

  GeneralPlaybackSettings copyWith({double speed, double volume}) =>
      GeneralPlaybackSettings(
          speed: speed ?? this.speed, volume: volume ?? this.volume);
}

/// Audio state information which isn't usable now, but will be used when
/// possible. After it is used, it should be set to null.
///
/// For example, when no audio is loaded we can't seek, but we can set that
/// when we can seek, go to a certain position.
class UpcomingPlaybackSettings {
  UpcomingPlaybackSettings({@required this.position});
  final Duration position;
}

extension UpcomingPlaybackSettingsExtensions on UpcomingPlaybackSettings {
  UpcomingPlaybackSettings copyWith({Duration position}) =>
      UpcomingPlaybackSettings(position: position ?? this?.position);
}

/// Functionality which the [MediaStateBase] classes will use to mantain state.
abstract class AudioContextBase {
  AudioContextBase({@required this.mediaPlayer}) {
    stateHandler = NoneState(context: this);

    mediaPlayer.playbackEventStream
        .listen((e) => stateHandler.onPlaybackEvent(e));
  }

  final AudioPlayer mediaPlayer;

  MediaStateBase stateHandler;

  Stream<PlaybackState> get mediaStateStream;

  /// Get current media item.
  MediaItem get mediaItem;

  /// Set current media item index.
  set mediaItem(MediaItem item);

  MediaItem getItemFromId(String mediaId);

  /// Get current queue.
  Iterable<MediaItem> get queue;

  /// Set current media item.
  set queue(Iterable<MediaItem> queue);

  /// Get the current playback state.
  PlaybackState get playBackState;

  /// Usually, the URL is the ID. Sometimes (eg when the url which is being played
  /// is a file URL), it isn't. Here, map URLs to IDs.
  Map<String, String> urlToIdMap = {};

  /// Returns the correct ID for the URL, even if the URL is e.g. a file url.
  String getIdFromUrl(String url) => urlToIdMap[url] ?? url;

  /// Set the current playback state.
  Future<void> setPlaybackState(PlaybackState playbackState);

  GeneralPlaybackSettings get generalPlaybackSettings;
  set generalPlaybackSettings(GeneralPlaybackSettings generalPlaybackSettings);

  UpcomingPlaybackSettings get upcomingPlaybackSettings;
  set upcomingPlaybackSettings(
      UpcomingPlaybackSettings upcomingPlaybackSettings);
}

class AudioContext extends AudioContextBase {
  AudioContext() : super(mediaPlayer: AudioPlayer());
  MediaItem _mediaItem;
  Map<String, MediaItem> _queue;
  final _mediaStateSubject = BehaviorSubject<PlaybackState>();

  @override
  GeneralPlaybackSettings generalPlaybackSettings;

  @override
  MediaItem get mediaItem => _mediaItem;

  @override
  set mediaItem(MediaItem item) {
    final index = _getIndexFromId(item.id);
    if (index != null && item != queue.elementAt(index)) {
      _queue[item.id] = item;
      AudioServiceBackground.setQueue(queue.toList());
    }
    _mediaItem = item;
    AudioServiceBackground.setMediaItem(mediaItem);
  }

  @override
  Iterable<MediaItem> get queue => _queue.values;
  @override
  set queue(Iterable<MediaItem> queue) {
    AudioServiceBackground.setQueue(queue.toList());
    _queue = queue.fold({}, (map, item) {
      map[item.id] = item;
      return map;
    });
  }

  @override
  MediaItem getItemFromId(String mediaId) {
    return _queue[mediaId];
  }

  int _getIndexFromId(String mediaId) {
    final index = _queue.keys.toList().indexOf(mediaId);
    return index >= 0 ? index : null;
  }

  int get index => _getIndexFromId(mediaItem.id);

  MediaItem getNext() {
    if (!hasNext()) return null;
    return queue.elementAt((index ?? 0) + 1);
  }

  MediaItem getPrevious() {
    if (!hasPrevious()) return null;
    return queue.elementAt((index ?? 0) - 1);
  }

  bool hasNext() {
    return (index ?? 0) + 1 < _queue.length;
  }

  bool hasPrevious() {
    return (index ?? 0) > 0;
  }

  @override
  PlaybackState get playBackState => _mediaStateSubject.value;

  @override
  Future<void> setPlaybackState(playbackState) async {
    await AudioServiceBackground.setState(
        controls: playbackState.playing ? [pauseControl] : [playControl],
        systemActions: playbackState.actions?.toList() ?? [],
        playing: playbackState.playing,
        bufferedPosition: playbackState.bufferedPosition,
        processingState: playbackState.processingState,
        position: playbackState.position,
        speed: playbackState.speed,
        updateTime: playbackState.updateTime);

    _mediaStateSubject.value = playbackState;
  }

  @override
  Stream<PlaybackState> get mediaStateStream =>
      _mediaStateSubject.asBroadcastStream();

  @override
  UpcomingPlaybackSettings upcomingPlaybackSettings;
}
