import 'package:arrahma_mobile_app/all_courses/assorted_lectures/model/assorted_lectures.dart';
import 'package:flutter/material.dart';

class AssortedLecturePage extends StatefulWidget {
  const AssortedLecturePage({Key key, @required this.item}) : super(key: key);
  final AssortedLectureCategoryItem item;

  @override
  _AssortedLecturePageState createState() => _AssortedLecturePageState();
}

class _AssortedLecturePageState extends State<AssortedLecturePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xff124570),
          centerTitle: true,
          title: Text(
            widget.item.title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: 10,
                    itemBuilder: (_, index) {
                      final item = widget.item.lectures[index];
                      return ListTile(
                        leading: const Icon(
                          Icons.branding_watermark,
                          color: Colors.black,
                        ),
                        title: Text(
                          item.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          item.subtitle,
                          style: const TextStyle(
                              color: Colors.lightBlue,
                              fontWeight: FontWeight.bold),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/media_player_screen');
                              },
                              child: const Icon(
                                Icons.volume_up,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              item.audioLength,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    },
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
