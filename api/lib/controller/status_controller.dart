import 'dart:async';

import 'package:arrahma_shared/shared.dart';
import 'package:arrahma_web_api/services/broadcast_service.dart';
import 'package:arrahma_web_api/services/data_sync_service.dart';
import 'package:conduit_core/conduit_core.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:scraper_service/scraper_service.dart';

class StatusController extends ResourceController {
  StatusController(this._scraperService, this._broadcastService);

  final ScraperService _scraperService;
  final BroadcastService _broadcastService;

  @Operation.get()
  Future<Response> getStatus({@Bind.query('dataHash') String? dataHash}) async {
    final statusResponse = JsonMapper.serialize(
      ServerStatus(
        status: ServerConnectionStatus.Available,
        isDataStale:
            dataHash != null && _scraperService.appDataHash != dataHash,
        broadcastStatus: _broadcastService.broadcastStatus,
        lastScrapeAttemptOn: _scraperService.lastUpdateAttempt,
        lastScrapedOn: _scraperService.scrapedData.runMetadata.lastUpdate,
        lastDataHash: _scraperService.appDataHash,
      ),
    );
    print(
        '[${DataSyncService.instanceId}] ${statusResponse.length > 1000 ? statusResponse.substring(0, 1000) : statusResponse}');
    return Response.ok(statusResponse);
  }
}
