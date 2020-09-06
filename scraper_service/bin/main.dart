import 'package:scraper_service/src/service.dart';
import 'package:arrahma_shared/shared.dart' as shared;

Future main(List<String> arguments) async {
  shared.init();
  await ScraperService.update();
}
