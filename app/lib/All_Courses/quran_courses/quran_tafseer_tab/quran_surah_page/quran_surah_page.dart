import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_tafseer_tab/quran_surah_page/quran_surah_page/quran_surah_detail_page.dart';
import 'package:arrahma_models/models.dart';
import 'package:flutter/material.dart';

class QuranJuzDetailPage extends StatefulWidget {
  const QuranJuzDetailPage({Key key, @required this.surahs}) : super(key: key);
  final List<Surah> surahs;

  @override
  _QuranJuzDetailPageState createState() => _QuranJuzDetailPageState();
}

class _QuranJuzDetailPageState extends State<QuranJuzDetailPage> {
  bool _isFav = false;
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: !_isSearching
            ? AppBar(
                backgroundColor: Colors.white,
                centerTitle: true,
                title: Text(
                  'Surah Detail',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.star_border),
                    color: Colors.black,
                    onPressed: () {
                      Navigator.pushNamed(context, '/favorite_surah');
                    },
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
                backgroundColor: Colors.white,
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
                    "Continue to last Surah",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: widget.surahs.length,
                    itemBuilder: (_, index) {
                      final surah = widget.surahs[index];
                      return ListTile(
                        leading: Icon(Icons.branding_watermark),
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => QuranSurahDetailPage(
                                        lessons: [],
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
