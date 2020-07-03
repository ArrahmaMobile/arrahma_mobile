import 'package:flutter/material.dart';

class TaleemmulQuranFavorite extends StatefulWidget {
  @override
  _TaleemmulQuranFavoriteState createState() => _TaleemmulQuranFavoriteState();
}

class _TaleemmulQuranFavoriteState extends State<TaleemmulQuranFavorite> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Bookmark',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          actions: <Widget>[
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
      ),
    );
  }
}
