import 'package:flutter/material.dart';

import 'model/dua_sunnah_zirk.dart';

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
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff124570),
        title: Text(
          'Weekly Reminder',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                padding: const EdgeInsets.only(right: 20.0),
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
                    const SizedBox(
                      width: 50,
                    ),
                    Text(
                      'Dua',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    const SizedBox(
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
            ),
          ),
          ..._duaSunnahZikr
              .map((item) => _buildDuaSunnahZikr(context, item))
              .toList(),
        ],
      ),
    );
  }

  final _duaSunnahZikr = [
    const DuaSunnahZirkItem(
      title: 'Week 1',
      sunnahRoute: '',
      duaRoute: '',
      zikrRoute: '',
    ),
    const DuaSunnahZirkItem(
      title: 'Week 2',
      sunnahRoute: '',
      duaRoute: '',
      zikrRoute: '',
    ),
    const DuaSunnahZirkItem(
      title: 'Week 3',
      sunnahRoute: '',
      duaRoute: '',
      zikrRoute: '/lesson_detail_page',
    ),
  ];

  Widget _buildDuaSunnahZikr(BuildContext context, DuaSunnahZirkItem item) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            item.title,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(
            width: 15,
            height: 40,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, item.sunnahRoute);
            },
            child: Icon(
              Icons.volume_up,
              color: Colors.black,
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, item.duaRoute);
            },
            child: Icon(
              Icons.volume_up,
              color: Colors.black,
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, item.zikrRoute);
              },
              child: Icon(
                Icons.volume_up,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
