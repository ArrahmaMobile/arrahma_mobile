import 'dart:async';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:inherited_state/inherited_state.dart';
import 'package:stream_transform/stream_transform.dart';

import 'audio_player_service.dart';

class AudioPlayerSeeker extends StatefulWidget {
  @override
  _AudioPlayerSeekerState createState() => _AudioPlayerSeekerState();
}

class MediaItemData {
  final MediaItem item;
  final double position;

  MediaItemData(this.item, this.position);
}

class _AudioPlayerSeekerState extends State<AudioPlayerSeeker> {
  final _audioPlayer = SL.get<AudioPlayerService>();

  final _seekController = StreamController<MediaItemData>();

  Stream<MediaItemData> get itemDataStream => _seekController.stream
      .combineLatest<PlaybackState, MediaItemData>(
          _audioPlayer.playbackStateStream,
          (seekPos, state) => MediaItemData(
              seekPos.item,
              seekPos.position ??
                  state.currentPosition.inMilliseconds.toDouble()))
      .combineLatest(Stream<void>.periodic(const Duration(milliseconds: 200)),
          (seekPos, dynamic _) => seekPos)
      .combineLatest<MediaItem, MediaItemData>(
          _audioPlayer.audioStream,
          (itemData, data) =>
              MediaItemData(data ?? itemData.item, itemData.position));

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItemData>(
      stream: itemDataStream,
      builder: (_, snapshot) {
        final position = snapshot.data.position;
        final duration = snapshot.data.item.duration.inMilliseconds.toDouble();
        return Slider(
          min: 0,
          max: duration,
          value: position ?? max(0.0, min(position, duration)),
          onChanged: snapshot.hasData
              ? (v) {
                  _seekController.add(MediaItemData(snapshot.data.item, v));
                }
              : null,
          onChangeEnd: (value) {
            AudioService.seekTo(Duration(milliseconds: value.toInt()));
            _seekController.add(null);
          },
        );
      },
    );
  }
}
