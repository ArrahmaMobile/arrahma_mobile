import 'package:flutter/material.dart';

import 'model/letter_practice.dart';

class LetterPractice extends StatefulWidget {
  @override
  _LetterPracticeState createState() => _LetterPracticeState();
}

class _LetterPracticeState extends State<LetterPractice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Letter Practice',
          style: TextStyle(fontWeight: FontWeight.bold),
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
                      'Lesson',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Practice',
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
          ..._letterPractice
              .map((item) => _buildLetterPractice(context, item))
              .toList(),
        ],
      ),
    );
  }

  final _letterPractice = [
    LetterPracticeItem(
      title: 'Letter ء',
      pageRoute: '',
      lessonRoute: '',
      practiceRoute: '',
    ),
    LetterPracticeItem(
      title: 'Letter ب',
      pageRoute: '',
      lessonRoute: '',
      practiceRoute: '',
    ),
    LetterPracticeItem(
      title: 'Letter ت',
      pageRoute: '',
      lessonRoute: '',
      practiceRoute: '',
    )
  ];

  Widget _buildLetterPractice(BuildContext context, LetterPracticeItem item) {
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
                  Navigator.pushNamed(context, item.lessonRoute);
                },
                child: Icon(
                  Icons.audiotrack,
                  color: Colors.blueAccent,
                  size: 25,
                ),
              ),
              SizedBox(width: 80),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, item.practiceRoute);
                },
                child: Icon(
                  Icons.audiotrack,
                  color: Colors.blue,
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
