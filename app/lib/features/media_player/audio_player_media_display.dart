import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerMediaDisplay extends StatelessWidget {
  const AudioPlayerMediaDisplay({super.key, required this.player});

  final AudioPlayer player;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SequenceState?>(
      stream: player.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state?.sequence.isEmpty ?? true) {
          return const SizedBox();
        }
        final metadata = state!.currentSource!.tag as MediaItem;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(metadata.album!,
                style: Theme.of(context).textTheme.titleLarge),
            Text(metadata.title),
          ],
        );
      },
    );
  }
}
