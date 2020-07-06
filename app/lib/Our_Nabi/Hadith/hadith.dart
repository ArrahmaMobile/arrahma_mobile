import 'package:flutter/material.dart';

class Hadith extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //AppBar -- Rending a navigation bae with title
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
      children: <Widget>[
        GestureDetector(
          child: Container(
            color: Color(0xffdedbdb),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Hadith Lessons',
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
                  'Lulu wal Maejaan - 1',
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
                  'Lulu wal Maejaan - 2',
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