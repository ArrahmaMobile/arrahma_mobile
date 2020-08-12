import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_tafseer_tab/quran_surah_page/quran_lesson_detail/quran_lesson_detail.dart';
import 'package:arrahma_mobile_app/media_player/media_player.dart';
import 'package:arrahma_models/models.dart';
import 'package:flutter/material.dart';

class QuranLessonPage extends StatefulWidget {
  const QuranLessonPage({
    Key key,
    @required this.lessons,
  }) : super(key: key);
  final List<Lesson> lessons;

  @override
  _QuranLessonPageState createState() => _QuranLessonPageState();
}

class _QuranLessonPageState extends State<QuranLessonPage> {
  bool _isFav = false;
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: !_isSearching
            ? AppBar(
                iconTheme: IconThemeData(color: Colors.white),
                backgroundColor: const Color(0xff124570),
                centerTitle: true,
                title: Text(
                  'Lessons',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.star_border),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
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
                iconTheme: IconThemeData(color: Colors.white),
                backgroundColor: const Color(0xff124570),
                title: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 5.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(
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
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'Continue to last Lesson',
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
                        title: Text(
                            'Lesson ${lessons.lessonNum}: Ayah ${lessons.ayahNum}'),
                        subtitle: Text(lessons.uploadDate),
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
                          Navigator.push<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                  builder: (_) => QuranLessonAudioPage()));
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
