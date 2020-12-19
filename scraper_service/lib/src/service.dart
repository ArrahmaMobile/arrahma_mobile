import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:arrahma_shared/shared.dart';
import 'package:arrahma_shared/shared.dart' as shared;
import 'package:scraper_service/scraper_runner.dart';
import 'package:simple_json_mapper/simple_json_mapper.dart';

class ScraperService {
  static const UPDATE_DURATION = Duration(hours: 4);
  static final _scraperRunner = ScraperRunner();
  static Future<ScraperService> init() async {
    shared.init();

    AppData metadata;
    if (_appDataFuture != null)
      metadata = await _appDataFuture;
    else {
      final completer = Completer<AppData>();
      _appDataFuture = completer.future;
      final scrapedData = await _scraperRunner.get();
      final lastUpdate = scrapedData?.runMetadata?.lastUpdate;
      if (lastUpdate != null &&
          DateTime.now().difference(lastUpdate) <= UPDATE_DURATION) {
        metadata = scrapedData.appData;
        Timer(const Duration(seconds: 10), () => _appDataFuture = null);
      } else {
        metadata = await update();
      }
      completer.complete(metadata);
      print('Initialized metadata...');
    }

    final service = ScraperService._internal(metadata);
    service.setupUpdateTimer();
    return service;
  }

  ScraperService._internal(AppData value) {
    _data = value;
  }

  AppData _rawData;
  void set _data(AppData value) {
    final serializedData = JsonMapper.serializeToMap(value);
    final jsonData = json.encode(serializedData);
    _serializedData = jsonData;
    _dataHash = md5.convert(utf8.encode(_serializedData)).toString();
    _rawData = value;
  }

  AppData get data => _rawData;

  String _serializedData;
  String get serializedData => _serializedData;

  String _dataHash;
  String get dataHash => _dataHash;

  Timer _updateTimer;
  static Future<AppData> _appDataFuture;

  void setupUpdateTimer() {
    _updateTimer = Timer.periodic(
        UPDATE_DURATION, (timer) async => _data = await update());
  }

  static Future<AppData> runScraper() async {
    print('Updating metadata...');
    final stopwatch = Stopwatch()..start();
    final data = await ScraperRunner().run(shouldStore: true);
    stopwatch.stop();
    print('Scraped data in ${stopwatch.elapsed}');
    return data.appData;
  }

  static Future<AppData> update({bool force = false}) async {
    if (!force && _appDataFuture != null) return await _appDataFuture;
    try {
      _appDataFuture = runScraper();
      return await _appDataFuture;
    } finally {
      Timer(const Duration(seconds: 10), () => _appDataFuture = null);
    }
  }

  void dispose() {
    _updateTimer?.cancel();
  }
}
