import 'package:flutter/material.dart';

class TaleemulTajweedTab extends StatefulWidget {
  @override
  _TaleemulTajweedTabState createState() => _TaleemulTajweedTabState();
}

class _TaleemulTajweedTabState extends State<TaleemulTajweedTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text(
          'Tajweed',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: Text(
                'Introduction',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/media_player_screen');
              },
            ),
            SizedBox(
              height: 50,
            ),
            GestureDetector(
              child: Text(
                'Letter Practice',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/letter_practice');
              },
            ),
            SizedBox(
              height: 50,
            ),
            GestureDetector(
              child: Text(
                'Tajweed Rules',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/tajweed_rules');
              },
            ),
            SizedBox(
              height: 50,
            ),
            GestureDetector(
              child: Text(
                'Weekly Hifz',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/weekly_hifz');
              },
            )
          ],
        ),
      ),
    );
  }
}
