import 'package:arrahma_web_api/controller/data_controller.dart';
import 'package:arrahma_web_api/controller/status_controller.dart';
import 'package:scraper_service/scraper_runner.dart';
import 'package:scraper_service/scraper_service.dart';
import 'package:uuid/uuid.dart';

import 'api.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
class ArrahmaChannel extends ApplicationChannel {
  static const idFilePath = 'data/mainId.txt';

  final runner = ScraperRunner();
  ScraperService _scraperService;
  String _id;
  String _mainId;

  /// Initialize services in this method.
  ///
  /// Implement this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.
  @override
  Future prepare() async {
    CORSPolicy.defaultPolicy.allowedOrigins = ['*'];

    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
    _id = Uuid().v4();

    _mainId = await runner.getData(idFilePath);
    if (_mainId == null) {
      _mainId = _id;
      await runner.storeData(idFilePath, _id);
    }
    ScraperService.isMain = _mainId == _id;
    ScraperService.sendMessage =
        (message) => messageHub.add({'origin': _id, ...message});
    ScraperService.id = _id;
    _scraperService = await ScraperService.init();
    messageHub.listen((event) {
      if (event is Map && event['origin'] != _id) {
        if (event['type'] == 'statusUpdate') {
          if (event['scrapeStatus'] == ScrapeStatus.Complete.index) {
            ScraperService.onDataUpdate(data: event);
          }
        }
      }
    });
  }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router(basePath: '/api');
    router.policy.allowedOrigins = ['http://localhost:8000'];
    router.route('/status').link(() => StatusController(_scraperService));
    router.route('/data').link(() => DataController(_scraperService));

    return router;
  }
}
