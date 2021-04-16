import 'dart:async';

import 'package:aqueduct/aqueduct.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:arrahma_web_api/services/broadcast_service.dart';
import 'package:arrahma_web_api/services/data_sync_service.dart';
import 'package:scraper_service/scraper_service.dart';
import 'package:simple_json_mapper/simple_json_mapper.dart';

class StatusController extends ResourceController {
  StatusController(this._scraperService, this._broadcastService);

  final ScraperService _scraperService;
  final BroadcastService _broadcastService;

  @Operation.get()
  Future<Response> getStatus({@Bind.query('dataHash') String dataHash}) async {
    final statusResponse = JsonMapper.serialize(
      ServerStatus(
        status: ServerConnectionStatus.Available,
        isDataStale: dataHash != null && _scraperService.appDataHash != dataHash,
        broadcastStatus: _broadcastService.broadcastStatus,
        lastScrapeAttemptOn: _scraperService.lastUpdateAttempt,
        lastScrapedOn: _scraperService.scrapedData.runMetadata.lastUpdate,
      ),
    );
    print(
        '[${DataSyncService.instanceId}] ${statusResponse.length > 1000 ? statusResponse.substring(0, 1000) : statusResponse}');
    return Response.ok(statusResponse);
  }
}
