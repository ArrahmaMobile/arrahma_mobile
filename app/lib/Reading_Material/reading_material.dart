import 'package:flutter/material.dart';

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
      children: <Widget>[
        GestureDetector(
          child: Container(
            color: Color(0xffdedbdb),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Dua',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                Icon(
                  Icons.access_alarm,
                  size: 50,
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          child: Container(
            color: Color(0xffdedbdb),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Juz Translation',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                Icon(
                  Icons.access_alarm,
                  size: 50,
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          child: Container(
            color: Color(0xffdedbdb),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Quran Dictionary',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                Icon(
                  Icons.access_alarm,
                  size: 50,
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          child: Container(
            color: Color(0xffdedbdb),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Assorted Topics',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                Icon(
                  Icons.access_alarm,
                  size: 50,
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          child: Container(
            color: Color(0xffdedbdb),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Imp Vocabulary',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                Icon(
                  Icons.access_alarm,
                  size: 50,
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          child: Container(
            color: Color(0xffdedbdb),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Worksheet by Ustazah',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                Icon(
                  Icons.access_alarm,
                  size: 50,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
