import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

bool _isPlaying = false;

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff124570),
        centerTitle: true,
        title: const Text(
          'About us',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'About ArRahmah',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const Text(
                  'ArRahmah started its online journey in 2007 from New Jersey, USA and provided weekly Tarjuma, Tafseer and Tajweed classes.'
                  'It initially catered to the needs of sisters in the area and neighboring states but by the special blessing of Allah swt we now serve students globally.'
                  'All our humble efforts are only for seeking the pleasure of Allah SWT so each person in Arrahma whether teacher,administration or helpers are all working Fi Sabil Lillah.'
                  'Classes here are offered absolutely FREE. We only ask for your time, dedication and duas.',
                ),
                const SizedBox(height: 10),
                const Text(
                  "Teacher's Profile",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const Text(
                  'ArRahmah started its online journey in 2007 from New Jersey,'
                  'USA and provided weekly Tarjuma, Tafseer and Tajweed classes.'
                  'It initially catered to the needs of sisters in the area and neighboring states but by the special blessing of Allah swt we now serve students globally.'
                  'All our humble efforts are only for seeking the pleasure of Allah SWT so each person in Arrahma whether teacher,'
                  'administration or helpers are all working Fi Sabil Lillah. Classes here are offered absolutely FREE. We only ask for your time, dedication and duas.',
                ),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'خیركم من تعلم القرآن وعلمه',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                const Text(
                  'Vision',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const Text(
                    "Quran was sent down in Arabic for all. Najiha Hashmi's ambition is to make it viable for all."
                    'She founded Arrahma Institute in 1998 as a dream to bring people close to Allah, irrespective of their age'
                    ',education and background. Thousands of students are currently benefiting from her forthright and simple'
                    'teaching style, thus making it effortless to master a foreign language. She simplifies the Arabic in a skilful'
                    'way and explains it in the most comprehensive manner.Her explanation of the text is eloquent,simple and'
                    'functional and inspires the listener to race to Allah and seek His approval. Learning life lessons and'
                    'grooming the soul are besides the obvious gains of her brilliant teaching. For herself, her passion for'
                    'learning has never slowed. She continues to excel in her knowledge of Quran, Hadith and Seerah and benefit'
                    "others, free of charge, in pursuit of the absolute ecstasy ; Allah Almighty's approval and Jannah!"),
                const SizedBox(height: 10),
                const Text(
                  "ArRahmah's Aim",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const Text(
                    'To spread the word of our Lord to every person regardless of age, education, location or'
                    'cultural background ... Arrahmah aims at providing very flexible schedule for online classes'
                    'giving women the freedom to gain knowledge at their own time and place'),
                const SizedBox(height: 10),
                const Text(
                  'Why ArRahmah',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const Text(
                    "ArRahmah's unique program is not solely designed for students to graduate with a certificate,"
                    'but to bring about a positive change in their lives and to enlighten them with the nur of Quran by'
                    'softening their hearts. Quran is taught in such a way that it becomes easy for anyone joining at'
                    'any stage of the journey. Tafseer course specially aims on ultimately developing the deepest love'
                    'for The Almighty, who is truly the one worthy of being loved'),
                const SizedBox(height: 20),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                ),
                GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        'Talemul Quran - Lesson name',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Row(
                        children: <Widget>[
                          IconButton(
                            iconSize: 40,
                            icon: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow),
                            onPressed: () {
                              onPlayAudio();
                              setState(
                                () {
                                  _isPlaying = !_isPlaying;
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/media_player_screen');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
}
