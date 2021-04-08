import 'dart:io';
import 'package:flutter_framework/flutter_framework.dart' as f;

class FileUtils {
  static Future<File> copyFileToTempPath(
      File file, String tempFileName, String fileExtension) async {
    final tempPath = await f.FileUtils.getFilePath();
    final normalizedFileName =
        tempFileName.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '');
    return await file.copy(
        '$tempPath${tempPath.endsWith('/') ? '' : '/'}$normalizedFileName.$fileExtension');
  }
}
