import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_tafseer_tab/quran_surah_page/quran_lesson_page/quran_lesson_page.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';

import 'quran_lesson_detail/quran_lesson_detail.dart';

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
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xff124570),
          centerTitle: true,
          title: const Text(
            'Surah Detail',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: widget.surahs.length,
                    itemBuilder: (_, index) {
                      final surah = widget.surahs[index];
                      return ListTile(
                        leading: const Icon(Icons.branding_watermark),
                        title: Text('${surah.name} ${surah.arabicName ?? ''}'),
                        subtitle: surah.description != null
                            ? Text(surah.description)
                            : null,
                        onTap: () {
                          Navigator.push<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (_) => surah.lessons.length > 1
                                  ? QuranLessonPage(surah: surah)
                                  : QuranLessonAudioPage(
                                      surah: surah, lesson: surah.lessons[0]),
                            ),
                          );
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
