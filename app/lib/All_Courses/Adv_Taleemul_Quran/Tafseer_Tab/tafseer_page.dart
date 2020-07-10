import 'package:arrahma_mobile_app/All_Courses/Adv_Taleemul_Quran/Tafseer_Tab/Surah_Detail_page/Favorite_Surah/favorite_surah.dart';
import 'package:arrahma_mobile_app/All_Courses/Adv_Taleemul_Quran/Tafseer_Tab/Surah_Detail_page/surah_detail_page.dart';
import 'package:arrahma_mobile_app/Drawer/main_drawer.dart';
import 'package:flutter/material.dart';

class TafseerPage extends StatefulWidget {
  @override
  _TafseerPageState createState() => _TafseerPageState();
}

class _TafseerPageState extends State<TafseerPage> {
  bool _isFav = false;
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        drawer: !_isSearching ? MainDrawer() : null,
        appBar: !_isSearching
            ? AppBar(
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
                          builder: (context) => FavoriteSurah(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    color: Colors.white,
                    onPressed: () {
                      setState(() {
                        _isSearching = true;
                      });
                    },
                  ),
                ],
              )
            : AppBar(
                title: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(22.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.cancel),
                    color: Colors.white,
                    onPressed: () {
                      setState(() {
                        _isSearching = false;
                      });
                    },
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
                      subtitle: const Text('The Opening'),
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
                            builder: (context) => SurahDetailPage(),
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
