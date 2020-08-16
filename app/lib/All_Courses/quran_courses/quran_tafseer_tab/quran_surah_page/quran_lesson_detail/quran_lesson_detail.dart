import 'package:flutter/material.dart';

import 'model/quran_lesson_detail_item.dart';

class QuranLessonAudioPage extends StatefulWidget {
  @override
  _QuranLessonAudioPageState createState() => _QuranLessonAudioPageState();
}

class _QuranLessonAudioPageState extends State<QuranLessonAudioPage> {
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
                  iconSize: 25,
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: ClipRRect(
                      child: Image.asset(
                        'assets/images/media_player/media_player_icon.PNG',
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.width * 0.4,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: <Widget>[
                      const Text(
                        'Surah Al-Fatiha  الفاتحۃ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Column(
                    children: <Widget>[
                      const Text(
                        'Lesson 1: Ayah 1-3',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              ..._quranLessonDetail
                  .map((item) => _buildQuranLessonDetail(context, item))
                  .toList()
            ],
          ),
        ),
      ),
    );
  }

  final _quranLessonDetail = [
    const QuranLessonDetailItem(
      title: 'Root',
      rootWordPdf: '',
      translationAudio: '',
      tafseerAudio: '',
      refMaterialAudio: '',
    ),
    const QuranLessonDetailItem(
      title: 'Translation',
      rootWordPdf: '',
      translationAudio: '',
      tafseerAudio: '',
      refMaterialAudio: '',
    ),
    const QuranLessonDetailItem(
      title: 'Tafseer',
      rootWordPdf: '',
      translationAudio: '',
      tafseerAudio: '',
      refMaterialAudio: '',
    ),
    const QuranLessonDetailItem(
      title: 'Ref. Material',
      rootWordPdf: '',
      translationAudio: '',
      tafseerAudio: '',
      refMaterialAudio: '',
    ),
  ];

  Widget _buildQuranLessonDetail(
      BuildContext context, QuranLessonDetailItem item) {
    return GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(left: 20),
              ),
              const SizedBox(width: 15),
              Text(
                item.title,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.volume_up,
                  color: Colors.black,
                ),
                color: Colors.black,
                onPressed: () {},
              )
            ],
          )
        ],
      ),
      onTap: () {},
    );
  }
}
