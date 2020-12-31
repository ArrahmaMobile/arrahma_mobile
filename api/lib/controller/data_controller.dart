import 'dart:async';

import 'package:aqueduct/aqueduct.dart';
import 'package:arrahma_web_api/api.dart';
import 'package:arrahma_web_api/services/data_sync_service.dart';
import 'package:scraper_service/scraper_service.dart';

class DataController extends ResourceController {
  DataController(this._scraperService);

  final ScraperService _scraperService;

  @Operation.get()
  Future<Response> getData(
      {@Bind.query('If-None-Match') String dataHash}) async {
    final eTagHeader = {'ETag': _scraperService.dataHash};
    if (dataHash != null && dataHash == _scraperService.dataHash) {
      return Response(HttpStatus.notModified, eTagHeader, null);
    }
    final data = _scraperService.serializedData;
    print(
        '[${DataSyncService.instanceId}] ${data.length > 1000 ? data.substring(0, 1000) : data}');
    return Response.ok(data, headers: eTagHeader);
  }
}
