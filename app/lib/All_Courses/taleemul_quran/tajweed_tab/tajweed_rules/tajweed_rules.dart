import 'package:arrahma_mobile_app/All_Courses/taleemul_quran/tajweed_tab/tajweed_rules/model/tajweed_rules.dart';
import 'package:flutter/material.dart';

class TajweedRules extends StatefulWidget {
  @override
  _TajweedRulesState createState() => _TajweedRulesState();
}

class _TajweedRulesState extends State<TajweedRules> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Tajweed Rules',
          style: TextStyle(fontWeight: FontWeight.bold),
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
                      width: 20,
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
          ..._tajweedRules
              .map((item) => _buildTajweedRules(context, item))
              .toList(),
        ],
      ),
    );
  }

  final _tajweedRules = [
    TajweedRulesItem(
      title: 'Madd e Tabaii Part 1',
      lessonRoute: '',
      practiceRoute: '',
    ),
    TajweedRulesItem(
      title: 'Madd e Tabaii Part 2',
      lessonRoute: '',
      practiceRoute: '',
    ),
    TajweedRulesItem(
      title: 'Madd e Tabaii Part 3',
      lessonRoute: '',
      practiceRoute: '',
    )
  ];

  Widget _buildTajweedRules(BuildContext context, TajweedRulesItem item) {
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
                  Navigator.pushNamed(context, item.lessonRoute);
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
                  Navigator.pushNamed(context, item.practiceRoute);
                },
                child: Icon(
                  Icons.audiotrack,
                  color: Colors.black,
                  size: 25,
                ),
              ),
              SizedBox(width: 30, height: 50),
            ],
          ),
        ],
      ),
    );
  }
}
