import 'package:flutter/material.dart';

import 'models/arabic_grammer.dart';

class ArabicGrammer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff124570),
        title: const Text(
          'Arabic Grammer',
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
                      'Sheets',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
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
    const GrammerItem(
      title: 'Arabic Grammar Terminologies and Signs of Ism',
      sheetsPdf: '',
      audio: '',
    ),
    const GrammerItem(
      title: 'Types of Ism Marfaa Part 1',
      sheetsPdf: '',
      audio: '',
    ),
    const GrammerItem(
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
                    Navigator.pushNamed(context, item.sheetsPdf);
                  },
                  child: Image.asset(
                    'assets/images/multi_page_icons/arrow_down.png',
                    width: 20,
                    color: Colors.black,
                  )),
              const SizedBox(width: 60),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, item.audio);
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
