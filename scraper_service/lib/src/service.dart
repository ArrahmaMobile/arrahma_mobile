import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:arrahma_shared/shared.dart';
import 'package:arrahma_shared/shared.dart' as shared;
import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:scraper_service/scraper_runner.dart';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class ScraperService {
  static const Duration updateDuration = Duration(hours: 1);

  final SyncService _syncService;
  final String? errorEmailRecipient;
  final String? senderEmail;
  final String? senderEmailPassword;

  late Timer _updateTimer;
  late DateTime _lastUpdateAttempt;
  late ScrapedData _rawData;
  late String _appDataHash;
  late Map<String, dynamic> _serializedData;

  ScraperService._(
    this._syncService, {
    this.errorEmailRecipient,
    this.senderEmail,
    this.senderEmailPassword,
  }) {
    shared.initializeJsonMapper();
  }

  DateTime get lastUpdateAttempt => _lastUpdateAttempt;
  ScrapedData get scrapedData => _rawData;
  AppData get appData => _rawData.appData;
  String get appDataHash => _appDataHash;
  Map<String, dynamic> get serializedData => _serializedData;

  static Future<ScraperService> create({
    required SyncService syncService,
    String? errorEmailRecipient,
    String? senderEmail,
    String? senderEmailPassword,
  }) async {
    final service = ScraperService._(
      syncService,
      errorEmailRecipient: errorEmailRecipient,
      senderEmail: senderEmail,
      senderEmailPassword: senderEmailPassword,
    );

    if (syncService.isMain) {
      ScrapedData? scrapedData;
      try {
        syncService.log('Fetching cached data...');
        scrapedData = await ScraperRunner().get();
        if (scrapedData?.runMetadata.lastUpdate != null)
          service._lastUpdateAttempt = scrapedData!.runMetadata.lastUpdate;
      } catch (err, s) {
        await service._sendMail('Failed to fetch cached data', err, s);
        syncService.log(s.toString());
      }
      final lastUpdate = scrapedData?.runMetadata.lastUpdate;
      final hasData = scrapedData != null;
      final isNotStale = lastUpdate != null &&
          DateTime.now().difference(lastUpdate).compareTo(updateDuration) < 0;
      if (hasData && isNotStale) {
        syncService.log('Using cached data.');
        service._updateData(scrapedData);
      } else {
        syncService.log(
            'Cached data is ${!hasData ? 'not found' : 'stale'}. Running scraper...');
        await service.runScraper();
      }
      service._setupUpdateTimer();
    } else {
      syncService.valueStreamCtrl.stream.listen((data) async {
        if (data == 'reload') {
          final scrapedData = await ScraperRunner().get();
          service._updateData(scrapedData!);
        }
      });
    }

    return service;
  }

  void _setupUpdateTimer() {
    _updateTimer =
        Timer.periodic(updateDuration, (timer) async => await runScraper());
  }

  Future<void> runScraper() async {
    _syncService.log('Running scraper...');
    final stopwatch = Stopwatch()..start();
    bool success = true;
    _lastUpdateAttempt = DateTime.now();
    try {
      final data = await ScraperRunner().run(shouldStore: true);
      _updateData(data);
    } catch (err, s) {
      success = false;
      await _sendMail('Failed to scraped data.', err, s);
      _syncService.log(s.toString());
    } finally {
      stopwatch.stop();
      _syncService.log(success
          ? 'Scraped data in ${stopwatch.elapsed}'
          : 'Failed to scrape data. Time elapsed: ${stopwatch.elapsed}');
    }
  }

  Future<bool> _sendMail(
      String message, dynamic error, StackTrace stack) async {
    if (errorEmailRecipient != null &&
        senderEmail != null &&
        senderEmailPassword != null) {
      return await _sendMailRaw('''
          <h1>Arrahmah App Scraper Failed.</h1>
          <p>${DateTime.now()}</p>
          <p>$message</p>
          <p>Refer to the stack trace of the failure:</p>
          <pre>${error.toString()}</pre>
          <pre>$stack</pre>
''', errorEmailRecipient!, senderEmail!, senderEmailPassword!);
    }
    return false;
  }

  Future<bool> _sendMailRaw(dynamic error, String errorEmailRecipient,
      String senderEmail, String password) async {
    final smtpServer = gmail(senderEmail, password);

    final message = Message()
      ..from = Address(senderEmail, 'Arrahmah App')
      ..subject = 'Arrahmah App Scraper - Failed'
      ..recipients.add(errorEmailRecipient)
      ..html = """
          <h1>Arrahmah App Scraper Failed.</h1>
          <p>Refer to the stack trace of the failure:</p>
          <pre>${error is Error ? error.stackTrace : error.toString()}</pre>
          """;

    try {
      final sendReport =
          await send(message, smtpServer, timeout: Duration(seconds: 15));
      _syncService.log('Message sent: ' + sendReport.toString());
      return true;
    } on MailerException catch (e) {
      _syncService.log('Message not sent.');
      for (var p in e.problems) {
        _syncService.log('Problem: ${p.code}: ${p.msg}');
      }
    }
    return false;
  }

  void _updateData(ScrapedData updatedScrapedData) {
    _rawData = updatedScrapedData;
    final serializedDataMap = JsonMapper.toMap(appData)!;
    _serializedData = serializedDataMap;
    _updateDataHash(json.encode(_serializedData));
    _syncService.log('Data updated.');
    if (!_syncService.isMain)
      _lastUpdateAttempt = updatedScrapedData.runMetadata.lastUpdate;
    if (_syncService.isMain) _syncService.valueStreamCtrl.add('reload');
  }

  void _updateDataHash(String data) {
    _appDataHash = md5.convert(utf8.encode(data)).toString();
  }

  void dispose() {
    _updateTimer.cancel();
  }
}

enum ScrapeStatus {
  Idle,
  Start,
  Complete,
}
