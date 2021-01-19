import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';
import 'package:inherited_state/inherited_state.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class SimplePdfView extends StatefulWidget {
  const SimplePdfView({Key key, @required this.url}) : super(key: key);
  final String url;

  @override
  _SimplePdfViewState createState() => _SimplePdfViewState();
}

class _SimplePdfViewState extends State<SimplePdfView> {
  final _apiService = SL.get<ApiService>();
  Future<PdfController> _pdfController;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant SimplePdfView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _init();
    }
  }

  void _init() {
    _pdfController = _loadPdf();
  }

  Future<PdfController> _loadPdf() async {
    final result = await _apiService.downloadFile(widget.url);
    return PdfController(
        document: PdfDocument.openData(result.value), viewportFraction: 1);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PdfController>(
      future: _pdfController,
      builder: (_, snapshot) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: snapshot.hasError
            ? const Center(
                child: Text(
                    'Unable to load document. Please try again later or contact support.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontStyle: FontStyle.italic)))
            : snapshot.data == null
                ? const Center(child: CircularProgressIndicator())
                : PdfView(
                    controller: snapshot.data,
                  ),
      ),
    );
  }
}
