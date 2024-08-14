import 'dart:async';
import 'dart:typed_data';

import 'package:arrahma_mobile_app/core/utils.dart';
import 'package:arrahma_mobile_app/features/common/themed_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_framework/flutter_framework.dart';
import 'package:inherited_state/inherited_state.dart';
import 'package:path/path.dart' as path;
import 'package:pdfx/pdfx.dart';

import 'models/saved_file.dart';

class SimplePdfView extends StatefulWidget {
  const SimplePdfView({
    super.key,
    required this.url,
    this.title,
  });
  final String url;
  final String? title;

  @override
  _SimplePdfViewState createState() => _SimplePdfViewState();
}

class _SimplePdfViewState extends State<SimplePdfView> {
  final _apiService = SL.get<ApiService>()!;
  late Future<PdfController> _pdfController;
  late Future<SavedFile> _filePathFuture;

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
        document: PdfDocument.openData((await result).value!),
        viewportFraction: 1);
  }

  Future<SavedFile> _saveToFile(
      Future<KeyValuePair<String?, Uint8List?>> fileDataFuture) async {
    final data = await fileDataFuture;
    final fileExtension = path.extension(widget.url);
    final fileName = path.basenameWithoutExtension(widget.url);
    final normalizedFileExtension = !StringUtils.isNullOrEmpty(fileExtension)
        ? fileExtension.substring(1)
        : 'pdf';
    final file = await DefaultCacheManager().putFile(widget.url, data.value!,
        fileExtension: normalizedFileExtension);
    final tempFile = await FileUtils.copyFileToTempPath(
        file, widget.title ?? fileName, normalizedFileExtension);
    return SavedFile(path: tempFile.path);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.title != null)
          ThemedAppBar(
            title: widget.title!,
            actions: [
              FutureBuilder<SavedFile>(
                future: _filePathFuture,
                builder: (_, s) => Utils.shareActionButton(
                  widget.title!,
                  s.data?.path != null ? [s.data!.path] : null,
                ),
              )
            ],
          ),
        Flexible(
          child: FutureBuilder<PdfController>(
            future: _pdfController,
            builder: (_, snapshot) => snapshot.hasError
                ? const Center(
                    child: Text(
                        'Unable to load document. Please try again later or contact support.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontStyle: FontStyle.italic)))
                : snapshot.data == null
                    ? const Center(child: CircularProgressIndicator())
                    : Stack(children: [
                        PdfView(
                          controller: snapshot.data!,
                          backgroundDecoration: BoxDecoration(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: PdfPageNumber(
                            controller: snapshot.data!,
                            // When `loadingState != PdfLoadingState.success`  `pagesCount` equals null_
                            builder: (_, state, loadingState, pagesCount) =>
                                Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: Text(
                                '${snapshot.data!.page}/${pagesCount ?? 0}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ]),
          ),
        ),
      ],
    );
  }
}
