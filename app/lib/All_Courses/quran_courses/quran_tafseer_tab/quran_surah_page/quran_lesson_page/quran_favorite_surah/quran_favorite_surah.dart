import 'package:flutter/material.dart';

class QuranFavoriteSurah extends StatefulWidget {
  @override
  _QuranFavoriteSurahState createState() => _QuranFavoriteSurahState();
}

class _QuranFavoriteSurahState extends State<QuranFavoriteSurah> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: !_isSearching
            ? AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: const Color(0xff124570),
                centerTitle: true,
                title: const Text(
                  'Favorite Surah',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.search),
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
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: const Color(0xff124570),
                title: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 5.0, vertical: 8.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(22.0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: TextField(
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.black)),
                    ),
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.cancel),
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
                Expanded(
                  child: GestureDetector(
                    child: ListView.separated(
                      itemCount: 5,
                      itemBuilder: (_, index) => ListTile(
                        leading: const Icon(Icons.branding_watermark),
                        title: const Text('Surah Al-Fatiha  الفاتحۃ'),
                        subtitle: const Text('The Opening'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                        ),
                      ),
                      separatorBuilder: (_, __) => const Divider(thickness: 2),
                    ),
                    onTap: () {},
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
