import 'package:arrahma_mobile_app/core/utils.dart';
import 'package:arrahma_mobile_app/features/media_player/audio_player_control_buttons.dart';
import 'package:arrahma_mobile_app/features/media_player/audio_player_media_display.dart';
import 'package:arrahma_mobile_app/features/media_player/audio_player_seek_bar.dart';
import 'package:arrahma_mobile_app/services/app.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:inherited_state/inherited_state.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class HomePageFooter extends StatefulWidget {
  const HomePageFooter({
    super.key,
    this.defaultFooter,
  });

  final Widget? defaultFooter;

  @override
  _HomePageFooterState createState() => _HomePageFooterState();
}

class _HomePageFooterState extends State<HomePageFooter> {
  final appService = SL.get<AppService>()!;
  late AudioPlayer player;
  late bool isClosed;

  @override
  void initState() {
    super.initState();
    isClosed = false;
    player = appService.audioPlayer;
  }

  Stream<MapEntry<SequenceState?, PlaybackEvent>> get _sequenceStateWithEvent =>
      Rx.combineLatest2<SequenceState?, PlaybackEvent,
              MapEntry<SequenceState?, PlaybackEvent>>(
          player.sequenceStateStream,
          player.playbackEventStream,
          (sequenceState, playbackEvent) =>
              MapEntry(sequenceState, playbackEvent));

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MapEntry<SequenceState?, PlaybackEvent>>(
        stream: _sequenceStateWithEvent,
        builder: (_, snapshot) {
          final playerState = snapshot.data;
          final item = playerState?.key?.currentSource?.tag as MediaItem?;
          final state = playerState?.value;
          final finished = state?.processingState != null &&
              [ProcessingState.completed, ProcessingState.idle]
                  .contains(state?.processingState);
          return AnimatedCrossFade(
            crossFadeState:
                snapshot.hasData && item != null && !finished && !isClosed
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.only(bottom:8.0),
              child: Align(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AudioPlayerSeekBar(
                          player: player,
                          hideThumb: true,
                        ),
                        const SizedBox(height: 4),
                        AudioPlayerRemainingTimer(
                          player: player,
                          showCloseButton: true,
                        ),
                      ],
                    ),
                    Center(
                      child: GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0)
                              .add(const EdgeInsets.only(top: 10)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: AudioPlayerMediaDisplay(
                                  player: player,
                                  // onClose: () {
                                  //   widget.player.stop();
                                  //   setState(() {
                                  //     isClosed = true;
                                  //   });
                                  // },
                                ),
                              ),
                              AudioPlayerControlButtons(
                                player: player,
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Utils.openAudio(
                            context,
                            playerState!.key!.sequence
                                .map((e) => e.tag as MediaItem)
                                .toList(),
                            playerState.key!.currentIndex > 0
                                ? playerState.key!.currentIndex
                                : 0,
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            secondChild: widget.defaultFooter ?? const SizedBox(),
            duration: const Duration(milliseconds: 200),
          );
        });
  }
}
