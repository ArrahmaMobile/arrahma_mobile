import 'dart:io';

import 'package:arrahma_shared/shared.dart';
import 'package:http/http.dart';
import 'package:scraper/scraper.dart';

class ScraperRunner {
  ScraperRunner();
  static const FILE_PATH = 'data/scraped_data.json';

  Future<ScrapedData> run({bool shouldStore = false}) async {
    final appMetadata = await Scraper(Client()).initiate();
    final scrapedData = ScrapedData(
        appData: appMetadata,
        runMetadata: RunMetadata(lastUpdate: DateTime.now()));
    if (shouldStore) store(FILE_PATH, scrapedData);
    return scrapedData;
  }

  Future<ScrapedData> get() async {
    return SerializationService.deserializeScrapedData(
        await getData(FILE_PATH));
  }

  Future<String> getData(String filePath) async {
    final file = File(filePath);
    final hasData = await file.exists();
    if (!hasData) return null;
    return await file.readAsString();
  }

  Future<void> store(String relativeFilePath, ScrapedData result) async {
    final serializedData = SerializationService.serializeScrapedData(result);
    await storeData(relativeFilePath, serializedData);
  }

  Future<void> storeData(String relativeFilePath, String data) async {
    final outputDir =
        relativeFilePath.substring(0, relativeFilePath.lastIndexOf('/') + 1);
    await Directory(outputDir).create(recursive: true);
    final dataFile = File(relativeFilePath);

    await dataFile.writeAsString(data, mode: FileMode.write);
  }

  Future<void> deleteFile(String filePath) async {
    return await File(filePath).delete().catchError((_) {});
  }
}
