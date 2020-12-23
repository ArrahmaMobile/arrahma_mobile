import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:inherited_state/inherited_state.dart';

import 'audio_player_service.dart';

class AudioPlayerDisplay extends StatefulWidget {
  const AudioPlayerDisplay({
    Key key,
    this.item,
    this.dense = false,
  }) : super(key: key);
  final MediaItem item;
  final bool dense;

  @override
  _AudioPlayerDisplayState createState() => _AudioPlayerDisplayState();
}

class _AudioPlayerDisplayState extends State<AudioPlayerDisplay> {
  final _audioPlayer = SL.get<AudioPlayerService>();

  @override
  Widget build(BuildContext context) {
    return widget.item != null
        ? _buildDisplay(widget.item)
        : StreamBuilder<MediaItem>(
            stream: _audioPlayer.audioStream,
            builder: (_, snapshot) =>
                _buildDisplay(snapshot.data, snapshot.hasData),
          );
  }

  Widget _buildDisplay(MediaItem item, [bool isLoading = false]) {
    return Column(
      children: [
        if (item?.album != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Text(
                item?.album,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: widget.dense ? 16 : 18),
                textAlign: TextAlign.center,
              ),
              GestureDetector(
                onTap: () {}, // NEED TO WORK ON
                child: const Icon(
                  Icons.insert_comment_rounded,
                  size: 15,
                ),
              ),
            ],
          ),
        const SizedBox(height: 10),
        Text(
          item?.title ?? (isLoading ? 'Loading...' : 'Unknown'),
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: widget.dense ? 16 : 18),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
