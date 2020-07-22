import 'package:flutter/material.dart';

class HadithLessonDetails extends StatefulWidget {
  @override
  _HadithLessonDetailsState createState() => _HadithLessonDetailsState();
}

class _HadithLessonDetailsState extends State<HadithLessonDetails> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Hadith Lessons',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
                    itemCount: 5,
                    itemBuilder: (_, index) => ListTile(
                      title: const Text('ضروري اصطلاحات'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.volume_up),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/media_player_screen');
                            },
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
