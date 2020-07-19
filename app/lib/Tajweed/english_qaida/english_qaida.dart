import 'package:arrahma_mobile_app/Tajweed/english_qaida/model/english_qaidas.dart';
import 'package:flutter/material.dart';

class EnglishQaida extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'English Audio',
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
                    Text(
                      'Letter',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
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
    EnglishQaidaList(
      title: 'Lesson 1: Letters ا to ش',
      letterAudio: '',
      surahAudio: '',
    ),
    EnglishQaidaList(
      title: 'Lesson 2: Letters ص to ی',
      letterAudio: '',
      surahAudio: '',
    ),
    EnglishQaidaList(
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
                  Navigator.pushNamed(context, item.letterAudio);
                },
                child: Icon(
                  Icons.volume_up,
                  color: Colors.black,
                  size: 25,
                ),
              ),
              SizedBox(width: 60),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, item.surahAudio);
                },
                child: Icon(
                  Icons.volume_up,
                  color: Colors.black,
                  size: 25,
                ),
              ),
              SizedBox(width: 30, height: 40),
            ],
          ),
        ],
      ),
    );
  }
}
