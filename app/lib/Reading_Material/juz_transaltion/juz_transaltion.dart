import 'package:arrahma_mobile_app/Reading_Material/juz_transaltion/model/juz_transaltion_item.dart';
import 'package:flutter/material.dart';

class JuzTranslation extends StatefulWidget {
  @override
  _JuzTranslationState createState() => _JuzTranslationState();
}

class _JuzTranslationState extends State<JuzTranslation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff124570),
        title: Text(
          'Juz Translation',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                      'Urdu',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Text(
                      'English',
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
          ..._juzTranslation
              .map((item) => _buildJuzTranslation(context, item))
              .toList(),
        ],
      ),
    );
  }

  final _juzTranslation = [
    const JuzTranslationItem(
      title: 'Juz 1 الم',
      urduPdf: '',
      englishPdf: '',
    ),
    const JuzTranslationItem(
      title: 'Juz 2 سیقول',
      urduPdf: '',
      englishPdf: '',
    ),
    const JuzTranslationItem(
      title: 'Juz 3  تلک الرسل',
      urduPdf: '',
      englishPdf: '',
    ),
  ];

  Widget _buildJuzTranslation(BuildContext context, JuzTranslationItem item) {
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
                  Navigator.pushNamed(context, item.urduPdf);
                },
                child: Image.asset(
                  'assets/images/multi_page_icons/arrow_down.png',
                  width: 15,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 80),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, item.englishPdf);
                },
                child: Image.asset(
                  'assets/images/multi_page_icons/arrow_down.png',
                  width: 15,
                  color: Colors.black,
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
