import 'dart:async';

import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:inherited_state/inherited_state.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class QuranDetailsTab extends StatefulWidget {
  const QuranDetailsTab({Key key, @required this.details, @required this.title})
      : super(key: key);
  final QuranCourseDetails details;
  final String title;

  @override
  _QuranDetailsTabState createState() => _QuranDetailsTabState();
}

class _QuranDetailsTabState extends State<QuranDetailsTab> {
  final _apiService = SL.get<ApiService>();
  Future<PdfController> _pdfController;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant QuranDetailsTab oldWidget) {
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
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff124570),
        centerTitle: true,
        title: Text(
          widget.title,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: widget.details.type == QuranCourseDetailsType.Pdf
          ? FutureBuilder<PdfController>(
              future: _pdfController,
              builder: (_, snapshot) => snapshot.data == null
                  ? const CircularProgressIndicator()
                  : PdfView(
                      controller: snapshot.data,
                    ),
            )
          : Markdown(data: widget.details.details),
    );
  }
}
