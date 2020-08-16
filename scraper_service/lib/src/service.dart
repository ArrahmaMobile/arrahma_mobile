import 'dart:async';

import 'package:arrahma_models/models.dart';
import 'package:arrahma_models/models.dart' as models;
import 'package:scraper_service/scraper_runner.dart';

class ScraperService {
  static const UPDATE_DURATION = Duration(hours: 4);
  static final _scraperRunner = ScraperRunner();
  static Future<ScraperService> init() async {
    models.init();
    final scrapedData = await _scraperRunner.get();
    AppData metadata;
    final lastUpdate = scrapedData?.runMetadata?.lastUpdate;
    if (lastUpdate != null &&
        DateTime.now().difference(lastUpdate) <= UPDATE_DURATION) {
      metadata = scrapedData.appData;
    } else {
      metadata = await update();
    }
    final service = ScraperService._internal(metadata);
    service.setupUpdateTimer();
    print('Initialized metadata...');
    return service;
  }

  ScraperService._internal(this._data);
  AppData _data;
  AppData get data => _data;

  Timer _updateTimer;

  void setupUpdateTimer() {
    _updateTimer = Timer.periodic(
        UPDATE_DURATION, (timer) async => _data = await update());
  }

  static Future<AppData> update() async {
    print('Updating metadata...');
    return (await ScraperRunner().run(shouldStore: true)).appData;
  }

  void dispose() {
    _updateTimer?.cancel();
  }
}
