import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

import 'audio-context.dart';
import 'icontext-audio-task.dart';

class AudioTask extends BackgroundAudioTask implements IContextAudioTask {
  @override
  final context = AudioContext();

  AudioPlayer get player => context.mediaPlayer;

  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    // This will be changed when we support playlists.
    // Then, on media completion we'll check if there's another file to play.
    player.playerStateStream
        .where((state) => state.processingState == ProcessingState.completed)
        .listen((_) {
      if (context.hasNext())
        AudioService.skipToNext();
      else
        _dispose();
    });

    final session = await AudioSession.instance;
    session.configure(const AudioSessionConfiguration.speech());

    // player.currentIndexStream.listen((index) {
    //   if (index != null) {
    //     AudioService.playFromMediaId(queue[index].id);
    //   }
    // });

    // Load and broadcast the queue
  }

  // Future<void> load(List<MediaItem> items, [int index = 0]) async {
  //   player.pause();
  //   _queue = items;
  //   AudioServiceBackground.setQueue(queue);
  //   try {
  //     await player.setAudioSource(ConcatenatingAudioSource(
  //       children:
  //           queue.map((item) => AudioSource.uri(Uri.parse(item.id))).toList(),
  //     ));
  //     // In this example, we automatically start playing on start.
  //     if (index != 0) player.seek(Duration.zero, index: index);
  //     onPlay();
  //   } catch (e) {
  //     print('Error: $e');
  //     onStop();
  //   }
  // }

  @override
  // (calls super in dispose)
  // ignore: must_call_super
  Future<void> onStop() async {
    await context.stateHandler.stop();
    await _dispose();
  }

  @override
  Future<void> onPause() => context.stateHandler.pause();

  @override
  Future<void> onPlay() => context.stateHandler.play();

  @override
  Future<void> onPlayFromMediaId(String mediaId) async {
    onSkipToQueueItem(mediaId);
  }

  @override
  Future<void> onUpdateQueue(List<MediaItem> queue) async {
    context.queue = queue;
  }

  @override
  Future<void> onSkipToQueueItem(String mediaId) async {
    final future = context.stateHandler.setItem(mediaId);
    context.stateHandler.play();
    await future;
  }

  @override
  Future<void> onFastForward() =>
      onSeekTo((context.playBackState?.currentPosition ?? Duration.zero) +
          const Duration(seconds: 15));

  @override
  Future<void> onRewind() =>
      onSeekTo((context.playBackState?.currentPosition ?? Duration.zero) -
          const Duration(seconds: 15));

  @override
  Future<void> onSeekTo(Duration position) =>
      context.stateHandler.seek(position);

  @override
  Future<dynamic> onCustomAction(String name, dynamic arguments) async {}

  Future<void> _dispose() async {
    await context.mediaPlayer.dispose();
    await super.onStop();
  }

  @override
  Future<void> onSetSpeed(double speed) => context.stateHandler.setSpeed(speed);
}
