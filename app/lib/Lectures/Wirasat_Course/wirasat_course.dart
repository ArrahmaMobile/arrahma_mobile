import 'package:arrahma_mobile_app/Lectures/Wirasat_Course/model/wirasat_course.dart';
import 'package:flutter/material.dart';

class WirasatCourse extends StatefulWidget {
  @override
  _WirasatCourseState createState() => _WirasatCourseState();
}

class _WirasatCourseState extends State<WirasatCourse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff124570),
        title: const Text(
          'Wirasat Course',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(right: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                ),
              ),
            ),
          ),
          ..._wirasatCourse
              .map((item) => _buildLetterPractice(context, item))
              .toList(),
        ],
      ),
    );
  }

  final _wirasatCourse = [
    const WirasatCourseItem(
      title: 'Introduction',
      videoRoute: '/media_player_screen',
      pdfRoute: '/wirasat_course',
    ),
    const WirasatCourseItem(
      title: 'Lesson 1',
      videoRoute: '/media_player_screen',
      pdfRoute: '/wirasat_course',
    ),
    const WirasatCourseItem(
      title: 'Lesson 2',
      videoRoute: '/media_player_screen',
      pdfRoute: '/wirasat_course',
    ),
    const WirasatCourseItem(
      title: 'Lesson 3',
      videoRoute: '/media_player_screen',
      pdfRoute: '/wirasat_course',
    )
  ];

  Widget _buildLetterPractice(BuildContext context, WirasatCourseItem item) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              item.title,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, item.videoRoute);
                },
                child: Image.asset(
                  'assets/images/multi_page_icons/play_icon.png',
                  width: 30,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, item.pdfRoute);
                },
                child: Image.asset(
                  'assets/images/multi_page_icons/arrow_down.png',
                  width: 20,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 30, height: 40),
            ],
          ),
        ],
      ),
    );
  }
}
