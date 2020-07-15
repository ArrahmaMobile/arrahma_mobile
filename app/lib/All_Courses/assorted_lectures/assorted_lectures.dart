import 'package:flutter/material.dart';
import 'model/assorted_lectures.dart';

class AssortedLecturesCourse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Lectures',
          style: TextStyle(color: Colors.black),
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
      pageRoute: '/',
    ),
    AssortedLectureItem(
      title: 'Marriage',
      pageRoute: '/',
    ),
    AssortedLectureItem(
      title: 'Akhirah',
      pageRoute: '/',
    ),
    AssortedLectureItem(
      title: 'Months and Events',
      pageRoute: '/',
    ),
    AssortedLectureItem(
      title: 'Padaab-e-Zindagi',
      pageRoute: '/',
    ),
    AssortedLectureItem(
      title: "Rubb Se Taa'luk",
      pageRoute: '/',
    ),
    AssortedLectureItem(
      title: 'Imaan',
      pageRoute: '/',
    ),
    AssortedLectureItem(
      title: 'Humare Rasool ﷺ',
      pageRoute: '/',
    ),
    AssortedLectureItem(
      title: 'Duniya ki zindagi',
      pageRoute: '/',
    ),
    AssortedLectureItem(
      title: 'Quran/ilm',
      pageRoute: '/',
    ),
    AssortedLectureItem(
      title: 'Humare Aamal',
      pageRoute: '/',
    ),
    AssortedLectureItem(
      title: 'Miscellaneous',
      pageRoute: '/',
    ),
  ];

  Widget _buildAssortedLecture(
      BuildContext context, AssortedLectureItem lecture) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, lecture.pageRoute);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            lecture.title,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
