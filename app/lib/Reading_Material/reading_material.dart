import 'package:flutter/material.dart';

import 'model/reading_material.dart';

class ReadingMaterial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff124570),
        centerTitle: true,
        title: Text(
          'Reading Material',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
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
      childAspectRatio: 1.5,
      children: _readingMaterialItem
          .map(
            (item) => _buildReadingMaterial(context, item),
          )
          .toList(),
    );
  }

  final _readingMaterialItem = [
    const ReadingMaterialItem(
      title: 'Dua',
      pageRoute: '/dua',
    ),
    const ReadingMaterialItem(
      title: 'Juz Translation',
      pageRoute: '/juz_Translation',
    ),
    const ReadingMaterialItem(
      title: 'Quran Dictionary',
      pageRoute: '/quran_dictionary',
    ),
    const ReadingMaterialItem(
      title: 'Assorted Topic',
      pageRoute: '/assorted_topic',
    ),
    const ReadingMaterialItem(
      title: 'Imp Vocabulary words',
      pageRoute: '/imp_vocabulary_words',
    ),
    const ReadingMaterialItem(
      title: 'Worksheet by Ustazah',
      pageRoute: '/worksheet',
    ),
  ];

  Widget _buildReadingMaterial(BuildContext context, ReadingMaterialItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, item.pageRoute);
      },
      child: Container(
        color: const Color(0xff124570),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              item.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
