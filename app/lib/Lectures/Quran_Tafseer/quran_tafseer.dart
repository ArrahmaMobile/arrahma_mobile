import 'package:arrahma_mobile_app/Lectures/Quran_Tafseer/model/quran_tafseer.dart';
import 'package:flutter/material.dart';

class QuranTafseer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Quran Tafseer',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            _quranList(context),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _quranList(BuildContext context) {
    return GridView.count(
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        crossAxisCount: 2,
        shrinkWrap: true,
        childAspectRatio: 1.9,
        children: _quranTafseer
            .map((item) => _buildQuranTafseer(context, item))
            .toList());
  }

  final _quranTafseer = [
    QuranTafseerItem(
      title: '2019 New Courses',
      pageRoute: '/quran_tafseer_tab',
    ),
    QuranTafseerItem(
      title: 'Tafseer - 2013',
      pageRoute: '/quran_tafseer_tab',
    ),
    QuranTafseerItem(
      title: 'Tafseer - 2007',
      pageRoute: '/quran_tafseer_tab',
    ),
    QuranTafseerItem(
      title: 'Ahsan-Ul-Bayan',
      pageRoute: '/juz_detail_page',
    ),
    QuranTafseerItem(
      title: 'Al-Furqan',
      pageRoute: '/juz_detail_page',
    ),
    QuranTafseerItem(
      title: 'llm-ul-Uaqeen',
      pageRoute: '/juz_detail_page',
    ),
    QuranTafseerItem(
      title: 'Al-Misbah',
      pageRoute: '/misbah_lectures_tab',
    )
  ];

  Widget _buildQuranTafseer(BuildContext context, QuranTafseerItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, item.pageRoute);
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
