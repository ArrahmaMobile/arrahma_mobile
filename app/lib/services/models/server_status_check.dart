import 'package:simple_json_mapper/simple_json_mapper.dart';

import 'connection.dart';

@JObj()
class ServerStatusCheck {
  const ServerStatusCheck({this.status});
  final ServerConnectionStatus status;
}
