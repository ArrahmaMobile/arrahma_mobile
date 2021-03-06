import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:arrahma_shared/shared.dart';
import 'package:arrahma_shared/shared.dart' as shared;
import 'package:scraper_service/scraper_runner.dart';
import 'package:simple_json_mapper/simple_json_mapper.dart';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class ScraperService {
  static const UPDATE_DURATION = Duration(hours: 4);

  ScraperService(this._syncService,
      {this.errorEmailRecipient,
      this.senderEmailUsername,
      this.senderEmailPassword}) {
    shared.init();
  }

  final SyncService _syncService;
  final String errorEmailRecipient;
  final String senderEmailUsername;
  final String senderEmailPassword;

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
    bool success = true;
    try {
      final data = await ScraperRunner().run(shouldStore: true);
      _updateData(data.appData);
    } catch (err) {
      success = false;
      if (errorEmailRecipient != null)
        await _sendMail(
            err, errorEmailRecipient, senderEmailUsername, senderEmailPassword);
    } finally {
      stopwatch.stop();
      _syncService.log(success
          ? 'Scraped data in ${stopwatch.elapsed}'
          : 'Failed to scrape data. Time elapsed: ${stopwatch.elapsed}');
    }
  }

  Future<void> _sendMail(dynamic error, String errorEmailRecipient,
      String username, String password) async {
    // ignore: deprecated_member_use
    final smtpServer = gmail(username, password);

    // Create our message.
    final message = Message()
      ..from = Address('tehtech1337@gmail.com', 'Arrahmah App')
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
    } on MailerException catch (e) {
      _syncService.log('Message not sent.');
      for (var p in e.problems) {
        _syncService.log('Problem: ${p.code}: ${p.msg}');
      }
    }
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
