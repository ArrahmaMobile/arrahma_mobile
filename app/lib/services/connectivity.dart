import 'dart:async';

import 'package:arrahma_mobile_app/services/models/api_response.dart';
import 'package:arrahma_models/src/status/server_status_check.dart';
import 'package:arrahma_mobile_app/utils/app_utils.dart';
import 'package:arrahma_mobile_app/utils/enum_utils.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:inherited_state/inherited_state.dart';

import 'api.dart';
import 'logger.dart';
import 'models/connection.dart';
import 'models/environment_config.dart';
import 'stoppable_service.dart';

const ConectivityResultMap = <ConnectivityResult, DeviceConnectionSource>{
  ConnectivityResult.none: DeviceConnectionSource.None,
  ConnectivityResult.wifi: DeviceConnectionSource.WiFi,
  ConnectivityResult.mobile: DeviceConnectionSource.Cellular,
};

class ConnectivityService with StoppableService {
  ConnectivityService() {
    init();
  }

  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  Timer _connectivityTimer;

  var _prevDeviceResult = DeviceConnectionSource.None;
  var _curDeviceResult = DeviceConnectionSource.None;

  ServerStatus _prevServerResult;
  ServerStatus _curServerResult;

  var _prevResult = const Connection();
  var _curResult = const Connection();

  StreamController<DeviceConnectionSource> _deviceConnectivityStreamController;
  Stream<DeviceConnectionSource> get deviceConnectivityStream =>
      _deviceConnectivityStreamController.stream;

  StreamController<ServerStatus> _serverConnectivityStreamController;
  Stream<ServerStatus> get servereConnectivityStream =>
      _serverConnectivityStreamController.stream;

  StreamController<Connection> _connectionStreamController;
  Stream<Connection> get connectionStream => _connectionStreamController.stream;

  Connection get previousResult => _prevResult;
  Connection get latestResult => _curResult;

  DeviceConnectionSource get previousDeviceResult => _prevDeviceResult;
  DeviceConnectionSource get latestDeviceResult => _curDeviceResult;

  ServerStatus get previousServerResult => _prevServerResult;
  ServerStatus get latestServerResult => _curServerResult;

  bool get isConnected => _curResult?.isConnected;

  Future<Connection> initConnectionStatus(
      EnvironmentConfig envConfig, ApiService apiService) async {
    ServerStatus serverStatus = latestServerResult;
    if (serverStatus == null) {
      ApiResponse<ServerStatus, dynamic> statusResponse;
      try {
        statusResponse = await apiService.getStatus(internal: true);
      } catch (err) {
        if (err is ApiResponse<ServerStatus, dynamic>) statusResponse = err;
      }
      final serverResult = statusResponse?.data ??
          const ServerStatus(status: ServerConnectionStatus.Unavailable);
      serverStatus = serverResult;
    }
    DeviceConnectionSource deviceStatus = latestDeviceResult;
    if (deviceStatus == null || deviceStatus == DeviceConnectionSource.None) {
      deviceStatus = ConectivityResultMap[await _checkConnectivity()];
    }

    logger.info(
        'Initial server status: ${EnumUtils.enumToString(serverStatus.status)}');
    logger.info(
        'Initial connectivity status: ${EnumUtils.enumToString(deviceStatus)}');

    final connection = Connection(
        deviceConnectionSource: deviceStatus,
        serverConnectionInfo:
            _getServerConnectionInfo(envConfig, serverStatus));
    _updateResult(connection);
    return connection;
  }

  void _updateResult(Connection result) {
    if (result == null) return;
    logger.info('Attempting to update connection status: $result');
    _prevResult = _curResult;
    _curResult = result;
    _prevDeviceResult = _curDeviceResult;
    _curDeviceResult = result.deviceConnectionSource;
    _prevServerResult = _curServerResult;
    _curServerResult = result.serverConnectionInfo?.status;
    if (result.deviceConnectionSource != null &&
        result.deviceConnectionSource != _prevDeviceResult)
      _deviceConnectivityStreamController?.add(result.deviceConnectionSource);
    if (result.serverConnectionInfo?.status != null &&
        result.serverConnectionInfo?.status != _prevServerResult)
      _serverConnectivityStreamController
          ?.add(result.serverConnectionInfo?.status);
    _connectionStreamController?.add(result);
    logger.info('Connection updated: $result');
  }

  void _registerDeviceStatus() {
    if (_connectionStreamController?.isClosed ?? true)
      _connectionStreamController = StreamController<Connection>.broadcast();
    if (_deviceConnectivityStreamController?.isClosed ?? true)
      _deviceConnectivityStreamController =
          StreamController<DeviceConnectionSource>.broadcast();
    if (_serverConnectivityStreamController?.isClosed ?? true)
      _serverConnectivityStreamController =
          StreamController<ServerStatus>.broadcast();
    // TODO(shah): Workaround for connectivity stream issue on iOS https://github.com/flutter/flutter/issues/20980
    if (AppUtils.isIOS) {
      _connectivityTimer ??=
          Timer.periodic(const Duration(seconds: 2), (_) async {
        _updateDeviceConnectionSource(await _checkConnectivity());
      });
    } else {
      _connectivitySubscription ??= Connectivity().onConnectivityChanged.listen(
          _updateDeviceConnectionSource,
          onError: (dynamic e) =>
              logger.error('Connectivity stream listener failed.', e),
          onDone: () => logger.info('Connectivity stream closed.'));
    }
  }

  void _dispose() {
    _serverConnectivityStreamController?.close();
    _serverConnectivityStreamController = null;
    _deviceConnectivityStreamController?.close();
    _deviceConnectivityStreamController = null;
    _connectionStreamController?.close();
    _connectionStreamController = null;
    _disposeTimer();
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }

  void _disposeTimer() {
    _connectivityTimer?.cancel();
    _connectivityTimer = null;
  }

  ConnectionInfo<ServerStatus, EnvironmentConfig> _getServerConnectionInfo(
      EnvironmentConfig env, ServerStatus status) {
    return ConnectionInfo(env, status, DateTime.now());
  }

  Future<ConnectivityResult> _checkConnectivity() async {
    return await (AppUtils.isWeb
        ? Future.value(ConnectivityResult.wifi)
        : Connectivity().checkConnectivity());
  }

  void _updateDeviceConnectionSource(ConnectivityResult result) {
    final statusResult = ConectivityResultMap[result];
    if (statusResult == latestDeviceResult) return;
    logger.verbose('New device connection status detected: $result');

    final newResult = _curResult.copyWith(deviceConnectionSource: statusResult);
    _updateResult(newResult);
  }

  void updateEnvironment(EnvironmentConfig env, ServerStatus status) {
    final newResult = _curResult.copyWith(
        serverConnectionInfo: _getServerConnectionInfo(env, status));
    _updateResult(newResult);
  }

  void updateServerStatus(ServerStatus status) {
    final envConfig = RS.getFromRoot<EnvironmentConfig>();
    final newResult = _curResult.copyWith(
      serverConnectionInfo: _getServerConnectionInfo(envConfig, status),
    );
    _updateResult(newResult);
  }

  @override
  @protected
  Future<void> start() async {
    super.start();
    _registerDeviceStatus();
    return;
  }

  @override
  @protected
  Future<void> stop() async {
    super.stop();
    _disposeTimer();
    return;
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }
}
