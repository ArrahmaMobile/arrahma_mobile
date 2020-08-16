import 'package:arrahma_mobile_app/Tajweed/english_qaida/model/english_qaidas.dart';
import 'package:flutter/material.dart';

class EnglishQaida extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff124570),
        title: const Text(
          'English Audio',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black, width: 2),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    const Text(
                      'Letter',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      'Surah',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ..._englishQaida
              .map((item) => _buildLetterPractice(context, item))
              .toList(),
        ],
      ),
    );
  }

  final _englishQaida = [
    const EnglishQaidaList(
      title: 'Lesson 1: Letters ا to ش',
      letterAudio: '',
      surahAudio: '',
    ),
    const EnglishQaidaList(
      title: 'Lesson 2: Letters ص to ی',
      letterAudio: '',
      surahAudio: '',
    ),
    const EnglishQaidaList(
      title: 'Lesson 3: Fatah sound ا to ش',
      letterAudio: '',
      surahAudio: '',
    ),
  ];

  Widget _buildLetterPractice(BuildContext context, EnglishQaidaList item) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              item.title,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, item.letterAudio);
                },
                child: const Icon(
                  Icons.volume_up,
                  color: Colors.black,
                  size: 25,
                ),
              ),
              const SizedBox(width: 60),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, item.surahAudio);
                },
                child: const Icon(
                  Icons.volume_up,
                  color: Colors.black,
                  size: 25,
                ),
              ),
              const SizedBox(width: 30, height: 40),
            ],
          ),
        ],
      ),
    );
  }
}
