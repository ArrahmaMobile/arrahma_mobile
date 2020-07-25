import 'dart:async';

import 'package:arrahma_models/models.dart';
import 'package:scraper_service/scraper_runner.dart';

class ScraperService {
  static const UpdateDuration = Duration(hours: 4);
  static final _scraperRunner = ScraperRunner();
  static Future<ScraperService> init() async {
    final scrapedData = await _scraperRunner.get();
    AppMetadata metadata;
    final lastUpdate = scrapedData?.runMetadata?.lastUpdate;
    if (lastUpdate != null &&
        DateTime.now().difference(lastUpdate) <= UpdateDuration) {
      metadata = scrapedData.appMetadata;
    } else {
      metadata = await update();
    }
    final service = ScraperService._internal(metadata);
    service.setupUpdateTimer();
    return service;
  }

  ScraperService._internal(this._metadata);
  AppMetadata _metadata;
  AppMetadata get metadata => _metadata;

  Timer _updateTimer;

  void setupUpdateTimer() {
    _updateTimer = Timer.periodic(
        UpdateDuration, (timer) async => _metadata = await update());
  }

  static Future<AppMetadata> update() async {
    return (await ScraperRunner().run(shouldStore: true)).appMetadata;
  }

  void dispose() {
    _updateTimer?.cancel();
  }
}
