import 'package:arrahma_mobile_app/All_Courses/taleemul_quran/tajweed_tab/weekly_hifz/model/weekly_hifz.dart';
import 'package:flutter/material.dart';

class WeeklyHifz extends StatefulWidget {
  @override
  _WeeklyHifzState createState() => _WeeklyHifzState();
}

class _WeeklyHifzState extends State<WeeklyHifz> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Weekly Hifz',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black, width: 2),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Lesson',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    SizedBox(
                      width: 28,
                    ),
                    Text(
                      'Practice',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ..._weeklyHifz
              .map((item) => _buildWeeklyHifz(context, item))
              .toList(),
        ],
      ),
    );
  }

  final _weeklyHifz = [
    WeeklyHafizItem(
      title: 'Surah  Ayah 1-2',
      pageRoute: '',
    ),
    WeeklyHafizItem(
      title: 'Surah Al-Baqarah Ayah 1-3',
      pageRoute: '',
    ),
    WeeklyHafizItem(
      title: 'Surah Al-Baqarah Ayah 1-4',
      pageRoute: '',
    ),
  ];

  Widget _buildWeeklyHifz(BuildContext context, WeeklyHafizItem item) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              item.title,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, item.pageRoute);
                },
                child: Icon(
                  Icons.audiotrack,
                  color: Colors.black,
                  size: 25,
                ),
              ),
              SizedBox(width: 80),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, item.pageRoute);
                },
                child: Icon(
                  Icons.audiotrack,
                  color: Colors.black,
                  size: 25,
                ),
              ),
              SizedBox(width: 30, height: 40),
            ],
          ),
        ],
      ),
    );
  }
}
