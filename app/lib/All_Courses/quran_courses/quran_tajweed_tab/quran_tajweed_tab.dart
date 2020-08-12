import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_tafseer_tab/quran_surah_page/quran_surah_page.dart';
import 'package:arrahma_mobile_app/media_player/media_player.dart';
import 'package:arrahma_models/models.dart';
import 'package:flutter/material.dart';

class QuranTajweedTab extends StatelessWidget {
  const QuranTajweedTab({
    Key key,
    @required this.title,
    @required this.tajweed,
  }) : super(key: key);
  final String title;
  final QuranCourseTajweed tajweed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff124570),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRawItem(
                context,
                'Introduction',
                () {
                  Navigator.push<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                          builder: (_) => MediaPlayerScreen()));
                },
              ),
              ...tajweed.items.map((item) => _buildItem(context, item)).toList()
            ]),
      ),
    );
  }

  Widget _buildRawItem(BuildContext context, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.black,
              size: 45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, QuranCourseTajweedItem item) {
    return _buildRawItem(context, item.title, () {
      Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (_) => QuranSurahPage(
                    surahs: item.surahs,
                  )));
    });
  }
}
