import 'package:arrahma_web_api/controller/data_controller.dart';
import 'package:scraper_service/scraper_service.dart';
import 'package:simple_json_mapper/simple_json_mapper.dart';
import 'package:arrahma_shared/src/models/status/server_status_check.dart';

import 'api.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
class ArrahmaChannel extends ApplicationChannel {
  ScraperService _scraperService;

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
    _scraperService = await ScraperService.init();
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
    router.route('/status').linkFunction((request) => Response.ok(
        JsonMapper.serializeToMap(
            ServerStatus(status: ServerConnectionStatus.Available))));
    router.route('/data').link(() => DataController(_scraperService));

    return router;
  }
}
