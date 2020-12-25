import 'dart:async';

import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:inherited_state/inherited_state.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class QuranDetailsView extends StatefulWidget {
  const QuranDetailsView({Key key, @required this.details}) : super(key: key);
  final QuranCourseDetails details;

  @override
  _QuranDetailsViewState createState() => _QuranDetailsViewState();
}

class _QuranDetailsViewState extends State<QuranDetailsView> {
  final _apiService = SL.get<ApiService>();
  Future<PdfController> _pdfController;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant QuranDetailsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.details.type != widget.details.type) {
      _init();
    }
  }

  void _init() {
    if (widget.details.type == QuranCourseDetailsType.Pdf) {
      _pdfController = _loadPdf();
    }
  }

  Future<PdfController> _loadPdf() async {
    final result = await _apiService.downloadFile(widget.details.details);
    return PdfController(
        document: PdfDocument.openData(result.value), viewportFraction: 1);
  }

  @override
  Widget build(BuildContext context) {
    return widget.details.type == QuranCourseDetailsType.Pdf
        ? FutureBuilder<PdfController>(
            future: _pdfController,
            builder: (_, snapshot) => snapshot.data == null
                ? const CircularProgressIndicator()
                : PdfView(
                    controller: snapshot.data,
                  ),
          )
        : Markdown(data: widget.details.details);
  }
}
