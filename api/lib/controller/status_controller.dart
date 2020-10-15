import 'dart:async';

import 'package:aqueduct/aqueduct.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:scraper_service/scraper_service.dart';
import 'package:simple_json_mapper/simple_json_mapper.dart';

class StatusController extends ResourceController {
  StatusController(this._scraperService);

  final ScraperService _scraperService;

  @Operation.get()
  Future<Response> getStatus({@Bind.query('dataHash') String dataHash}) async {
    final statusResponse = JsonMapper.serialize(
      ServerStatus(
          status: ServerConnectionStatus.Available,
          isDataStale:
              dataHash != null && _scraperService.dataHash != dataHash),
    );
    print(statusResponse.length > 1000
        ? statusResponse.substring(0, 1000)
        : statusResponse);
    return Response.ok(statusResponse);
  }
}
