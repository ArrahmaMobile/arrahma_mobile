import 'dart:async';

import 'package:arrahma_shared/shared.dart';
import 'package:flutter_framework/flutter_framework.dart'
    hide ServerConnectionStatus;
import 'package:flutter_framework/flutter_framework.dart' as f;
import 'package:inherited_state/inherited_state.dart';

import 'device_storage_service.dart';

class AppService extends StoppableService {
  AppService(this.connectivityService, this.storageService, this.apiService,
      this.deviceStorageService) {
    init();
  }

  final ConnectivityService connectivityService;
  final IStorageService storageService;
  final ApiService apiService;
  final DeviceStorageService deviceStorageService;

  static const LAST_FETCH_DATE_KEY = 'LAST_FETCH_DATE';
  static const FETCH_INTERVAL = Duration(hours: 1);
  static const STATUS_CHECK_INTERVAL = Duration(seconds: 30);

  AppData _appData;
  AppData get appData => _appData;

  String _appDataHash;
  String get appDataHash => _appDataHash;

  // TODO(shah): Abstract into cached timer service
  Timer _dataFetchTimer;
  Timer _statusCheckTimer;

  Future<AppData> initApp() async {
    // _dataFetchTimer = Timer.periodic(
    //     FETCH_INTERVAL + const Duration(seconds: 10),
    //     (_) => dataFetchTimerHandler());
    _statusCheckTimer = Timer.periodic(
        STATUS_CHECK_INTERVAL + const Duration(seconds: 1),
        (_) => statusCheckTimerHandler());
    _appDataHash ??= await deviceStorageService.loadAppDataHash();

    await _setupData().catchError((dynamic _) => null);
    apiService.environmentConfigCtrl.stateListener
        .addListener(_onEnvironmentUpdate);
    _appData ??= await deviceStorageService.loadAppData();
    return _appData;
  }

  void _onEnvironmentUpdate() {
    _setupData(init: false, force: true);
  }

  Future<void> _setupData({bool init = true, bool force = false}) async {
    await statusCheckTimerHandler(init: init, force: force);
  }

  Future<AppData> dataFetchTimerHandler(
      {bool init = false, bool force = false}) async {
    final appDataInfo = await getData(force: force);
    if (appDataInfo?.value != null) {
      deviceStorageService.saveAppData(appDataInfo.value);
      deviceStorageService.saveAppDataHash(appDataInfo.key);
      if (!init)
        RS.getReactiveFromRoot<AppData>().setState((data) => appDataInfo.value);
      _appData = appDataInfo.value;
      _appDataHash = appDataInfo.key;
    }
    return appDataInfo.value;
  }

  Future<ServerStatus> statusCheckTimerHandler(
      {bool init = true, bool force = false}) async {
    final status = await getStatus();
    if (status != null) {
      final serverStatus =
          f.ServerConnectionStatus(status: STATUS_MAP[status.status]);
      connectivityService.updateServerStatus(serverStatus);
    }
    final isStale = status?.isDataStale ?? false;
    await dataFetchTimerHandler(
        init: init, force: force || isStale || appDataHash == null);
    return status;
  }

  static const STATUS_MAP = <ServerConnectionStatus, ServerConnectionState>{
    ServerConnectionStatus.Available: ServerConnectionState.Available,
    ServerConnectionStatus.Maintenance: ServerConnectionState.Maintenance,
    ServerConnectionStatus.Unavailable: ServerConnectionState.Unavailable,
  };

  Future<KeyValuePair<String, AppData>> getData({bool force = false}) async {
    AppData appData;
    String appDataHash;
    final lastFetchDate = DateTime.tryParse(
        await storageService.getWithKey<String>(LAST_FETCH_DATE_KEY) ?? '');
    final date = DateTime.now().toUtc();
    if (connectivityService.isConnected &&
        (force ||
            lastFetchDate ==
                null /*||
            date.difference(lastFetchDate) > FETCH_INTERVAL*/
        )) {
      try {
        final appDataResponse =
            await apiService.getWithResponse<AppData>('data');
        if (appDataResponse.isSuccess) {
          appData = appDataResponse.data;
          appDataHash = appDataResponse.headers['etag'];
          await storageService.setWithKey<String>(
              LAST_FETCH_DATE_KEY, date.toIso8601String());
        }
      } catch (err) {
        logger.error('Unable to get app data.', err);
      }
    }
    return KeyValuePair(appDataHash, appData);
  }

  Future<ServerStatus> getStatus() async {
    final status = await apiService.getWithResponse<ServerStatus>(
        'status${appDataHash != null ? '?dataHash=$appDataHash' : ''}',
        internal: true,
        timeout: const Duration(seconds: 10));
    return status.data;
  }

  @override
  void dispose() {
    apiService.environmentConfigCtrl.stateListener
        .removeListener(_onEnvironmentUpdate);
    _dataFetchTimer?.cancel();
    _statusCheckTimer?.cancel();
    super.dispose();
  }
}
