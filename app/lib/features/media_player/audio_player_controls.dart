import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:inherited_state/inherited_state.dart';

import 'audio_player_service.dart';

class AudioPlayerControlBar extends StatefulWidget {
  const AudioPlayerControlBar({
    Key key,
    this.onNext,
    this.onPrevious,
    this.onStart,
  }) : super(key: key);
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onStart;

  @override
  _AudioPlayerControlBarState createState() => _AudioPlayerControlBarState();
}

class _AudioPlayerControlBarState extends State<AudioPlayerControlBar> {
  final _audioPlayer = SL.get<AudioPlayerService>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackState>(
        stream: _audioPlayer.playbackStateStream,
        builder: (_, playbackSnapshot) {
          final showingPlayButton = playbackSnapshot.hasData &&
              (playbackSnapshot.data.processingState ==
                      AudioProcessingState.completed ||
                  playbackSnapshot.data.processingState ==
                      AudioProcessingState.stopped ||
                  (playbackSnapshot.data.processingState ==
                          AudioProcessingState.ready &&
                      !playbackSnapshot.data.playing));
          final showingPauseButton = playbackSnapshot.hasData &&
              (playbackSnapshot.data.processingState ==
                      AudioProcessingState.ready &&
                  playbackSnapshot.data.playing);
          return StreamBuilder<List<MediaItem>>(
              stream: _audioPlayer.queueStream,
              builder: (context, queueSnapshot) {
                final queue = queueSnapshot.data;
                return StreamBuilder<MediaItem>(
                    stream: _audioPlayer.audioStream,
                    builder: (context, itemSnapshot) {
                      final item = itemSnapshot.data;
                      final allowPrevious = playbackSnapshot.hasData &&
                          playbackSnapshot.data.actions
                              .contains(MediaAction.skipToPrevious) &&
                          queue.first != item &&
                          queue.length > 1;
                      final allowNext = playbackSnapshot.hasData &&
                          playbackSnapshot.data.actions
                              .contains(MediaAction.skipToNext) &&
                          queue.last != item &&
                          queue.length > 1;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(
                              Icons.skip_previous,
                            ),
                            onPressed: allowPrevious
                                ? () {
                                    if (widget.onPrevious != null)
                                      widget.onPrevious();
                                    AudioService.skipToPrevious();
                                  }
                                : null,
                          ),
                          SizedBox(
                            height: 56,
                            width: 56,
                            child: Center(
                              child: showingPauseButton || showingPlayButton
                                  ? IconButton(
                                      icon: Icon(
                                        showingPlayButton
                                            ? Icons.play_arrow
                                            : Icons.pause,
                                        size: 32,
                                      ),
                                      onPressed: () {
                                        if (showingPauseButton) {
                                          _audioPlayer.pause();
                                        } else {
                                          if (showingPlayButton)
                                            _audioPlayer.play();
                                          else if (widget.onStart != null) {
                                            widget.onStart();
                                          }
                                        }
                                      },
                                    )
                                  : const CircularProgressIndicator(),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.skip_next,
                            ),
                            onPressed: allowNext
                                ? () {
                                    if (widget.onNext != null) widget.onNext();
                                    AudioService.skipToNext();
                                  }
                                : null,
                          ),
                        ],
                      );
                    });
              });
        });
  }
}
