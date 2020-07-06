import 'package:arrahma_mobile_app/Drawer/main_drawer.dart';
import 'package:arrahma_mobile_app/Media_Player/media_player.dart';
import 'package:flutter/material.dart';
import 'Surah_Detail_page/surah_detail_page.dart';
import 'taleemmul_quran_favorite.dart';

class TafseerPage extends StatefulWidget {
  @override
  _TafseerPageState createState() => _TafseerPageState();
}

bool _isFav = false;

class _TafseerPageState extends State<TafseerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Adv Taleemmul Quran',
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
                  builder: (context) => TaleemmulQuranFavorite(),
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
        bottom: TabBar(tabs: [
          Tab(
            text: 'Juz',
          ),
          Tab(
            text: 'Surah',
          ),
        ]),
      ),
      body: TabBarView(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: const Text(
                  "Continue to last Juz'",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: 5,
                  itemBuilder: (_, index) => ListTile(
                    leading: Icon(Icons.branding_watermark),
                    title: const Text('Lesson 1: Ayah 1-3'),
                    subtitle: const Text('The Opening (7)'),
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
                          builder: (context) => MediaPlayerScreen(),
                        ),
                      );
                    },
                  ),
                  separatorBuilder: (_, __) => const Divider(thickness: 2),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: const Text(
                  "Continue to last Surah'",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: 5,
                  itemBuilder: (_, index) => ListTile(
                    leading: Icon(Icons.branding_watermark),
                    title: const Text('Surah Al-Fatiha  الفاتحۃ'),
                    subtitle: const Text('Lesson 1: Ayah 1-3'),
                    trailing: Icon(Icons.star_border),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SurahDetailPage(),
                        ),
                      );
                    },
                  ),
                  separatorBuilder: (_, __) => const Divider(thickness: 2),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
