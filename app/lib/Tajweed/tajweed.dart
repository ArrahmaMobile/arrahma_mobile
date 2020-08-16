import 'package:arrahma_mobile_app/Tajweed/model/tajweed.dart';
import 'package:arrahma_models/models.dart';
import 'package:flutter/material.dart';

class Tajweed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff124570),
        centerTitle: true,
        title: const Text(
          'Tajweed',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
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
    const TajweedItem<dynamic>(
      title: 'Adv Taleem Ul Quran',
      pageRoute: '/quran_course_page',
      data: QuranCourse(
        title: 'Adv Taleemul Quran',
        courseDetailPdfUrl: '',
      ),
    ),
    const TajweedItem<dynamic>(
      title: 'Taleem Ul Quran',
      pageRoute: '/quran_course_page',
      data: QuranCourse(
        title: 'Taleem Quran',
        courseDetailPdfUrl: '',
      ),
    ),
    const TajweedItem<dynamic>(
      title: 'Fehm Ul Quran',
      pageRoute: '/quran_course_page',
      data: QuranCourse(
        title: 'Fehm Ul Quran',
        courseDetailPdfUrl: '',
      ),
    ),
    const TajweedItem<dynamic>(
      title: 'English Qaida',
      pageRoute: '/english_qaida',
    ),
    const TajweedItem<dynamic>(
      title: 'Noorani Qaida',
      pageRoute: '/',
    ),
    const TajweedItem<dynamic>(
      title: 'Juz 30 Hifz',
      pageRoute: '/juz_30_hifz',
    ),
    const TajweedItem<dynamic>(
      title: 'Taleem Ul Quran 2013',
      pageRoute: '/taleem_quran_2013',
    )
  ];

  Widget _buildTajweedItem(BuildContext context, TajweedItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, item.pageRoute, arguments: item.data);
      },
      child: Container(
        color: const Color(0xff124570),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              item.title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
