import 'package:arrahma_mobile_app/core/utils.dart';
import 'package:arrahma_mobile_app/features/media_player/audio_player_controls.dart';
import 'package:arrahma_mobile_app/features/media_player/media_player_view.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import 'audio_player_display.dart';
import 'media_player_service.dart';

class CollapsedPlayer extends StatefulWidget {
  const CollapsedPlayer({
    Key key,
  }) : super(key: key);

  @override
  _CollapsedPlayerState createState() => _CollapsedPlayerState();
}

class _CollapsedPlayerState extends State<CollapsedPlayer> {
  bool isClosed;

  @override
  void initState() {
    super.initState();
    isClosed = false;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ScreenState>(
        stream: MediaPlayerService.screenStateStream,
        builder: (_, snapshot) {
          final screenState = snapshot.data;
          final item = screenState?.mediaItem;
          final state = screenState?.playbackState;
          final finished = state?.processingState != null &&
              [AudioProcessingState.completed, AudioProcessingState.stopped]
                  .contains(state?.processingState);
          return AnimatedCrossFade(
            crossFadeState:
                snapshot.hasData && item != null && !finished && !isClosed
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
            firstChild: Column(
              children: [
                const SizedBox(height: 9),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                ),
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0)
                        .add(const EdgeInsets.only(top: 10)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            child: AudioPlayerDisplay(
                          item: item,
                          dense: true,
                          onClose: () {
                            setState(() {
                              isClosed = true;
                            });
                          },
                        )),
                        AudioPlayerControlBar(screenState: screenState),
                      ],
                    ),
                  ),
                  onTap: () {
                    Utils.pushView(
                      context,
                      null,
                      MediaPlayerView(
                          mediaItems: screenState.queue,
                          initialAudioIndex: screenState.queueIndex > 0
                              ? screenState.queueIndex
                              : 0),
                    );
                  },
                )
              ],
            ),
            secondChild: Container(),
            duration: const Duration(milliseconds: 200),
          );
        });
  }
}
