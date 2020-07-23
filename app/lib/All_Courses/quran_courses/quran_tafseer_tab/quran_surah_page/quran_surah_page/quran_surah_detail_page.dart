import 'package:arrahma_mobile_app/media_player/media_player.dart';
import 'package:arrahma_models/models.dart';
import 'package:flutter/material.dart';

class QuranSurahDetailPage extends StatefulWidget {
  const QuranSurahDetailPage({Key key, @required this.lessons})
      : super(key: key);
  final List<Lesson> lessons;

  @override
  _QuranSurahDetailPageState createState() => _QuranSurahDetailPageState();
}

class _QuranSurahDetailPageState extends State<QuranSurahDetailPage> {
  bool _isFav = false;
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: !_isSearching
            ? AppBar(
                centerTitle: true,
                title: Text(
                  'Lessons',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.star_border),
                    color: Colors.black,
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    color: Colors.black,
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
                    icon: Icon(Icons.cancel),
                    color: Colors.black,
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
                    "Continue to last Lesson",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: widget.lessons.length,
                    itemBuilder: (_, index) {
                      final lessons = widget.lessons[index];
                      return ListTile(
                        leading: Icon(Icons.branding_watermark),
                        title:
                            Text('${lessons.lessonNum} ${lessons.lessonName}'),
                        subtitle: Text(lessons.lessonAyah),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon:
                                  Icon(_isFav ? Icons.star : Icons.star_border),
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
                                  builder: (_) => MediaPlayerScreen()));
                        },
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
