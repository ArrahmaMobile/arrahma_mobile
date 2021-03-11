import 'dart:async';
import 'dart:typed_data';

import 'package:arrahma_mobile_app/core/utils.dart';
import 'package:arrahma_mobile_app/features/common/themed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_framework/flutter_framework.dart';
import 'package:inherited_state/inherited_state.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class SimplePdfView extends StatefulWidget {
  const SimplePdfView({
    Key key,
    @required this.url,
    this.title,
  }) : super(key: key);
  final String url;
  final String title;

  @override
  _SimplePdfViewState createState() => _SimplePdfViewState();
}

class _SimplePdfViewState extends State<SimplePdfView> {
  final _apiService = SL.get<ApiService>();
  Future<PdfController> _pdfController;
  Future<String> _filePathFuture;

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
    final result = _apiService.downloadFile(widget.url);
    _filePathFuture = _saveToFile(result);
    return PdfController(
        document: PdfDocument.openData((await result).value),
        viewportFraction: 1);
  }

  Future<String> _saveToFile(
      Future<KeyValuePair<String, Uint8List>> fileDataFuture) async {
    final data = await fileDataFuture;
    final file = await DefaultCacheManager().putFile(widget.url, data.value);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.title != null)
          ThemedAppBar(
            title: widget.title,
            actions: [
              FutureBuilder<String>(
                future: _filePathFuture,
                builder: (_, s) => Utils.shareActionButton(
                  widget.title,
                  s.data != null ? [s.data] : null,
                ),
              )
            ],
          ),
        Expanded(
          child: FutureBuilder<PdfController>(
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
          ),
        ),
      ],
    );
  }
}
