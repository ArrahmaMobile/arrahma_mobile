import 'package:flutter/material.dart';

import 'model/hadith.dart';

class Hadith extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          'Hadith',
          style: TextStyle(color: Colors.white),
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
      icon: Icons.access_alarm,
    ),
    HadithItem(
      title: 'Hadith Lessons',
      icon: Icons.access_alarm,
    ),
    HadithItem(
      title: 'Hadith Lessons',
      icon: Icons.access_alarm,
    ),
  ];

  Widget _buildHadithItem(item) {
    return GestureDetector(
      child: Container(
        color: Color(0xffdedbdb),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              item.title,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            Icon(
              item.icon,
              size: 50,
            ),
          ],
        ),
      ),
    );
  }
}
