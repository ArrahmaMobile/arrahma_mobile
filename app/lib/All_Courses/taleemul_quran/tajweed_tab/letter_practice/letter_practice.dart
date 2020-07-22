import 'package:flutter/material.dart';

import 'model/letter_practice.dart';

class LetterPractice extends StatefulWidget {
  const LetterPractice(
      {Key key, @required this.practiceItems, @required this.title})
      : super(key: key);
  final List<LetterPracticeItem> practiceItems;
  final String title;

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
          widget.title,
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
          ...widget.practiceItems
              .map((item) => _buildLetterPractice(context, item))
              .toList(),
        ],
      ),
    );
  }

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
                  Icons.volume_up,
                  color: Colors.black,
                  size: 25,
                ),
              ),
              SizedBox(width: 80),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, item.practiceRoute);
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
