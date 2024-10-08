import 'package:arrahma_web_api/controller/data_controller.dart';
import 'package:arrahma_web_api/controller/status_controller.dart';
import 'package:arrahma_web_api/services/data_sync_service.dart';
import 'package:conduit_core/conduit_core.dart';
import 'package:scraper_service/scraper_service.dart';

import 'api.dart';
import 'arrahmah_config.dart';
import 'services/broadcast_service.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
class ArrahmaChannel extends ApplicationChannel {
  late BroadcastService _broadcastService;
  late ScraperService _scraperService;

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

    final config = ArrahmahConfiguration(
        options?.configurationFilePath ?? './config.yaml');
    DataSyncService.messageHub = messageHub;

    try {
      _broadcastService = await BroadcastService.init(config);
      _scraperService = await ScraperService.create(
        syncService: await DataSyncService.init('$ScraperService'),
        errorEmailRecipient: config.errorEmailRecipient,
        senderEmail: config.senderEmail,
        senderEmailPassword: config.senderEmailPassword,
      );
    } catch (e) {
      print(e);
    }
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
    router.policy?.allowedOrigins = ['http://localhost:8000'];
    router
        .route('/status')
        .link(() => StatusController(_scraperService, _broadcastService));
    router
        .route('/data/[:version]')
        .link(() => DataController(_scraperService));

    return router;
  }
}
