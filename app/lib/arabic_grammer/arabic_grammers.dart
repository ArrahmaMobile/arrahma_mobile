import 'package:flutter/material.dart';

import 'models/arabic_grammer.dart';

class ArabicGrammer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Arabic Grammer',
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
                      'Sheets',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Audio',
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
          ..._arabicGrammer
              .map((item) => _buildLetterPractice(context, item))
              .toList(),
        ],
      ),
    );
  }

  final _arabicGrammer = [
    GrammerItem(
      title: 'Arabic Grammar Terminologies and Signs of Ism',
      sheetsPdf: '',
      audio: '',
    ),
    GrammerItem(
      title: 'Types of Ism Marfaa Part 1',
      sheetsPdf: '',
      audio: '',
    ),
    GrammerItem(
      title: 'Types of Ism Marfaa Part 2 (incomplete)',
      sheetsPdf: '',
      audio: '',
    ),
  ];

  Widget _buildLetterPractice(BuildContext context, GrammerItem item) {
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
                    Navigator.pushNamed(context, item.sheetsPdf);
                  },
                  child: Image.asset(
                    'assets/images/multi_page_icons/arrow_down.png',
                    width: 20,
                  )),
              SizedBox(width: 60),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, item.audio);
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
