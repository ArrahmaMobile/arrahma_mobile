import 'package:arrahma_models/models.dart';

import 'environment_config.dart';

enum SessionStatus { Connected, Expiring, Expired }
enum DeviceConnectionSource { WiFi, Cellular, None }

class Connection {
  const Connection({
    this.deviceConnectionSource,
    this.deviceConnectionInfo,
    this.serverConnectionInfo,
    // this.sessionConnectionInfo,
  });
  final DeviceConnectionSource deviceConnectionSource;
  final ConnectionInfo<bool, void> deviceConnectionInfo;
  final ConnectionInfo<ServerStatus, EnvironmentConfig> serverConnectionInfo;
  // final ConnectionInfo<SessionStatus, UserSession> sessionConnectionInfo;

  Connection copyWith({
    DeviceConnectionSource deviceConnectionSource,
    ConnectionInfo<bool, void> deviceConnectionInfo,
    ConnectionInfo<ServerStatus, EnvironmentConfig> serverConnectionInfo,
    // ConnectionInfo<SessionStatus, UserSession> sessionConnectionInfo,
  }) {
    return Connection(
      deviceConnectionSource:
          deviceConnectionSource ?? this.deviceConnectionSource,
      deviceConnectionInfo: deviceConnectionInfo ?? this.deviceConnectionInfo,
      serverConnectionInfo: serverConnectionInfo ?? this.serverConnectionInfo,
      // sessionConnectionInfo:
      //     sessionConnectionInfo ?? this.sessionConnectionInfo,
    );
  }

  bool get isDeviceConnected =>
      deviceConnectionSource != DeviceConnectionSource.None;

  bool get isConnected =>
      isDeviceConnected &&
      // (deviceConnectionInfo?.status ?? true) &&
      serverConnectionInfo?.status?.status == ServerConnectionStatus.Available;
  // sessionConnectionInfo?.status != SessionStatus.Expired;

  @override
  String toString() {
    return '${deviceConnectionSource ?? 'DeviceConnectionSource.Unknown'}; ${serverConnectionInfo?.status?.status != null ? serverConnectionInfo.status.status : 'ServerConnectionStatus.Unknown'};';
  }
}

class ConnectionInfo<TStatus, TItem> {
  const ConnectionInfo(this.item, this.status, this.lastAttempt);
  final TStatus status;
  final TItem item;
  final DateTime lastAttempt;
}
