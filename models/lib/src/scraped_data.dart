import 'package:simple_json_mapper/simple_json_mapper.dart';

import '../models.dart';

@JObj()
class ScrapedData {
  const ScrapedData({this.appData, this.runMetadata});
  final AppData appData;
  final RunMetadata runMetadata;
}
