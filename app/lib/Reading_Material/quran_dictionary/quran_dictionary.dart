import 'package:arrahma_mobile_app/Reading_Material/quran_dictionary/model/quran_dictionary_list.dart';
import 'package:flutter/material.dart';

class QuranDictionary extends StatefulWidget {
  @override
  _QuranDictionaryState createState() => _QuranDictionaryState();
}

class _QuranDictionaryState extends State<QuranDictionary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Quran Dictionary',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(right: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                ),
              ),
            ),
          ),
          ..._quranDictionary
              .map((item) => _buildQuranDictionary(context, item))
              .toList(),
        ],
      ),
    );
  }

  final _quranDictionary = [
    QuranDictionaryItem(
      title: 'Urdu Easy Dictionary',
      dictionaryPdf: '',
    ),
    QuranDictionaryItem(
      title: 'Urdu Concise Dictionary',
      dictionaryPdf: '',
    ),
    QuranDictionaryItem(
      title: 'English Easy Dictionary',
      dictionaryPdf: '',
    ),
    QuranDictionaryItem(
      title: 'English Concise Dictionary',
      dictionaryPdf: '',
    ),
  ];

  Widget _buildQuranDictionary(BuildContext context, QuranDictionaryItem item) {
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
                  Navigator.pushNamed(context, item.dictionaryPdf);
                },
                child: Image.asset(
                  'assets/images/multi_page_icons/arrow_down.png',
                  width: 20,
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
