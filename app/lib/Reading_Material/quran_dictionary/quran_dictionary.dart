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
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff124570),
        title: const Text(
          'Quran Dictionary',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
    const QuranDictionaryItem(
      title: 'Urdu Easy Dictionary',
      dictionaryPdf: '',
    ),
    const QuranDictionaryItem(
      title: 'Urdu Concise Dictionary',
      dictionaryPdf: '',
    ),
    const QuranDictionaryItem(
      title: 'English Easy Dictionary',
      dictionaryPdf: '',
    ),
    const QuranDictionaryItem(
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
                  Navigator.pushNamed(context, item.dictionaryPdf);
                },
                child: Image.asset(
                  'assets/images/multi_page_icons/arrow_down.png',
                  width: 20,
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
