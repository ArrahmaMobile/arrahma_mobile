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
  String? _cachedPassword;
  Uint8List? _pdfData;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant SimplePdfViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _cachedPassword = null;
      _pdfData = null;
      _init();
    }
  }

  void _init() {
    _pdfController = _loadPdf();
  }

  Future<PdfController> _loadPdf({String? password}) async {
    final cacheManager = DefaultCacheManager();
    final file = await cacheManager.getFileFromCache(widget.url);

    try {
      if (file != null && await file.file.exists()) {
        // Use the cached file if it exists
        final document = await PdfDocument.openFile(
          file.file.path,
          password: password ?? _cachedPassword,
        );

        // If successful with a password, cache it
        if (password != null) {
          _cachedPassword = password;
        }

        return PdfController(document: document);
      } else {
        // Download the PDF data if not already cached
        if (_pdfData == null) {
          final result = await _apiService.downloadFile(widget.url);
          _pdfData = result.value!;
          _saveToFile(Future.value(result));
        }

        final document = await PdfDocument.openData(
          _pdfData!,
          password: password ?? _cachedPassword,
        );

        // If successful with a password, cache it
        if (password != null) {
          _cachedPassword = password;
        }

        return PdfController(
          document: document,
          viewportFraction: 1,
        );
      }
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
            const Text('This PDF is password-protected. Please enter the password to view it.'),
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
              : PdfView(
                  controller: snapshot.data!,
                ),
    );
  }
}
