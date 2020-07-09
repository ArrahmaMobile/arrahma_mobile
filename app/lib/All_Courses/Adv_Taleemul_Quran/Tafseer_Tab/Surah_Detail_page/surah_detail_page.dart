import 'package:arrahma_mobile_app/All_Courses/Adv_Taleemul_Quran/Tafseer_Tab/Surah_Detail_page/Juz_Detail_Page/juz_detail_page.dart';
import 'package:flutter/material.dart';

import 'Favorite_Juz/favorite_juz.dart';

class SurahDetailPage extends StatefulWidget {
  @override
  _SurahDetailPageState createState() => _SurahDetailPageState();
}

bool _isFav = false;

class _SurahDetailPageState extends State<SurahDetailPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Surah Detail',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.star_border),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoriteJuz(),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              color: Colors.white,
              onPressed: () {},
            ),
          ],
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: const Text(
                    "Continue to last Juz",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: 5,
                    itemBuilder: (_, index) => ListTile(
                      leading: Icon(Icons.branding_watermark),
                      title: const Text('Juz 1    الم'),
                      subtitle: const Text('Lesson 1: Ayah 1-3 '),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(_isFav ? Icons.star : Icons.star_border),
                            onPressed: () {
                              setState(() {
                                _isFav = !_isFav;
                              });
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JuzDetailPage(),
                          ),
                        );
                      },
                    ),
                    separatorBuilder: (_, __) => const Divider(thickness: 2),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
