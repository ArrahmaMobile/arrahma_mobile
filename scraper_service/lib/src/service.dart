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
  static const UPDATE_DURATION = Duration(hours: 1);

  ScraperService(this._syncService,
      {this.errorEmailRecipient, this.senderEmail, this.senderEmailPassword}) {
    shared.init();
  }

  final SyncService _syncService;
  final String errorEmailRecipient;
  final String senderEmail;
  final String senderEmailPassword;

  Future<void> init() async {
    if (_syncService.isMain) {
      final scrapedData = await ScraperRunner().get();
      final lastUpdate = scrapedData?.runMetadata?.lastUpdate;
      if (lastUpdate != null &&
          DateTime.now().difference(lastUpdate) <= UPDATE_DURATION) {
        _updateData(scrapedData);
      } else {
        await runScraper();
      }
      setupUpdateTimer();
    } else {
      _syncService.valueStreamCtrl.stream.listen((data) async {
        if (data == 'reload') {
          final data = await ScraperRunner().get();
          _updateData(data);
        }
      });
    }
  }

  DateTime _lastUpdateAttempt;
  DateTime get lastUpdateAttempt => _lastUpdateAttempt;
  ScrapedData _rawData;
  ScrapedData get scrapedData => _rawData;
  AppData get appData => _rawData?.appData;

  String _appDataHash;
  String get appDataHash => _appDataHash;
  void _updateDataHash(String data) {
    _appDataHash = md5.convert(utf8.encode(data)).toString();
  }

  String _serializedData;
  String get serializedData => _serializedData;

  String _serializedV1Data;
  String get serializedV1Data => _serializedV1Data;

  Timer _updateTimer;

  void setupUpdateTimer() {
    _updateTimer =
        Timer.periodic(UPDATE_DURATION, (timer) async => await runScraper());
  }

  Future<void> runScraper() async {
    _syncService.log('Running scraper...');
    final stopwatch = Stopwatch()..start();
    bool success = true;
    _lastUpdateAttempt = DateTime.now();
    try {
      final data = await ScraperRunner().run(shouldStore: true);
      _updateData(data);
    } catch (err) {
      success = false;
      if (errorEmailRecipient != null)
        await _sendMail(
            err, errorEmailRecipient, senderEmail, senderEmailPassword);
    } finally {
      stopwatch.stop();
      _syncService.log(success
          ? 'Scraped data in ${stopwatch.elapsed}'
          : 'Failed to scrape data. Time elapsed: ${stopwatch.elapsed}');
    }
  }

  Future<void> _sendMail(dynamic error, String errorEmailRecipient,
      String senderEmail, String password) async {
    // ignore: deprecated_member_use
    final smtpServer = gmail(senderEmail, password);

    // Create our message.
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
    } on MailerException catch (e) {
      _syncService.log('Message not sent.');
      for (var p in e.problems) {
        _syncService.log('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  void _updateData(ScrapedData updatedScrapedData) {
    _rawData = updatedScrapedData;
    final serializedDataMap = JsonMapper.serializeToMap(appData);
    final serializedData = json.encode(serializedDataMap);
    _serializedData = serializedData;
    final quranCousesV1 = appData.courses
        .map(
          (c) => QuranCourseV1(
            title: c.title,
            imageUrl: c.imageUrl,
            courseDetails: (c.courseDetails?.items?.isNotEmpty ?? false)
                ? QuranCourseDetails(
                    type: c.courseDetails.items.first.item.type == ItemType.Pdf
                        ? QuranCourseDetailsType.Pdf
                        : QuranCourseDetailsType.Markdown,
                    details: c.courseDetails.items.first.item.data,
                  )
                : null,
            registration: (c.registration?.items?.isNotEmpty ?? false)
                ? QuranCourseRegistration(
                    type: RegistrationType.WebForm,
                    url: c.registration.items.first.item.data,
                  )
                : null,
            tafseer: c.tafseer,
            tajweed: c.tajweed,
            tests: c.tests,
            otherContent: c.otherContent,
          ),
        )
        .toList();
    _serializedV1Data = json.encode(
        {...serializedDataMap, 'courses': JsonMapper.serialize(quranCousesV1)});
    _updateDataHash(serializedData);
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
