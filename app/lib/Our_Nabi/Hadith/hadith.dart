import 'package:flutter/material.dart';

import 'model/hadith.dart';

class Hadith extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff124570),
        centerTitle: true,
        title: const Text(
          'Hadith',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
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
        children: _hadithItem
            .map((item) => _buildHadithItem(context, item))
            .toList());
  }

  final _hadithItem = [
    const HadithItem(
      title: 'Hadith Lessons',
      pageRoute: '/hadith_lesson_details',
    ),
    const HadithItem(
      title: 'Lulu wal Marjaan - 1',
      pageRoute: '/hadith',
    ),
    const HadithItem(
      title: 'Lulu wal Marjaan - 2',
      pageRoute: '/hadith',
    ),
  ];

  Widget _buildHadithItem(BuildContext context, HadithItem item) {
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
              style: const TextStyle(
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
