import 'package:flutter/material.dart';

import 'model/hadith.dart';

class Hadith extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Hadith',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            _ourNabiList(context),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _ourNabiList(BuildContext context) {
    return GridView.count(
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        crossAxisCount: 2,
        shrinkWrap: true,
        childAspectRatio: 1,
        children: _hadithItem.map((item) => _buildHadithItem(item)).toList());
  }

  final _hadithItem = [
    HadithItem(
      title: 'Hadith Lessons',
    ),
    HadithItem(
      title: 'Hadith Lessons',
    ),
    HadithItem(
      title: 'Hadith Lessons',
    ),
  ];

  Widget _buildHadithItem(item) {
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            item.title,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
