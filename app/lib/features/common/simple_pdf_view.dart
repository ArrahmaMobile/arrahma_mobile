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
  Uint8List? _pdfData;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant SimplePdfView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _pdfData = null;
      _init();
    }
  }

  void _init() {
    _pdfController = _loadPdf();
  }

  Future<PdfController> _loadPdf({String? password}) async {
    // Download the PDF data if not already cached
    if (_pdfData == null) {
      final result = await _apiService.downloadFile(widget.url);
      _pdfData = result.value!;
      _filePathFuture = _saveToFile(Future.value(result));
    }

    try {
      final documentFuture = PdfDocument.openData(
        _pdfData!,
        password: password,
      );

      return PdfController(
        document: documentFuture,
        viewportFraction: 1,
      );
    } catch (e) {
      // Check if this is a password-related error
      if (_isPasswordError(e)) {
        if (!mounted) rethrow;

        // Show password dialog
        final enteredPassword = await _showPasswordDialog();

        if (enteredPassword != null && enteredPassword.isNotEmpty) {
          // Retry with the entered password
          return _loadPdf(password: enteredPassword);
        } else {
          // User cancelled or entered empty password
          throw Exception('Password required to open this PDF');
        }
      }
      rethrow;
    }
  }

  bool _isPasswordError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    return errorString.contains('password') ||
        errorString.contains('encrypted') ||
        errorString.contains('invalid format');
  }

  Future<String?> _showPasswordDialog() async {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Password Required'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'This PDF is password-protected. Please enter the password to view it.'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              obscureText: true,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) => Navigator.of(context).pop(value),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('Open'),
          ),
        ],
      ),
    );
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
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        snapshot.error.toString().contains('Password required')
                            ? 'Password required to open this PDF.\nPlease try again.'
                            : 'Unable to load document. Please try again later or contact support.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  )
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
                                color: Colors.black.withValues(alpha: 0.5),
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
