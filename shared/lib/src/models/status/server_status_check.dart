import 'package:simple_json_mapper/simple_json_mapper.dart';

@JObj()
class ServerStatus {
  const ServerStatus({
    this.status,
    this.isDataStale,
    this.isLive,
  });
  final ServerConnectionStatus status;
  final bool isDataStale;
  final bool isLive;
}

enum ServerConnectionStatus {
  Available,
  Maintenance,
  Unavailable,
}
