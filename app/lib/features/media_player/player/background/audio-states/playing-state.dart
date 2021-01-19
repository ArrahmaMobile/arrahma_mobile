import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';

import '../audio-context.dart';
import '../audio-state-base.dart';
import 'connecting-state.dart';
import 'seeking-state.dart';

class PlayingState extends MediaStateBase {
  PlayingState({@required AudioContextBase context}) : super(context: context);

  @override
  Future<void> pause() => context.mediaPlayer.pause();

  @override
  Future<void> seek(Duration position) async {
    context.stateHandler = SeekingState(context: context) as MediaStateBase;
    await context.stateHandler.seek(position);
  }

  @override
  Future<void> setSpeed(double speed) async {
    await super.setSpeed(speed);

    if (context.playBackState.playing) {
      await context.mediaPlayer.setSpeed(speed);
    }
  }

  @override
  Future<void> play() async {
    context.mediaPlayer.play();

    // Respond to seek request that was placed before playback started (when seeking wasn't neccessarily
    // possible yet).
    if (context.upcomingPlaybackSettings?.position != null) {
      await seek(context.upcomingPlaybackSettings.position);
      // Reset the upcoming position. We don't want to go back there every time
      // user plays, for example after a pause.
      super.setFutureSeekValue(null);
    }

    if (context.generalPlaybackSettings != null) {
      if (context.generalPlaybackSettings.speed != null) {
        await setSpeed(context.generalPlaybackSettings.speed);
      }

      // Check that we're at the right volume.
      final desiredVolume = context.generalPlaybackSettings.volume;
      if (desiredVolume != null &&
          desiredVolume != context.mediaPlayer.volume) {
        // Don't await the set volume future - doesn't effect any other state.
        context.mediaPlayer.setVolume(desiredVolume);
      }
    }
  }

  @override
  Future<void> setItem(String mediaId) async {
    // No need to connect if we already did.
    // TODO: this check is in every change to ConnectingState. This should be less manual.
    final url = mediaId;
    if (url == context.mediaItem.id) {
      return;
    }

    context.stateHandler = ConnectingState(context: context);
    await context.stateHandler.setItem(mediaId);
  }
}
