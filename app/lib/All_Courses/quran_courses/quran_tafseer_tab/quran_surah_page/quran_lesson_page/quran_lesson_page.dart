import 'package:arrahma_mobile_app/all_courses/quran_courses/quran_tafseer_tab/quran_surah_page/quran_lesson_detail/quran_lesson_detail.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';

class QuranLessonPage extends StatefulWidget {
  const QuranLessonPage({
    Key key,
    @required this.surah,
  }) : super(key: key);
  final Surah surah;

  @override
  _QuranLessonPageState createState() => _QuranLessonPageState();
}

class _QuranLessonPageState extends State<QuranLessonPage> {
  bool _isFav = false;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    if (widget.surah.lessons.length == 1)
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => _navigateToLesson(widget.surah.lessons.first));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff124570),
        centerTitle: true,
        title: const Text(
          'Lessons',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: widget.surah.lessons.length,
              itemBuilder: (_, index) {
                final lesson = widget.surah.lessons[index];
                return ListTile(
                  leading: const Icon(Icons.branding_watermark),
                  title: Text(lesson.title ??
                      'Lesson ${lesson.lessonNum}: Ayah ${lesson.ayahNum}'),
                  subtitle: lesson.uploadDate != null
                      ? Text(lesson.uploadDate)
                      : null,
                  onTap: () => _navigateToLesson(lesson),
                );
              },
              separatorBuilder: (_, __) => const Divider(thickness: 2),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToLesson(Lesson lesson) {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (_) =>
            QuranLessonAudioPage(surah: widget.surah, lesson: lesson),
      ),
    );
  }
}
