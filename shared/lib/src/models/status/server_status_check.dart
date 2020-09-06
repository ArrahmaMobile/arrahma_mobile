import 'package:simple_json_mapper/simple_json_mapper.dart';

@JObj()
class ServerStatus {
  const ServerStatus({this.status});
  final ServerConnectionStatus status;
}

enum ServerConnectionStatus {
  Available,
  Maintenance,
  Unavailable,
}
