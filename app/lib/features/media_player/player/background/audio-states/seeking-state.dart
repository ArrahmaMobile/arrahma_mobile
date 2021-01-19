import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../audio-context.dart';
import '../audio-state-base.dart';
import 'connecting-state.dart';
import 'playing-state.dart';

class SeekingState extends MediaStateBase {
  /// Keep track of if we give up on seeking in the middle. For example, connect to other media.
  bool get didAbandonSeek => !didPersistSeek;

  /// Keep track of if we give up on seeking in the middle. For example, connect to other media.
  bool get didPersistSeek => this == context.stateHandler;

  Completer<void> _doneSeeking;

  SeekingState({@required AudioContextBase context}) : super(context: context);

  @override
  Future<void> pause() async {
    await _doneSeeking.future;
    if (didPersistSeek) await context.stateHandler.pause();
  }

  @override
  Future<void> play() async {
    await _doneSeeking.future;
    if (didPersistSeek) await context.stateHandler.play();
  }

  @override
  Future<void> seek(Duration position) async {
    if (position > context.mediaItem.duration) {
      return;
    }

    super.reactToStream = false;
    _doneSeeking = Completer<void>();

    if (position < Duration.zero) {
      position = Duration.zero;
    }

    final currentPosition = context.playBackState.currentPosition;

    final basicState = position > currentPosition
        ? AudioProcessingState.fastForwarding
        : AudioProcessingState.rewinding;

    // We're trying to get to that spot.
    await setMediaState(
        state: basicState,
        justAudioState: context.mediaPlayer.playerState.processingState,
        position: position);

    try {
      await context.mediaPlayer.seek(position);
    } catch (err) {
      position = currentPosition;
      await context.mediaPlayer.seek(position);
    }

    if (didAbandonSeek) return;

    // We made it to wanted place in media.
    await setMediaState(
        state: MediaStateBase
            .stateToStateMap[context.mediaPlayer.playerState.processingState],
        justAudioState: context.mediaPlayer.processingState,
        position: position);

    // Set the state handler before calling complete() on doneSeeking.
    // This ensures that any calls to play() or pause() go to the playing state, not
    // an unending recursive call.
    context.stateHandler = PlayingState(context: context);

    // Only notify pause method that seeking was completed after everything was done.
    // This simplifies state considerations.
    // It also in theory might create a moment of unwanted playback, so we'll see if this
    // has to change.
    _doneSeeking.complete();

    super.reactToStream = true;
  }

  @override
  Future<void> setItem(String mediaId) async {
    final url = mediaId;
    if (url == context.mediaItem.id) {
      return;
    }

    context.stateHandler = ConnectingState(context: context);
    await context.stateHandler.setItem(mediaId);
  }
}
