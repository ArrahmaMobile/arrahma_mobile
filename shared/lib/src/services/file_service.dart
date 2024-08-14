import 'dart:io';

class FileService {
  const FileService();

  Future<String?> read(String filePath) async {
    final file = File(filePath);
    final hasData = await file.exists();
    if (!hasData) return null;
    return await file.readAsString();
  }

  Future<void> write(String relativeFilePath, String data) async {
    final outputDir =
        relativeFilePath.substring(0, relativeFilePath.lastIndexOf('/') + 1);
    await Directory(outputDir).create(recursive: true);
    final dataFile = File(relativeFilePath);

    await dataFile.writeAsString(data, mode: FileMode.write);
  }

  Future<void> delete(String filePath) async {
    await File(filePath).delete().catchError((_) {
      return _;
    });
  }
}
