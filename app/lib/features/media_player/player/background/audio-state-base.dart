import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../util/playback-state-extensions.dart';
import 'audio-context.dart';
import 'audio-states/stopped-state.dart';

/// Deals with state for a given state.
abstract class MediaStateBase {
  MediaStateBase({this.context, this.reactToStream = true});

  static const stateToStateMap = {
    ProcessingState.loading: AudioProcessingState.connecting,
    ProcessingState.idle: AudioProcessingState.none,
    ProcessingState.completed: AudioProcessingState.completed,
    ProcessingState.ready: AudioProcessingState.ready,
    ProcessingState.buffering: AudioProcessingState.buffering
  };

  static Set<MediaAction> getAction(ProcessingState state, bool playing) {
    switch (state) {
      case ProcessingState.loading:
      case ProcessingState.idle:
      case ProcessingState.completed:
        return {
          MediaAction.playFromMediaId,
          MediaAction.skipToPrevious,
          MediaAction.skipToNext,
        };
      case ProcessingState.buffering:
      case ProcessingState.ready:
        return {
          if (!playing) MediaAction.play,
          if (playing) MediaAction.pause,
          MediaAction.stop,
          MediaAction.playFromMediaId,
          MediaAction.fastForward,
          MediaAction.rewind,
          MediaAction.seekTo,
          MediaAction.skipToPrevious,
          MediaAction.skipToNext,
        };
      default:
        throw Exception('Unhandled state: $state');
    }
  }

  final AudioContextBase context;

  /// Whether media player state streams should be ignored.
  bool reactToStream;

  /// Called by [AudioContext] whenever [AudioPlayer] raises an event.
  /// Uses [reactToStream] to ignore events if a particular [MediaStateBase] doesn't
  /// want that event to be handled for whatever reason.
  Future<void> onPlaybackEvent(PlaybackEvent event) async {
    if (reactToStream) {
      await context.setPlaybackState(PlaybackState(
          processingState: stateToStateMap[event.processingState],
          // TODO: playing should come from a stream.
          actions:
              getAction(event.processingState, context.mediaPlayer.playing),
          position: event.updatePosition,
          updateTime: event.updateTime,
          playing: context.mediaPlayer.playing,
          bufferedPosition: event.bufferedPosition,
          speed: context.mediaPlayer.speed));
    }
  }

  Future<void> setItem(String mediaId);
  Future<void> pause();
  Future<void> play();
  Future<void> seek(Duration position);
  Future<void> stop() async {
    context.stateHandler = StoppedState(context: context);
    await context.stateHandler.stop();
  }

  Future<void> setVolume(double volume) =>
      context.mediaPlayer.setVolume(volume);

  /// Set playback speed. By default, updates the [AudioContext.generalPlaybackSettings] but not the
  /// speed, to allow changing speed while paused without returning to play.
  Future<void> setSpeed(double speed) async {
    context.generalPlaybackSettings =
        context.generalPlaybackSettings?.copyWith(speed: speed) ??
            GeneralPlaybackSettings(speed: speed);

    // Even if nothing is playing right now, the UI should know what the speed
    // will be (eventually).

    await context
        .setPlaybackState(context.playBackState.copyWith(speed: speed));
  }

  Future<void> setMediaState(
      {@required AudioProcessingState state,
      @required ProcessingState justAudioState,
      Duration position}) async {
    if (context.stateHandler != this) {
      return;
    }

    position ??= context.upcomingPlaybackSettings?.position ?? Duration.zero;

    await context.setPlaybackState(PlaybackState(
        processingState: state,
        // TODO: playing should come from stream.
        actions: getAction(justAudioState, context.mediaPlayer.playing),
        position: position,
        updateTime: DateTime.now(),
        speed: context.generalPlaybackSettings?.speed ?? 1,
        // TODO: playing should come from stream.
        playing: context.mediaPlayer.playing,
        bufferedPosition: context.mediaPlayer.playbackEvent.bufferedPosition));
  }

  /// Set the [UpcomingPlaybackSettings.position] of [AudioContextBase.upcomingPlaybackSettings] to the given position.
  void setFutureSeekValue(Duration position) =>
      context.upcomingPlaybackSettings =
          UpcomingPlaybackSettings(position: position);
}
