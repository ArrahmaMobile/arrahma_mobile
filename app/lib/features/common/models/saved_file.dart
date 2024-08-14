import 'package:flutter/material.dart';

class SavedFile {
  const SavedFile({required this.path, this.mimeType});
  final String path;
  final String? mimeType;
}
