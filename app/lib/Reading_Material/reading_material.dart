import 'package:flutter/material.dart';

import 'model/reading_material.dart';

class ReadingMaterial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //AppBar -- Rending a navigation bae with title
        centerTitle: true,
        title: Text(
          'Reading Material',
          style: TextStyle(color: Colors.black),
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
            (item) => _buildReadingMaterial(item),
          )
          .toList(),
    );
  }

  final _readingMaterialItem = [
    ReadingMaterialItem(
      title: 'Dua',
      icon: Icons.access_alarm,
    ),
    ReadingMaterialItem(
      title: 'Dua',
      icon: Icons.access_alarm,
    ),
    ReadingMaterialItem(
      title: 'Dua',
      icon: Icons.access_alarm,
    ),
    ReadingMaterialItem(
      title: 'Dua',
      icon: Icons.access_alarm,
    ),
    ReadingMaterialItem(
      title: 'Dua',
      icon: Icons.access_alarm,
    ),
    ReadingMaterialItem(
      title: 'Dua',
      icon: Icons.access_alarm,
    ),
  ];

  Widget _buildReadingMaterial(item) {
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
