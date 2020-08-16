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
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xff124570),
          centerTitle: true,
          title: const Text(
            'Hadith Lessons',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                const Padding(
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
                            icon: const Icon(Icons.volume_up),
                            color: Colors.black,
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
