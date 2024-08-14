import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerMediaArt extends StatelessWidget {
  const AudioPlayerMediaArt({super.key, required this.player});

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
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: metadata.artUri != null
                  ? Image.network(metadata.artUri.toString())
                  : const DefaultArrahmahArt()),
        );
      },
    );
  }
}

class DefaultArrahmahArt extends StatelessWidget {
  const DefaultArrahmahArt({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // ignore: prefer_const_literals_to_create_immutables
        boxShadow: [
          const BoxShadow(
            color: Color(0x0ff00000),
            offset: Offset(0, 10),
            spreadRadius: 0,
            blurRadius: 30,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/images/logo.png',
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.4,
        ),
      ),
    );
  }
}
