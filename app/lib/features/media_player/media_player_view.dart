import 'package:arrahma_mobile_app/features/media_player/audio_player_controls.dart';
import 'package:arrahma_mobile_app/features/media_player/audio_player_display.dart';
import 'package:arrahma_mobile_app/features/media_player/media_player_service.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import 'audio_player_seeker.dart';

class MediaPlayerView extends StatefulWidget {
  const MediaPlayerView(
      {Key key, @required this.mediaItems, this.initialAudioIndex = 0})
      : super(key: key);
  final List<MediaItem> mediaItems;
  final int initialAudioIndex;

  @override
  _MediaPlayerViewState createState() => _MediaPlayerViewState();
}

class _MediaPlayerViewState extends State<MediaPlayerView> {
  @override
  void initState() {
    super.initState();
    _startAudio();
  }

  MediaItem get initialItem => widget.mediaItems[widget.initialAudioIndex];

  Future _startAudio() async {
    MediaPlayerService.start(widget.mediaItems, widget.initialAudioIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: StreamBuilder<ScreenState>(
          stream: MediaPlayerService.screenStateStream,
          builder: (_, snapshot) => Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
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
              ),
              const SizedBox(height: 20),
              AudioPlayerDisplay(item: snapshot.data?.mediaItem ?? initialItem),
              const SizedBox(height: 25),
              AudioPlayerSeeker(
                mediaItem: snapshot.data?.mediaItem,
                state: snapshot.data?.playbackState,
              ),
              const SizedBox(
                height: 20,
              ),
              AudioPlayerControlBar(
                screenState: snapshot.data,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
