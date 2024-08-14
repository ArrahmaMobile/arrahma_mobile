import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_framework/flutter_framework.dart';
import 'package:inherited_state/inherited_state.dart';
import 'package:path/path.dart' as path;
import 'package:pdfx/pdfx.dart';

import 'models/saved_file.dart';

class SimplePdfViewer extends StatefulWidget {
  const SimplePdfViewer({
    super.key,
    required this.url,
    this.title,
  });
  final String url;
  final String? title;

  @override
  _SimplePdfViewerState createState() => _SimplePdfViewerState();
}

class _SimplePdfViewerState extends State<SimplePdfViewer> {
  final _apiService = SL.get<ApiService>()!;
  late Future<PdfController> _pdfController;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant SimplePdfViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _init();
    }
  }

  void _init() {
    _pdfController = _loadPdf();
  }

  Future<PdfController> _loadPdf() async {
    final cacheManager = DefaultCacheManager();
    final file = await cacheManager.getFileFromCache(widget.url);

    if (file != null && await file.file.exists()) {
      // Use the cached file if it exists
      return PdfController(document: PdfDocument.openFile(file.file.path));
    } else {
      final result = _apiService.downloadFile(widget.url);
      _saveToFile(result);
      return PdfController(
        document: PdfDocument.openData((await result).value!),
        viewportFraction: 1,
      );
    }
  }

  Future<SavedFile> _saveToFile(
      Future<KeyValuePair<String?, Uint8List?>> fileDataFuture) async {
    final data = await fileDataFuture;
    final fileExtension = path.extension(widget.url);
    // final fileName = path.basenameWithoutExtension(widget.url);
    final normalizedFileExtension = !StringUtils.isNullOrEmpty(fileExtension)
        ? fileExtension.substring(1)
        : 'pdf';
    final file = await DefaultCacheManager().putFile(widget.url, data.value!,
        fileExtension: normalizedFileExtension);
    return SavedFile(path: file.path);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PdfController>(
      future: _pdfController,
      builder: (_, snapshot) => snapshot.hasError
          ? const Center(
              child: Text(
                  'Unable to load document. Please try again later or contact support.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontStyle: FontStyle.italic)))
          : snapshot.data == null
              ? const Center(child: CircularProgressIndicator())
              : PdfView(
                  controller: snapshot.data!,
                ),
    );
  }
}
