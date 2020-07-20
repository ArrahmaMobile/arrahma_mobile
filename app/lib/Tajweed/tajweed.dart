import 'package:arrahma_mobile_app/All_Courses/quran_courses/models/quran_course.dart';
import 'package:arrahma_mobile_app/Tajweed/model/tajweed.dart';
import 'package:flutter/material.dart';

class Tajweed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Tajweed',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            _tajweedList(context),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _tajweedList(BuildContext context) {
    return GridView.count(
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 1.9,
      children: _tajweedItem
          .map(
            (item) => _buildTajweedItem(context, item),
          )
          .toList(),
    );
  }

  final _tajweedItem = [
    TajweedItem(
      title: 'Adv Taleem Ul Quran',
      pageRoute: '/quran_course_page',
      data: QuranCourse(
        title: 'Adv Taleemul Quran',
        courseDetailPdfUrl: '',
      ),
    ),
    TajweedItem(
      title: 'Taleem Ul Quran',
      pageRoute: '/quran_course_page',
      data: QuranCourse(
        title: 'Taleem Quran',
        courseDetailPdfUrl: '',
      ),
    ),
    TajweedItem(
      title: 'Fehm Ul Quran',
      pageRoute: '/quran_course_page',
      data: QuranCourse(
        title: 'Fehm Ul Quran',
        courseDetailPdfUrl: '',
      ),
    ),
    TajweedItem(
      title: 'English Qaida',
      pageRoute: '/english_qaida',
    ),
    TajweedItem(
      title: 'Noorani Qaida',
      pageRoute: '/',
    ),
    TajweedItem(
      title: 'Juz 30 Hifz',
      pageRoute: '/juz_30_hifz',
    ),
    TajweedItem(
      title: 'Taleem Ul Quran 2013',
      pageRoute: '/taleem_quran_2013',
    )
  ];

  Widget _buildTajweedItem(BuildContext context, TajweedItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, item.pageRoute, arguments: item.data);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            item.title,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
