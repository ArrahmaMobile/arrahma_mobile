import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_framework/flutter_framework.dart';
import './player/index.dart';
import 'package:rxdart/rxdart.dart';

final positionManager =
    PositionManager(positionDataManager: HivePositionDataManager());
// PositionManager.positionUpdateTime = const Duration(seconds: 1);

void main() {
  runApp(new MyApp());
}

const audioUrl =
    "https://insidechassidus.org/wp-content/uploads/classes/Life Lessons/Avoda/simcha_MM_2007_64bit.mp3";

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Audio Service Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: AudioServiceWidget(child: MainScreen()),
      );
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Service Demo'),
      ),
      body: Center(
        child: StreamBuilder<ScreenState>(
          stream: _screenStateStream,
          builder: (context, snapshot) {
            final screenState = snapshot.data;
            final mediaItem = screenState?.mediaItem;
            final state = screenState?.playbackState;
            final processingState =
                state?.processingState ?? AudioProcessingState.none;
            final playing = state?.playing ?? false;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (mediaItem?.title != null) Text(mediaItem.title),
                if (processingState == AudioProcessingState.none) ...[
                  audioPlayerButton(),
                ] else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (playing) pauseButton() else playButton(),
                      stopButton(),
                    ],
                  ),
                if (processingState != AudioProcessingState.none &&
                    processingState != AudioProcessingState.stopped) ...[
                  positionIndicator(mediaItem, state),
                  Text("Processing state: " + "$processingState"),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  /// Encapsulate all the different data we're interested in into a single
  /// stream so we don't have to nest StreamBuilders.
  Stream<ScreenState> get _screenStateStream =>
      Rx.combineLatest2<MediaItem, PlaybackState, ScreenState>(
          AudioService.currentMediaItemStream,
          AudioService.playbackStateStream,
          (mediaItem, playbackState) => ScreenState(mediaItem, playbackState));

  RaisedButton audioPlayerButton() => startButton(
      'AudioPlayer',
      () => AudioService.start(
            backgroundTaskEntrypoint: _audioPlayerTaskEntrypoint,
            androidNotificationChannelName: 'Audio Service Demo',
            // Enable this if you want the Android service to exit the foreground state on pause.
            // androidStopForegroundOnPause: true,
            androidNotificationColor: 0xFF2196f3,
            androidNotificationIcon: 'mipmap/ic_launcher',
          ).then((value) async {
            await AudioService.playFromMediaId(audioUrl);
          }));

  RaisedButton startButton(String label, VoidCallback onPressed) =>
      RaisedButton(
        child: Text(label),
        onPressed: onPressed,
      );

  IconButton playButton() => IconButton(
        icon: Icon(Icons.play_arrow),
        iconSize: 64.0,
        onPressed: AudioService.play,
      );

  IconButton pauseButton() => IconButton(
        icon: Icon(Icons.pause),
        iconSize: 64.0,
        onPressed: AudioService.pause,
      );

  IconButton stopButton() => IconButton(
        icon: Icon(Icons.stop),
        iconSize: 64.0,
        onPressed: AudioService.stop,
      );

  Widget positionIndicator(MediaItem mediaItem, PlaybackState state) {
    return StreamBuilder<Position>(
      stream: positionManager.positionStream,
      builder: (context, snapshot) {
        double position = snapshot.data?.position?.inMilliseconds?.toDouble() ??
            state.currentPosition.inMilliseconds.toDouble();
        double duration = mediaItem?.duration?.inMilliseconds?.toDouble();
        double value = max(0.0, min(position, duration ?? 0));
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Text(DurationUtils.durationToString(state.currentPosition)),
              Expanded(
                child: Slider(
                  min: 0.0,
                  max: duration ?? 0,
                  value: value,
                  onChanged: duration != null
                      ? (value) {
                          positionManager
                              .seek(Duration(milliseconds: value.floor()));
                        }
                      : null,
                ),
              ),
              Text(DurationUtils.durationToString(
                  mediaItem?.duration ?? const Duration(seconds: 0))),
            ],
          ),
        );
      },
    );
  }
}

class ScreenState {
  final MediaItem mediaItem;
  final PlaybackState playbackState;

  ScreenState(this.mediaItem, this.playbackState);
}

// NOTE: Your entrypoint MUST be a top-level function.
void _audioPlayerTaskEntrypoint() {
  AudioServiceBackground.run(() => PositionedAudioTask.standard());
}
