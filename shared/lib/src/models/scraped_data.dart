import 'package:dart_json_mapper/dart_json_mapper.dart';

import '../app_metadata.dart';
import '../run_metadata.dart';

@jsonSerializable
class ScrapedData {
  const ScrapedData({required this.appData, required this.runMetadata});
  final AppData appData;
  final RunMetadata runMetadata;
}
