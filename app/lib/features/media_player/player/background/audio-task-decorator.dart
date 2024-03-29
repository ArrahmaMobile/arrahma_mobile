import 'package:audio_service/audio_service.dart';

import 'audio-context.dart';
import 'icontext-audio-task.dart';

/// Supports mixing and matching audio tasks
class AudioTaskDecorater extends BackgroundAudioTask
    implements IContextAudioTask {
  AudioTaskDecorater({this.baseTask});

  final IContextAudioTask baseTask;

  @override
  AudioContext get context => baseTask.context;

  @override
  Future<void> onStart(Map<String, dynamic> params) => baseTask.onStart(params);

  @override
  // (base task is responsible to call super.onStop())
  // ignore: must_call_super
  Future<void> onStop() => baseTask.onStop();

  @override
  Future<void> onPause() => baseTask.onPause();

  @override
  Future<void> onPlay() => baseTask.onPlay();

  @override
  Future<void> onPlayFromMediaId(String mediaId) =>
      baseTask.onPlayFromMediaId(mediaId);

  @override
  Future<void> onSkipToQueueItem(String mediaId) =>
      baseTask.onSkipToQueueItem(mediaId);

  @override
  Future<void> onUpdateQueue(List<MediaItem> queue) =>
      baseTask.onUpdateQueue(queue);

  @override
  Future<void> onFastForward() => baseTask.onFastForward();

  @override
  Future<void> onRewind() => baseTask.onRewind();

  @override
  Future<void> onSeekTo(Duration position) => baseTask.onSeekTo(position);
  @override
  Future<dynamic> onCustomAction(String name, dynamic arguments) =>
      baseTask.onCustomAction(name, arguments);

  @override
  Future<void> onSetSpeed(double speed) => baseTask.onSetSpeed(speed);

  @override
  Future<void> onTaskRemoved() => baseTask.onTaskRemoved();

  @override
  Future<void> onClose() => baseTask.onClose();
}
