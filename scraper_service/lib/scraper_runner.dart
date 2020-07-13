import 'dart:io';

import 'package:http/http.dart';
import 'package:scraper_service/mapper.g.dart' as mapper;
import 'package:scraper_service/src/models/run_metadata.dart';
import 'package:scraper_service/src/models/scraped_data.dart';
import 'package:simple_json_mapper/simple_json_mapper.dart';
import 'package:scraper/scraper.dart';

class ScraperRunner {
  ScraperRunner() {
    mapper.init();
  }
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
    return JsonMapper.deserialize<ScrapedData>(await file.readAsString());
  }

  void store<T>(String relativeFilePath, T result) async {
    final outputDir =
        relativeFilePath.substring(0, relativeFilePath.lastIndexOf('/') + 1);
    await Directory(outputDir).create(recursive: true);
    final dataFile = File(relativeFilePath);

    await dataFile.writeAsString(JsonMapper.serialize(result),
        mode: FileMode.write);
  }
}
