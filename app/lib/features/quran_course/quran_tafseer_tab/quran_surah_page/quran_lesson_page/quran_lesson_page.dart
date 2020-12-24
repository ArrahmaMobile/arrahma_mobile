import 'package:arrahma_mobile_app/features/common/themed_app_bar.dart';
import 'package:arrahma_mobile_app/features/quran_course/quran_tafseer_tab/quran_surah_page/quran_lesson_detail/quran_lesson_detail.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';

class QuranLessonPage extends StatefulWidget {
  const QuranLessonPage({
    Key key,
    @required this.surah,
    @required this.title,
  }) : super(key: key);
  final Surah surah;
  final String title;

  @override
  _QuranLessonPageState createState() => _QuranLessonPageState();
}

class _QuranLessonPageState extends State<QuranLessonPage> {
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
      appBar: ThemedAppBar(
        title: widget.title,
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
