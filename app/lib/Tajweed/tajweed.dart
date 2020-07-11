import 'package:arrahma_mobile_app/Tajweed/model/tajweed.dart';
import 'package:flutter/material.dart';

class Tajweed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //AppBar -- Rending a navigation bae with title
        centerTitle: true,
        title: Text(
          'Tajweed',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            _tajweedList(context),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _tajweedList(BuildContext context) {
    return GridView.count(
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 1.9,
      children: _tajweedItem
          .map(
            (item) => _buildTajweedItem(context, item),
          )
          .toList(),
    );
  }

  final _tajweedItem = [
    TajweedItem(
      title: 'Juz 30 Hifz',
      icon: Icons.access_alarm,
    ),
    TajweedItem(
      title: 'Juz 30 Hifz',
      icon: Icons.access_alarm,
    ),
    TajweedItem(
      title: 'Juz 30 Hifz',
      icon: Icons.access_alarm,
    ),
    TajweedItem(
      title: 'Juz 30 Hifz',
      icon: Icons.access_alarm,
    ),
    TajweedItem(
      title: 'Juz 30 Hifz',
      icon: Icons.access_alarm,
    ),
    TajweedItem(
      title: 'Juz 30 Hifz',
      icon: Icons.access_alarm,
    ),
    TajweedItem(
      title: 'Juz 30 Hifz',
      icon: Icons.access_alarm,
    )
  ];

  Widget _buildTajweedItem(context, item) {
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
