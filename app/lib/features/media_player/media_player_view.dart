import 'package:arrahma_mobile_app/features/media_player/audio_player_control_buttons.dart';
import 'package:arrahma_mobile_app/features/media_player/audio_player_media_art.dart';
import 'package:arrahma_mobile_app/features/media_player/audio_player_media_display.dart';
import 'package:arrahma_mobile_app/features/media_player/audio_player_seek_bar.dart';
import 'package:arrahma_mobile_app/features/media_player/models/extended_media_item.dart';
import 'package:arrahma_mobile_app/services/app.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';
import 'package:inherited_state/inherited_state.dart';
import 'package:just_audio/just_audio.dart';

class MediaPlayerView extends StatefulWidget {
  const MediaPlayerView(
      {super.key, required this.mediaItems, this.initialAudioIndex = 0});
  final List<MediaItem> mediaItems;
  final int initialAudioIndex;

  @override
  _MediaPlayerViewState createState() => _MediaPlayerViewState();
}

const lastPlayedIndexKey = 'LAST_PLAYED_INDEX_KEY';
const lastAudioPositionKeyPrefix = 'LAST_AUDIO_POSITION_KEY';

class _MediaPlayerViewState extends State<MediaPlayerView> {
  final appService = SL.get<AppService>()!;
  final storageService = SL.get<IStorageService>()!;

  late AudioPlayer player;

  @override
  void initState() {
    super.initState();
    player = appService.audioPlayer;
    _startAudio();
  }

  MediaItem get initialItem => widget.mediaItems[widget.initialAudioIndex];

  Future _startAudio() async {
    final session = await AudioSession.instance;
    if (!session.isConfigured) {
      await session.configure(const AudioSessionConfiguration.speech());
    }
    player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });

    player.playerStateStream.listen((state) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });

    final currentItem = player.sequenceState?.currentSource?.tag as MediaItem?;
    if (currentItem != null && currentItem.id == initialItem.id) {
      return;
    }

    try {
      final extendedMediaItems =
          await Future.wait(widget.mediaItems.map((e) async {
        final isCached =
            (await LockCachingAudioSource(Uri.parse(e.id)).cacheFile)
                .existsSync();
        return ExtendedMediaItem.fromMediaItem(
          e,
          isCached,
        );
      }));

      storageService.set<List<RawExtendedMediaItem>>(
          extendedMediaItems.map((e) => e.toRawMediaItem()).toList());
      storageService.setWithKey(lastPlayedIndexKey, widget.initialAudioIndex);

      final key = '${lastAudioPositionKeyPrefix}_${initialItem.id}';
      final positionMs = await storageService.getWithKey<int>(key);

      final items = extendedMediaItems
          .map((e) => e.isCached
              ? LockCachingAudioSource(Uri.parse(e.id), tag: e)
              : AudioSource.uri(Uri.parse(e.id), tag: e))
          .toList();
      final currentPlaylist = ConcatenatingAudioSource(
        children: items,
      );
      await player.setAudioSource(
        currentPlaylist,
        initialIndex: widget.initialAudioIndex,
        initialPosition: Duration(milliseconds: positionMs ?? 0),
      );

      await player.play();
    } catch (e) {
      await player.stop();
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        children: <Widget>[
          AudioPlayerMediaArt(player: player),
          AudioPlayerMediaDisplay(
            player: player,
          ),
          const SizedBox(height: 25),
          AudioPlayerSeekBar(
            player: player,
          ),
          const SizedBox(
            height: 20,
          ),
          AudioPlayerControlButtons(
            player: player,
          ),
        ],
      ),
    );
  }
}
