import 'package:arrahma_mobile_app/features/common/simple_pdf_view.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class QuranDetailsView extends StatefulWidget {
  const QuranDetailsView({Key key, @required this.courseDetails})
      : super(key: key);
  final QuranCourseDetails courseDetails;

  @override
  _QuranDetailsViewState createState() => _QuranDetailsViewState();
}

class _QuranDetailsViewState extends State<QuranDetailsView> {
  @override
  Widget build(BuildContext context) {
    return widget.courseDetails.type == QuranCourseDetailsType.Pdf
        ? SimplePdfView(url: widget.courseDetails.details)
        : Markdown(data: widget.courseDetails.details);
  }
}
