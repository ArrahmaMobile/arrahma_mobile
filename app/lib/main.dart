import 'package:arrahma_mobile_app/app.dart';
import 'package:arrahma_mobile_app/services/models/app_config.dart';
import 'package:arrahma_mobile_app/services/storage/storage_provider.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:arrahma_shared/shared.dart' as shared;
import 'package:flutter/material.dart';
import 'package:inherited_state/inherited_state.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mapper.g.dart' as mapper;
import 'services/api.dart';
import 'services/connectivity.dart';
import 'services/device_storage.dart';
import 'services/environment_service.dart';
import 'services/models/environment_config.dart';
import 'services/storage/storage_service.dart';
import 'utils/app_utils.dart';
import 'utils/platform_utils.dart';

Future main() async {
  mapper.init();
  shared.init();

  WidgetsFlutterBinding.ensureInitialized();

  final deviceInfo = await PlatformUtils.getDeviceInfo();
  final packageInfo = await (AppUtils.isWeb
      ? Future.value(PackageInfo(
          appName: 'bitbuilders',
          packageName: '',
          version: '1.0.0',
          buildNumber: ''))
      : PackageInfo.fromPlatform());
  AppUtils.init(packageInfo, deviceInfo);
  final sharedPref = await SharedPreferences.getInstance();

  final IStorageService storageService = StorageService(sharedPref);
  final deviceStorageService = DeviceStorageService(storageService);
  // final appConfig = await deviceConfigService.loadAppConfigPreferences(config);
  final deviceConfig = await deviceStorageService.loadDeviceConfig();

  final window = WidgetsBinding.instance.window;
  final deviceSize = window.physicalSize / window.devicePixelRatio;
  final envService = EnvironmentService();
  final appConfig = await deviceStorageService.loadAppConfigPreferences();
  final envConfig = appConfig?.environmentName != null
      ? envService
          .getEnvironments()
          .singleWhere((env) => env.name == appConfig.environmentName)
      : envService.getDefaultEnvironment();
  final connectivityService = ConnectivityService();

  final apiService = ApiService(connectivityService, deviceConfig,
      initialEnvironmentConfig: envConfig, deviceSize: deviceSize);

  final connection =
      await connectivityService.initConnectionStatus(envConfig, apiService);

  final dependencies = <Inject<dynamic>>[];
  AppData appData;
  if (connection.isConnected) {
    final appDataResponse = await apiService.getWithResponse<AppData>('data');
    if (appDataResponse.isSuccess) {
      appData = appDataResponse.data;
      deviceStorageService.saveAppData(appData);
    }
  }

  appData ??= await deviceStorageService.loadAppData();

  dependencies.addAll([
    Inject<EnvironmentConfig>(() => envConfig),
    Inject<AppConfig>(() => appConfig),
    Inject<AppData>(() => appData),
  ]);

  SL.register(() => deviceStorageService);
  SL.register(() => storageService);
  SL.register(() => deviceConfig);
  SL.register(() => envService);
  SL.register(() => connectivityService);

  runApp(App(dependencies: dependencies));
}
