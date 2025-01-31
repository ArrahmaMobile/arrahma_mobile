import 'package:arrahma_mobile_app/features/media_player/media_player_view.dart';
import 'package:arrahma_mobile_app/features/media_player/models/extended_media_item.dart';
import 'package:arrahma_mobile_app/features/media_player/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';
import 'package:inherited_state/inherited_state.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerControlButtons extends StatelessWidget {
  AudioPlayerControlButtons({super.key, required this.player});
  final AudioPlayer player;

  final storageService = SL.get<IStorageService>()!;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 46,
        ),
        IconButton(
          icon: const Icon(Icons.volume_up),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: 'Adjust volume',
              divisions: 10,
              min: 0.0,
              max: 1.0,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(Icons.skip_previous),
            onPressed: player.hasPrevious
                ? () async {
                    await player.seekToPrevious();
                    storageService.setWithKey(
                        lastPlayedIndexKey, player.currentIndex);
                  }
                : null,
          ),
        ),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(Icons.play_arrow),
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.replay),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero,
                    index: player.effectiveIndices!.first),
              );
            }
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: const Icon(Icons.skip_next),
            onPressed: player.hasNext
                ? () async {
                    await player.seekToNext();
                    storageService.setWithKey(
                        lastPlayedIndexKey, player.currentIndex);
                  }
                : null,
          ),
        ),
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text('${snapshot.data?.toStringAsFixed(1)}x',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: 'Adjust speed',
                divisions: 15,
                min: 0.5,
                max: 2,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
        OfflineStorageButton(player: player),
      ],
    );
  }
}

class OfflineStorageButton extends StatefulWidget {
  const OfflineStorageButton({super.key, required this.player});

  final AudioPlayer player;

  @override
  State<OfflineStorageButton> createState() => _OfflineStorageButtonState();
}

class _OfflineStorageButtonState extends State<OfflineStorageButton> {
  final Set<String> _donwloadingIds = {};
  final Set<String> _cachedIds = {};
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SequenceState?>(
        stream: widget.player.sequenceStateStream,
        builder: (_, s) {
          final metadata = s.data?.currentSource!.tag as ExtendedMediaItem?;
          final isOriginallyCached = metadata?.isCached ?? false;

          final _isDownloading = _donwloadingIds.contains(metadata?.id);
          final _isCached = _cachedIds.contains(metadata?.id);
          final isCached = _isCached || isOriginallyCached;

          return IconButton(
            tooltip: isCached
                ? 'Downloaded'
                : _isDownloading
                    ? 'Downloading'
                    : 'Download for offline',
            icon: Icon(
              isCached
                  ? Icons.download_done
                  : _isDownloading
                      ? Icons.downloading
                      : Icons.download_for_offline_outlined,
              weight: .1,
              size: 30,
            ),
            onPressed: !isCached && !_isDownloading
                ? () async {
                    _donwloadingIds.add(metadata!.id);
                    setState(() {});
                    await LockCachingAudioSource(Uri.parse(metadata.id))
                        .request();
                    _donwloadingIds.remove(metadata.id);
                    _cachedIds.add(metadata.id);
                    setState(() {});
                  }
                : null,
          );
        });
  }
}
