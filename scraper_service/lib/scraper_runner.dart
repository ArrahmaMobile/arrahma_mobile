import 'dart:io';

import 'package:arrahma_models/models.dart';
import 'package:http/http.dart';
import 'package:arrahma_models/src/run_metadata.dart';
import 'package:arrahma_models/src/scraped_data.dart';
import 'package:scraper/scraper.dart';

class ScraperRunner {
  ScraperRunner();
  static const FILE_PATH = 'data/scraped_data.json';

  Future<ScrapedData> run({bool shouldStore = false}) async {
    final appMetadata = await Scraper(Client()).initiate();
    final scrapedData = ScrapedData(
        appMetadata: appMetadata,
        runMetadata: RunMetadata(lastUpdate: DateTime.now()));
    if (shouldStore) store(FILE_PATH, scrapedData);
    return scrapedData;
  }

  Future<ScrapedData> get() async {
    final file = File(FILE_PATH);
    final hasData = await file.exists();
    if (!hasData) return null;
    return ModelService.deserializeScrapedData(await file.readAsString());
  }

  void store(String relativeFilePath, ScrapedData result) async {
    final outputDir =
        relativeFilePath.substring(0, relativeFilePath.lastIndexOf('/') + 1);
    await Directory(outputDir).create(recursive: true);
    final dataFile = File(relativeFilePath);

    await dataFile.writeAsString(ModelService.serializeScrapedData(result),
        mode: FileMode.write);
  }
}
