import 'package:simple_json_mapper/simple_json_mapper.dart';

import '../models.dart';

@JObj()
class ScrapedData {
  const ScrapedData({this.appMetadata, this.runMetadata});
  final AppMetadata appMetadata;
  final RunMetadata runMetadata;
}
