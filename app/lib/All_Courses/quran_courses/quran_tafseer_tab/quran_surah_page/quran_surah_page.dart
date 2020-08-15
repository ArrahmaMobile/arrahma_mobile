import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_tafseer_tab/quran_surah_page/quran_lesson_page/quran_lesson_page.dart';
import 'package:arrahma_models/models.dart';
import 'package:flutter/material.dart';

class QuranSurahPage extends StatefulWidget {
  const QuranSurahPage({
    Key key,
    @required this.surahs,
  }) : super(key: key);
  final List<Surah> surahs;

  @override
  _QuranSurahPageState createState() => _QuranSurahPageState();
}

class _QuranSurahPageState extends State<QuranSurahPage> {
  bool _isFav = false;
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: !_isSearching
            ? AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: const Color(0xff124570),
                centerTitle: true,
                title: const Text(
                  'Surah Detail',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.star_border),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pushNamed(context, '/favorite_surah');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
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
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: const Color(0xff124570),
                title: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 5.0, vertical: 8.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(22.0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 10.0),
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
                    icon: const Icon(Icons.cancel),
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
                    'Continue to last Surah',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: widget.surahs.length,
                    itemBuilder: (_, index) {
                      final surah = widget.surahs[index];
                      return ListTile(
                        leading: const Icon(Icons.branding_watermark),
                        title: Text('${surah.name} ${surah.arabicName}'),
                        subtitle: Text(surah.description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                _isFav ? Icons.star : Icons.star_border,
                                color: Colors.black,
                              ),
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
                                  builder: (_) => QuranLessonPage(
                                        lessons: surah.lessons,
                                      )));
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
