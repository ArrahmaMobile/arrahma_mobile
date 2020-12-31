import 'dart:async';

import 'package:arrahma_shared/shared.dart';
import 'package:scraper_service/src/service.dart';
import 'package:arrahma_shared/shared.dart' as shared;

Future main(List<String> arguments) async {
  shared.init();
  await ScraperService(new NoOpSyncService()).runScraper();
}

class NoOpSyncService implements SyncService {
  final _ctrl = StreamController<String>.broadcast();

  @override
  String get id => '1';

  @override
  bool get isMain => true;

  @override
  String get taskName => '';

  @override
  StreamController<String> get valueStreamCtrl => _ctrl;

  void log(String message) {
    print('[$id] $message');
  }
}
