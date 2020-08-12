import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class MediaPlayerScreen extends StatefulWidget {
  @override
  _MediaPlayerScreenState createState() => _MediaPlayerScreenState();
}

bool _isPlaying = false;

class _MediaPlayerScreenState extends State<MediaPlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 10),
                child: IconButton(
                  iconSize: 40,
                  icon: Icon(Icons.arrow_drop_down),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 10),
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
              const SizedBox(height: 50),
              Text(
                'Now Playing: Tafseer - "Lesson Name"',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
              ),
              const SizedBox(height: 25),
              Slider(
                onChanged: (v) {},
                value: 10,
                max: 100,
                min: 0,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.fast_rewind,
                      color: Colors.black,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    iconSize: 50,
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      onPlayAudio();
                      setState(
                        () {
                          _isPlaying = !_isPlaying;
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.fast_forward,
                      color: Colors.black,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.share,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/share');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: avoid_void_async
void onPlayAudio() async {
  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  assetsAudioPlayer.open(
    Audio(
      'assets/audio/introduction.mp3',
    ),
  );
}
