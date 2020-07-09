import 'package:flutter/material.dart';

class FavoriteSurah extends StatefulWidget {
  @override
  _FavoriteSurahState createState() => _FavoriteSurahState();
}

class _FavoriteSurahState extends State<FavoriteSurah> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Favorite Surah',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          actions: <Widget>[
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
                Expanded(
                  child: ListView.separated(
                    itemCount: 5,
                    itemBuilder: (_, index) => ListTile(
                      leading: Icon(Icons.branding_watermark),
                      title: const Text('Surah Al-Fatiha  الفاتحۃ'),
                      subtitle: const Text('The Opening'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                      ),
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
