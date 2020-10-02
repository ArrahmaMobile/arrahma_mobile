import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:inherited_state/inherited_state.dart';

import 'audio_player_service.dart';

class AudioPlayerDisplay extends StatefulWidget {
  const AudioPlayerDisplay({Key key, this.item}) : super(key: key);
  final MediaItem item;

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
        Text(
          item?.album ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          item?.title ?? (isLoading ? 'Loading...' : 'Unknown'),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
