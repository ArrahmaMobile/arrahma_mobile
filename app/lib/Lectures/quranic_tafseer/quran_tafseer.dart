import 'package:arrahma_mobile_app/lectures/quranic_tafseer/model/quran_tafseer.dart';
import 'package:flutter/material.dart';

class QuranTafseer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff124570),
        centerTitle: true,
        title: Text(
          'Quran Tafseer',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
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
    const QuranTafseerItem<dynamic>(
      title: '2019 New Courses',
      pageRoute: '/quran_tafseer_tab',
      data: '',
    ),
    const QuranTafseerItem<dynamic>(
      title: 'Tafseer - 2013',
      pageRoute: '/quran_tafseer_tab',
      data: '',
    ),
    const QuranTafseerItem<dynamic>(
      title: 'Tafseer - 2007',
      pageRoute: '/quran_tafseer_tab',
      data: '',
    ),
    const QuranTafseerItem<dynamic>(
      title: 'Ahsan-Ul-Bayan',
      pageRoute: '/juz_detail_page',
      data: '',
    ),
    const QuranTafseerItem<dynamic>(
      title: 'Al-Furqan',
      pageRoute: '/juz_detail_page',
      data: '',
    ),
    const QuranTafseerItem<dynamic>(
      title: 'llm-ul-Uaqeen',
      pageRoute: '/juz_detail_page',
      data: '',
    ),
    const QuranTafseerItem<dynamic>(
      title: 'Al-Misbah',
      pageRoute: '/supplementary_course',
    )
  ];

  Widget _buildQuranTafseer(BuildContext context, QuranTafseerItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, item.pageRoute);
      },
      child: Container(
        color: const Color(0xff124570),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              item.title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
