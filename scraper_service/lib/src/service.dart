import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:arrahma_shared/shared.dart';
import 'package:arrahma_shared/shared.dart' as shared;
import 'package:scraper_service/scraper_runner.dart';
import 'package:simple_json_mapper/simple_json_mapper.dart';

class ScraperService {
  static const UPDATE_DURATION = Duration(hours: 4);

  ScraperService(this._syncService) {
    shared.init();
  }

  final SyncService _syncService;

  Future<void> init() async {
    if (_syncService.isMain) {
      final scrapedData = await ScraperRunner().get();
      final lastUpdate = scrapedData?.runMetadata?.lastUpdate;
      if (lastUpdate != null &&
          DateTime.now().difference(lastUpdate) <= UPDATE_DURATION) {
        _updateData(scrapedData.appData);
      } else {
        await runScraper();
      }
      setupUpdateTimer();
    } else {
      _syncService.valueStreamCtrl.stream.listen((data) async {
        if (data == 'reload') {
          final data = await ScraperRunner().get();
          _updateData(data.appData);
        }
      });
    }
  }

  AppData _rawData;
  AppData get data => _rawData;

  String _dataHash;
  String get dataHash => _dataHash;
  void set _hash(String data) {
    _dataHash = md5.convert(utf8.encode(data)).toString();
  }

  String _serializedData;
  String get serializedData => _serializedData;

  Timer _updateTimer;

  void setupUpdateTimer() {
    _updateTimer =
        Timer.periodic(UPDATE_DURATION, (timer) async => await runScraper());
  }

  Future<void> runScraper() async {
    _syncService.log('Running scraper...');
    final stopwatch = Stopwatch()..start();
    final data = await ScraperRunner().run(shouldStore: true);
    _updateData(data.appData);
    stopwatch.stop();
    _syncService.log('Scraped data in ${stopwatch.elapsed}');
  }

  void _updateData(AppData appData) {
    _rawData = appData;
    final serializedData = JsonMapper.serialize(_rawData);
    _serializedData = serializedData;
    _hash = serializedData;
    _syncService.valueStreamCtrl.add('reload');
  }

  void dispose() {
    _updateTimer?.cancel();
  }
}

enum ScrapeStatus {
  Idle,
  Start,
  Complete,
}
