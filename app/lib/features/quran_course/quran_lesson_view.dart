import 'package:arrahma_mobile_app/core/utils.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'quran_lesson_detail_view.dart';

class QuranLessonView extends StatefulWidget {
  const QuranLessonView({
    super.key,
    required this.surah,
  });
  final Surah surah;

  @override
  _QuranLessonViewState createState() => _QuranLessonViewState();
}

class _QuranLessonViewState extends State<QuranLessonView> {
  @override
  void initState() {
    super.initState();
    if (widget.surah.lessons.length == 1)
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => _navigateToLesson(widget.surah.lessons.first, true));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.surah.lessons.length,
      itemBuilder: (_, index) {
        final lesson = widget.surah.lessons[index];
        return ListTile(
          leading: const FaIcon(FontAwesomeIcons.solidNoteSticky),
          title: Text(lesson.title ??
              (lesson.lessonNum != null && lesson.ayahNum != null
                  ? 'Lesson ${lesson.lessonNum}: Ayah ${lesson.ayahNum}'
                  : 'Part ${index + 1}')),
          subtitle: lesson.uploadDate != null ? Text(lesson.uploadDate!) : null,
          onTap: () => _navigateToLesson(lesson),
        );
      },
      separatorBuilder: (_, __) => const Divider(
        thickness: 2,
        height: 2,
      ),
    );
  }

  void _navigateToLesson(Lesson lesson, [bool replace = false]) {
    Utils.pushView(
      context,
      QuranLessonDetailView(
        surah: widget.surah,
        lesson: lesson,
      ),
      title: '',
      replace: replace,
    );
  }
}
