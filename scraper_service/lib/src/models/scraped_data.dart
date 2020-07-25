import 'package:arrahma_models/models.dart';
import 'package:scraper_service/src/models/run_metadata.dart';
import 'package:simple_json_mapper/simple_json_mapper.dart';

@JObj()
class ScrapedData {
  const ScrapedData({this.appMetadata, this.runMetadata});
  final AppMetadata appMetadata;
  final RunMetadata runMetadata;
}
