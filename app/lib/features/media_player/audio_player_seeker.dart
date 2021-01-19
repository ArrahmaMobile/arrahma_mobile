import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';

import 'media_player_service.dart';
import 'player/index.dart';

class AudioPlayerSeeker extends StatelessWidget {
  const AudioPlayerSeeker(
      {Key key, @required this.mediaItem, @required this.state})
      : super(key: key);
  final MediaItem mediaItem;
  final PlaybackState state;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Position>(
      stream: positionManager.positionStream,
      builder: (context, snapshot) {
        final position = snapshot.data?.position?.inMilliseconds?.toDouble() ??
            state?.currentPosition?.inMilliseconds?.toDouble();
        final duration = mediaItem?.duration?.inMilliseconds?.toDouble();
        final value = max(0.0, min(position ?? 0, duration ?? 0));
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Text(DurationUtils.durationToString(
                  state?.currentPosition ?? const Duration(seconds: 0))),
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
