import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'media_player_service.dart';

class AudioPlayerControlBar extends StatelessWidget {
  const AudioPlayerControlBar({
    Key key,
    @required this.screenState,
    this.onNext,
    this.onPrevious,
    this.onStart,
    this.onPause,
  }) : super(key: key);
  final ScreenState screenState;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onStart;
  final VoidCallback onPause;

  @override
  Widget build(BuildContext context) {
    final item = screenState?.mediaItem;
    final state = screenState?.playbackState;
    final processingState = state?.processingState ?? AudioProcessingState.none;
    final queue = screenState?.queue ?? [];

    final playing = state?.playing ?? false;
    final loading = [
      AudioProcessingState.connecting,
      AudioProcessingState.buffering,
      AudioProcessingState.fastForwarding,
      AudioProcessingState.rewinding,
    ].contains(processingState);

    final allowPrevious =
        (state?.actions?.contains(MediaAction.skipToPrevious) ?? false) &&
            queue.length > 1 &&
            queue.first != item;
    final allowNext =
        (state?.actions?.contains(MediaAction.skipToNext) ?? false) &&
            queue.length > 1 &&
            queue.last != item;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.skip_previous,
          ),
          onPressed: allowPrevious
              ? () {
                  MediaPlayerService.skipToPrevious();
                  onPrevious?.call();
                }
              : null,
        ),
        SizedBox(
          height: 56,
          width: 56,
          child: Center(
            child: !loading
                ? IconButton(
                    icon: Icon(
                      playing ? Icons.pause : Icons.play_arrow,
                      size: 32,
                    ),
                    onPressed: () {
                      if (playing) {
                        MediaPlayerService.pause();
                        onPause?.call();
                      } else {
                        MediaPlayerService.play();
                        onStart?.call();
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
                  MediaPlayerService.skipToNext();
                  onNext?.call();
                }
              : null,
        ),
      ],
    );
  }
}
