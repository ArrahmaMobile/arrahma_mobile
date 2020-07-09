import 'package:flutter/material.dart';

class FavoriteJuz extends StatefulWidget {
  @override
  _FavoriteJuzState createState() => _FavoriteJuzState();
}

class _FavoriteJuzState extends State<FavoriteJuz> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Favorite Juz',
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
                      title: const Text('Juz 1    الم'),
                      subtitle: const Text('Lesson 1: Ayah 1-3 '),
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
