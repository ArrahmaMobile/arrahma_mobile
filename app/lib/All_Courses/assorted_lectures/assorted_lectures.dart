import 'package:flutter/material.dart';
import 'model/assorted_lectures.dart';

class AssortedLecturesCourse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          'Lecstures',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                _lecturesList(context),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _lecturesList(BuildContext context) {
    return GridView.count(
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 1.9,
      children: _assortedLectures
          .map((lecture) => _buildAssortedLecture(context, lecture))
          .toList(),
    );
  }

  final _assortedLectures = [
    AssortedLectureItem(
      title: 'New Lectures',
      icon: Icons.access_alarm,
      pageRoute: '/',
    ),
    AssortedLectureItem(
      title: 'Marriage',
      icon: Icons.access_alarm,
      pageRoute: '/',
    ),
    AssortedLectureItem(
      title: 'Akhirah',
      icon: Icons.access_alarm,
      pageRoute: '/',
    ),
    AssortedLectureItem(
      title: 'Months and Events',
      icon: Icons.access_alarm,
      pageRoute: '/',
    ),
    AssortedLectureItem(
      title: 'Padaab-e-Zindagi',
      icon: Icons.access_alarm,
      pageRoute: '/',
    ),
    AssortedLectureItem(
      title: "Rubb Se Taa'luk",
      icon: Icons.access_alarm,
      pageRoute: '/',
    ),
    AssortedLectureItem(
      title: 'Imaan',
      icon: Icons.access_alarm,
      pageRoute: '/',
    ),
    AssortedLectureItem(
      title: 'Humare Rasool ﷺ',
      icon: Icons.access_alarm,
      pageRoute: '/',
    ),
    AssortedLectureItem(
      title: 'Duniya ki zindagi',
      icon: Icons.access_alarm,
      pageRoute: '/',
    ),
    AssortedLectureItem(
      title: 'Quran/ilm',
      icon: Icons.access_alarm,
      pageRoute: '/',
    ),
    AssortedLectureItem(
      title: 'Humare Aamal',
      icon: Icons.access_alarm,
      pageRoute: '/',
    ),
    AssortedLectureItem(
      title: 'Miscellaneous',
      icon: Icons.access_alarm,
      pageRoute: '/',
    ),
  ];

  Widget _buildAssortedLecture(
      BuildContext context, AssortedLectureItem lecture) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, lecture.pageRoute);
      },
      child: Container(
        color: Color(0xffdedbdb),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              lecture.title,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            Icon(
              lecture.icon,
              size: 50,
            ),
          ],
        ),
      ),
    );
  }
}
