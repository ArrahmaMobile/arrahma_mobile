import 'package:arrahma_mobile_app/All_Courses/assorted_lectures/assorted_lecture.dart';
import 'package:arrahma_mobile_app/All_Courses/assorted_lectures/assorted_lecture_page.dart';
import 'package:arrahma_mobile_app/All_Courses/assorted_lectures/model/assorted_lectures.dart';
import 'package:flutter/material.dart';

class WeeklyGems extends StatefulWidget {
  @override
  _WeeklyGemsState createState() => _WeeklyGemsState();
}

class _WeeklyGemsState extends State<WeeklyGems> {
  @override
  Widget build(BuildContext context) {
    return AssortedLecturePage(
      item: AssortedLectureCategoryItem(
        title: 'Weekly Gems',
        lectures: [
          AssortedLecture(
            title: 'Ek Naik aurat ki anokhi nazar',
            subtitle: 'سورہٴ ال عمران ٣٥  ایک نیک عورت کی انوکھی نظر',
            audioLength: '12:14',
          )
        ],
      ),
    );
  }
}
