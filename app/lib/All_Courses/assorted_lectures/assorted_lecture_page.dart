import 'package:arrahma_mobile_app/All_Courses/assorted_lectures/model/assorted_lectures.dart';
import 'package:flutter/material.dart';

class AssortedLecturePage extends StatefulWidget {
  const AssortedLecturePage({Key key, this.item}) : super(key: key);
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
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            widget.item.title,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: 10,
                    itemBuilder: (_, index) {
                      final item = widget.item.lectures[index];
                      return ListTile(
                        leading: Icon(
                          Icons.branding_watermark,
                          color: Colors.black,
                        ),
                        title: Text(
                          item.title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          item.subtitle,
                          style: TextStyle(
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
                              child: Icon(
                                Icons.volume_up,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 2),
                            Text(
                              item.audioLength,
                              style: TextStyle(
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
