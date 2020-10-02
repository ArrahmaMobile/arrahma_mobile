import 'package:arrahma_mobile_app/features/media_player/audio_player_controls.dart';
import 'package:arrahma_mobile_app/features/media_player/audio_player_service.dart';
import 'package:flutter/material.dart';
import 'package:inherited_state/inherited_state.dart';

import 'audio_player_display.dart';

class CollapsedPlayer extends StatefulWidget {
  @override
  _CollapsedPlayerState createState() => _CollapsedPlayerState();
}

class _CollapsedPlayerState extends State<CollapsedPlayer> {
  final _audioPlayer = SL.get<AudioPlayerService>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _audioPlayer.audioStream,
      builder: (_, snapshot) => snapshot.hasData
          ? Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                ),
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        AudioPlayerDisplay(),
                        AudioPlayerControlBar(),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/media_player_screen');
                  },
                )
              ],
            )
          : Container(),
    );
  }
}
