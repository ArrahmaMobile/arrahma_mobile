import 'package:simple_json_mapper/simple_json_mapper.dart';

import '../app_metadata.dart';
import '../run_metadata.dart';

@JObj()
class ScrapedData {
  const ScrapedData({this.appData, this.runMetadata});
  final AppData appData;
  final RunMetadata runMetadata;
}
