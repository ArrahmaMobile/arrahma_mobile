import 'package:flutter/material.dart';

import 'model/reading_material.dart';

class ReadingMaterial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Reading Material',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            _studentCornerList(context),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _studentCornerList(BuildContext context) {
    return GridView.count(
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 1.3,
      children: _readingMaterialItem
          .map(
            (item) => _buildReadingMaterial(context, item),
          )
          .toList(),
    );
  }

  final _readingMaterialItem = [
    ReadingMaterialItem(
      title: 'Dua',
      pageRoute: '/dua',
    ),
    ReadingMaterialItem(
      title: 'Juz Translation',
      pageRoute: '/juz_Translation',
    ),
    ReadingMaterialItem(
      title: 'Quran Dictionary',
      pageRoute: '/quran_dictionary',
    ),
    ReadingMaterialItem(
      title: 'Assorted Topic',
      pageRoute: '/assorted_topic',
    ),
    ReadingMaterialItem(
      title: 'Imp Vocabulary words',
      pageRoute: '/imp_vocabulary_words',
    ),
    ReadingMaterialItem(
      title: 'Worksheet by Ustazah',
      pageRoute: '/worksheet',
    ),
  ];

  Widget _buildReadingMaterial(BuildContext context, ReadingMaterialItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, item.pageRoute);
      },
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
