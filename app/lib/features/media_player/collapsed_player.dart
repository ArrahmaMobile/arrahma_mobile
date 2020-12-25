import 'package:arrahma_mobile_app/features/media_player/audio_player_controls.dart';
import 'package:arrahma_mobile_app/features/media_player/audio_player_service.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:inherited_state/inherited_state.dart';

import 'audio_player_display.dart';

class CollapsedPlayer extends StatefulWidget {
  const CollapsedPlayer({
    Key key,
  }) : super(key: key);

  @override
  _CollapsedPlayerState createState() => _CollapsedPlayerState();
}

class _CollapsedPlayerState extends State<CollapsedPlayer> {
  final _audioPlayer = SL.get<AudioPlayerService>();

  bool isClosed;

  @override
  void initState() {
    super.initState();
    isClosed = false;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackState>(
      stream: _audioPlayer.playbackStateStream,
      builder: (_, playbackSnapshot) {
        final finished = playbackSnapshot.data?.processingState != null &&
            [AudioProcessingState.completed, AudioProcessingState.stopped]
                .contains(playbackSnapshot.data.processingState);
        return StreamBuilder(
          stream: _audioPlayer.audioStream,
          builder: (_, snapshot) => AnimatedCrossFade(
            crossFadeState: snapshot.hasData && !finished && !isClosed
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
                          dense: true,
                          onClose: () {
                            setState(() {
                              isClosed = true;
                            });
                          },
                        )),
                        AudioPlayerControlBar(),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/media_player_screen');
                  },
                )
              ],
            ),
            secondChild: Container(),
            duration: const Duration(milliseconds: 200),
          ),
        );
      },
    );
  }
}
