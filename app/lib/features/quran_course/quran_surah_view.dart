import 'package:arrahma_mobile_app/core/utils.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'quran_lesson_view.dart';

class QuranSurahView extends StatefulWidget {
  const QuranSurahView({
    Key key,
    @required this.content,
    this.referrerTitle,
  }) : super(key: key);
  final QuranCourseContent content;
  final String referrerTitle;

  @override
  _QuranSurahViewState createState() => _QuranSurahViewState();
}

class _QuranSurahViewState extends State<QuranSurahView> {
  @override
  void initState() {
    super.initState();
    if (widget.content.surahs.length == 1)
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => _navigateToLessonView(widget.content.surahs.first, true));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.content.surahs.length,
      itemBuilder: (_, index) {
        final surah = widget.content.surahs[index];
        return ListTile(
          leading: const FaIcon(FontAwesomeIcons.book),
          title: Text('${surah.name} ${surah.arabicName ?? ''}'),
          subtitle: surah.description != null ? Text(surah.description) : null,
          onTap: () => _navigateToLessonView(surah),
        );
      },
      separatorBuilder: (_, __) => const Divider(
        thickness: 2,
        height: 2,
      ),
    );
  }

  void _navigateToLessonView(Surah surah, [bool replace = false]) {
    Utils.pushView(
      context,
      QuranLessonView(
        surah: surah,
      ),
      title: replace
          ? widget.referrerTitle ?? widget.content.title ?? surah.name
          : surah.name ?? widget.content.title,
      replace: replace,
    );
  }
}
