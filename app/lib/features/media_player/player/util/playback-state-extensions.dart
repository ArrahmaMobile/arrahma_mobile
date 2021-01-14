import 'package:audio_service/audio_service.dart';

extension PlaybackStateExtensions on PlaybackState {
  PlaybackState copyWith(
      {AudioProcessingState processingState,
      Set<MediaAction> actions,
      Duration position,
      double speed,
      DateTime updateTime}) {
    final stateUpdateTime =
        updateTime ?? (position == null ? this.updateTime : DateTime.now());

    return PlaybackState(
      actions: actions ?? this.actions,
      processingState: processingState ?? this.processingState,
      position: position ?? this.position,
      speed: speed ?? this.speed,
      updateTime: stateUpdateTime,
      playing: playing,
      bufferedPosition: bufferedPosition,
      repeatMode: repeatMode,
      shuffleMode: shuffleMode,
    );
  }
}
