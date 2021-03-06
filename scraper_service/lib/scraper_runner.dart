import 'package:arrahma_shared/shared.dart';
import 'package:http/http.dart';
import 'package:scraper/scraper.dart';

class ScraperRunner {
  ScraperRunner();

  final _fileService = FileService();
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
        await _fileService.read(FILE_PATH));
  }

  Future<void> store(String relativeFilePath, ScrapedData result) async {
    final serializedData = SerializationService.serializeScrapedData(result);
    await _fileService.write(relativeFilePath, serializedData);
  }
}
