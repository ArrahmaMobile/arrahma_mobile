import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:arrahma_shared/shared.dart';
import 'package:arrahma_shared/shared.dart' as shared;
import 'package:scraper_service/scraper_runner.dart';
import 'package:simple_json_mapper/simple_json_mapper.dart';

class ScraperService {
  static const UPDATE_DURATION = Duration(hours: 4);
  static void Function(Map<String, dynamic>) sendMessage;
  static String id;

  static Future<ScraperService> init() async {
    shared.init();

    AppData metadata;
    if (isMain) {
      final scrapedData = await ScraperRunner().get();
      final lastUpdate = scrapedData?.runMetadata?.lastUpdate;
      if (lastUpdate != null &&
          DateTime.now().difference(lastUpdate) <= UPDATE_DURATION) {
        metadata = scrapedData.appData;
      } else {
        metadata = await runScraper(true);
      }
    } else {
      onDataUpdate();
      metadata = await _appDataStreamCtrl.stream.first;
    }

    log('Initialized metadata...');

    final service = ScraperService._internal(metadata);
    if (isMain) service.setupUpdateTimer();
    return service;
  }

  ScraperService._internal(AppData value) {
    _data = value;
    if (!isMain) _appDataStreamCtrl?.stream?.listen((data) => _data = data);
  }

  static Future<void> onDataUpdate({Map<String, dynamic> data}) async {
    final scrapedData = await ScraperRunner().get();
    _appDataStreamCtrl.add(scrapedData.appData);
    if (data != null)
      log('Recieved data from main service (${data['origin']})');
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

  static final _appDataStreamCtrl = StreamController<AppData>.broadcast();
  static bool isMain = true;

  void setupUpdateTimer() {
    _updateTimer = Timer.periodic(
        UPDATE_DURATION, (timer) async => _data = await runScraper(false));
  }

  static Future<AppData> runScraper(bool initial) async {
    log('Updating metadata...');
    final stopwatch = Stopwatch()..start();
    final data = await ScraperRunner().run(shouldStore: true);
    stopwatch.stop();
    log('Scraped data in ${stopwatch.elapsed}');
    if (!initial)
      sendMessage({
        'type': 'statusUpdate',
        'scrapeStatus': ScrapeStatus.Complete.index
      });
    return data?.appData;
  }

  void dispose() {
    _updateTimer?.cancel();
  }

  static void log(String message) {
    print('[$id] $message');
  }
}

enum ScrapeStatus {
  Idle,
  Start,
  Complete,
}
