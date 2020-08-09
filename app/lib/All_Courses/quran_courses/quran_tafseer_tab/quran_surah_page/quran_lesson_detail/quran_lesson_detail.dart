import 'package:flutter/material.dart';

import 'model/quran_lesson_detail_item.dart';

class QuranLessonDetailPage extends StatefulWidget {
  @override
  _QuranLessonDetailPageState createState() => _QuranLessonDetailPageState();
}

class _QuranLessonDetailPageState extends State<QuranLessonDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212121),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 50),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 10),
                child: Column(),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: ClipRRect(
                      child: Image.asset(
                        'assets/images/media_player/arrahmah_logo.jpeg',
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.width * 0.2,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        'Surah Al-Fatiha  الفاتحۃ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Column(
                    children: <Widget>[
                      Text(
                        'Lesson 1: Ayah 1-3',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              ..._quranLessonDetail
                  .map((item) => _buildQuranLessonDetail(context, item))
                  .toList(),
              const SizedBox(height: 120),
              GestureDetector(
                child: Text(
                  'Close',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              )
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
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.volume_up,
                  color: Colors.white,
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
