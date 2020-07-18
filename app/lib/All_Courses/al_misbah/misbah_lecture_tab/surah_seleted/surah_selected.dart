import 'package:flutter/material.dart';

import 'model/surah_selected.dart';

class MisbahSurahSelected extends StatefulWidget {
  @override
  _MisbahSurahSelectedState createState() => _MisbahSurahSelectedState();
}

class _MisbahSurahSelectedState extends State<MisbahSurahSelected> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Surah',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black, width: 2),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/al_misbah_icons/youtube.png',
                      width: 40,
                    ),
                    SizedBox(
                      width: 35,
                    ),
                    Image.asset(
                      'assets/images/al_misbah_icons/facebook.png',
                      width: 25,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
          ..._surahSelected
              .map((item) => _buildSurahSelected(context, item))
              .toList(),
        ],
      ),
    );
  }

  final _surahSelected = [
    SurahSelectedItem(
      title: 'Lesson 1: Quran ki Fazilat (part1)',
      youtubeRoute: '',
      facebookRoute: '',
    ),
    SurahSelectedItem(
      title: 'Lesson 2: Quran ki Fazilat (part2)',
      youtubeRoute: '',
      facebookRoute: '',
    ),
    SurahSelectedItem(
      title: "Lesson 3: Impotance of Surah Fatiha & Ta'ooz",
      youtubeRoute: '',
      facebookRoute: '',
    ),
    SurahSelectedItem(
      title: 'Lesson 4: Tafseer Of Tasmia & Alhamdullilah',
      youtubeRoute: '',
      facebookRoute: '',
    ),
  ];

  Widget _buildSurahSelected(BuildContext context, SurahSelectedItem item) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              item.title,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, item.youtubeRoute);
                },
                child: Image.asset(
                  'assets/images/al_misbah_icons/youtube_playbutton.png',
                  width: 20,
                ),
              ),
              SizedBox(width: 40),
              GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, item.facebookRoute);
                  },
                  child: Image.asset(
                    'assets/images/al_misbah_icons/facebook_playbutton.png',
                    width: 30,
                  )),
              SizedBox(width: 30, height: 50),
            ],
          ),
        ],
      ),
    );
  }
}
