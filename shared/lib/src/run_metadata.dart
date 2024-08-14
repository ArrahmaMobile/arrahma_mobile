import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class RunMetadata {
  const RunMetadata({required this.lastUpdate, this.updateFrequency});
  final Duration? updateFrequency;
  final DateTime lastUpdate;
}
