import 'package:simple_json_mapper/simple_json_mapper.dart';

@JObj()
class RunMetadata {
  const RunMetadata({this.lastUpdate});
  final DateTime lastUpdate;
}
