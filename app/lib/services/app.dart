import 'dart:async';

import 'package:arrahma_shared/shared.dart';
import 'package:flutter_framework/flutter_framework.dart';
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

  AppData _appData;
  AppData get appData => _appData;

  Timer _dataFetchTimer;

  Future<AppData> initData() async {
    _dataFetchTimer = Timer.periodic(
        FETCH_INTERVAL + const Duration(seconds: 10),
        (_) => dataTimerFetchHandler());
    await dataTimerFetchHandler(init: true);
    _appData ??= await deviceStorageService.loadAppData();
    return _appData;
  }

  Future<AppData> dataTimerFetchHandler({bool init = false}) async {
    final appData = await getData();
    if (appData != null) {
      deviceStorageService.saveAppData(appData);
      if (!init) RS.getReactiveFromRoot<AppData>().setState((data) => appData);
      _appData = appData;
    }
    return appData;
  }

  Future<AppData> getData() async {
    AppData appData;
    final lastFetchDate = DateTime.tryParse(
        await storageService.getWithKey<String>(LAST_FETCH_DATE_KEY) ?? '');
    if (connectivityService.isConnected &&
        (lastFetchDate == null ||
            lastFetchDate.difference(DateTime.now().toUtc()) >
                FETCH_INTERVAL)) {
      final appDataResponse = await apiService.getWithResponse<AppData>('data');
      if (appDataResponse.isSuccess) {
        appData = appDataResponse.data;
        await storageService.setWithKey<String>(
            LAST_FETCH_DATE_KEY, DateTime.now().toUtc().toIso8601String());
      }
    }
    return appData;
  }

  @override
  void dispose() {
    _dataFetchTimer?.cancel();
    super.dispose();
  }
}
