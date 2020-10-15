import 'package:simple_json_mapper/simple_json_mapper.dart';

@JObj()
class ServerStatus {
  const ServerStatus({
    this.status,
    this.isDataStale,
  });
  final ServerConnectionStatus status;
  final bool isDataStale;
}

enum ServerConnectionStatus {
  Available,
  Maintenance,
  Unavailable,
}
