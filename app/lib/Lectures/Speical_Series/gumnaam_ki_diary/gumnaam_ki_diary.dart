import 'package:flutter/material.dart';

class GumnaamKiDiary extends StatefulWidget {
  @override
  _GumnaamKiDiaryState createState() => _GumnaamKiDiaryState();
}

class _GumnaamKiDiaryState extends State<GumnaamKiDiary> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Gumnaam Ki Diary',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: 10,
                    itemBuilder: (_, index) => ListTile(
                      leading: Icon(
                        Icons.branding_watermark,
                        color: Colors.black,
                      ),
                      title: const Text(
                        'یری ترجیحات .. حصہ اول ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Meri tarjeehat-Part 1'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(width: 5),
                          IconButton(
                            icon: Icon(Icons.volume_up, color: Colors.black),
                            onPressed: () {},
                          )
                        ],
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
