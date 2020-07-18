import 'package:arrahma_mobile_app/All_Courses/assorted_lectures/assorted_lecture.dart';
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
    AssortedLectureCategoryItem(
      title: 'New Lectures',
      lectures: List.generate(
        10,
        (index) => AssortedLecture(
          title: 'Lecture on Zakat By Ustadh Abu Saif (2019)',
          subtitle: 'زکوٰۃ ـ استاد ابو سیف',
          audioLength: '12:14',
        ),
      ),
    ),
    AssortedLectureCategoryItem(
      title: 'Marriage',
      lectures: [],
    ),
    AssortedLectureCategoryItem(
      title: 'Akhirah',
      lectures: [],
    ),
    AssortedLectureCategoryItem(
      title: 'Months and Events',
      lectures: [],
    ),
    AssortedLectureCategoryItem(
      title: 'Padaab-e-Zindagi',
      lectures: [],
    ),
    AssortedLectureCategoryItem(
      title: "Rubb Se Taa'luk",
      lectures: [],
    ),
    AssortedLectureCategoryItem(
      title: 'Imaan',
      lectures: [],
    ),
    AssortedLectureCategoryItem(
      title: 'Humare Rasool ﷺ',
      lectures: [],
    ),
    AssortedLectureCategoryItem(
      title: 'Duniya ki zindagi',
      lectures: [],
    ),
    AssortedLectureCategoryItem(
      title: 'Quran/ilm',
      lectures: [],
    ),
    AssortedLectureCategoryItem(
      title: 'Humare Aamal',
      lectures: [],
    ),
    AssortedLectureCategoryItem(
      title: 'Miscellaneous',
      lectures: [],
    ),
  ];

  Widget _buildAssortedLecture(
      BuildContext context, AssortedLectureCategoryItem lecture) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/assorted_lecture_page',
            arguments: lecture);
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
