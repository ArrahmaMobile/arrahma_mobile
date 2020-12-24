import 'package:arrahma_mobile_app/features/media_player/audio_player_controls.dart';
import 'package:arrahma_mobile_app/features/media_player/audio_player_display.dart';
import 'package:arrahma_mobile_app/features/media_player/audio_player_seeker.dart';
import 'package:arrahma_mobile_app/features/media_player/audio_player_service.dart';
import 'package:arrahma_mobile_app/features/media_player/models/media_data.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:inherited_state/inherited_state.dart';

class MediaPlayerScreen extends StatefulWidget {
  const MediaPlayerScreen(
      {Key key, @required this.mediaItems, this.initialAudioIndex = 0})
      : super(key: key);
  final List<MediaData> mediaItems;
  final int initialAudioIndex;

  @override
  _MediaPlayerScreenState createState() => _MediaPlayerScreenState();
}

class _MediaPlayerScreenState extends State<MediaPlayerScreen> {
  final _audioPlayer = SL.get<AudioPlayerService>();
  int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialAudioIndex;
    _startAudio();
  }

  Future _startAudio() async {
    if (widget.mediaItems.isNotEmpty) {
      final success = await _audioPlayer.start(widget.mediaItems, _index);
      if (success) await _audioPlayer.play();
    }
  }

  MediaData get item => widget.mediaItems[_index];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Column(
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
                  'assets/images/media_player/media_player_icon.PNG',
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.4,
                ),
              ),
            ),
            const SizedBox(height: 20),
            AudioPlayerDisplay(item: item.toMediaItem()),
            // const SizedBox(height: 25),
            // AudioPlayerSeeker(),
            const SizedBox(
              height: 20,
            ),
            AudioPlayerControlBar(
              onStart: () => _startAudio(),
              onNext: () => setState(() {
                if (_index < widget.mediaItems.length - 1) _index++;
              }),
              onPrevious: () => setState(() {
                if (_index > 0) _index--;
              }),
            ),
          ],
        ),
      ),
    );
  }
}
