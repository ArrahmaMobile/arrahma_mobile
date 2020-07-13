import 'package:flutter/material.dart';

class WeeklyDuaSunnahZikr extends StatefulWidget {
  @override
  _WeeklyDuaSunnahZikrState createState() => _WeeklyDuaSunnahZikrState();
}

class _WeeklyDuaSunnahZikrState extends State<WeeklyDuaSunnahZikr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text(
          'Weekly Reminder\n'
          '(Sunnah, Dua and Zikr)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              'Sunnah',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            SizedBox(
              width: 50,
            ),
            Text(
              'Dua',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            SizedBox(
              width: 50,
            ),
            Text(
              'Zikr',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
