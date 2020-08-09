import 'package:arrahma_mobile_app/Reading_Material/vocabulary_words/model/vocabulary_word_list.dart';
import 'package:flutter/material.dart';

class VocabularyWords extends StatefulWidget {
  @override
  _VocabularyWordsState createState() => _VocabularyWordsState();
}

class _VocabularyWordsState extends State<VocabularyWords> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff124570),
        title: Text(
          'Word Meaning Of Common Words In Quran',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 16,
          ),
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
          ..._vocabularyWord
              .map((item) => _buildVocabularyWord(context, item))
              .toList(),
        ],
      ),
    );
  }

  final _vocabularyWord = [
    const VocabularyWordList(
      title: 'Page 1',
      pagePdf: '',
    ),
    const VocabularyWordList(
      title: 'Page 2',
      pagePdf: '',
    ),
    const VocabularyWordList(
      title: 'Page 3',
      pagePdf: '',
    ),
  ];

  Widget _buildVocabularyWord(BuildContext context, VocabularyWordList item) {
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
                  Navigator.pushNamed(context, item.pagePdf);
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
