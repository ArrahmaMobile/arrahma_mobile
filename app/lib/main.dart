import 'package:arrahma_mobile_app/app.dart';
import 'package:arrahma_mobile_app/features/media_player/audio_player_service.dart';
import 'package:arrahma_mobile_app/services/app.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';
import 'package:inherited_state/inherited_state.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/serialization/mapper.dart';
import 'services/device_storage_service.dart';

Future main() async {
  Mapper.init();
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
  SL.register(() => sharedPref);

  const IStorageService storageService = StorageService();
  const deviceStorageService = DeviceStorageService(storageService);
  final deviceConfig = await deviceStorageService.loadDeviceConfig();

  final envName = await deviceStorageService.loadEnvironmentName();
  final window = WidgetsBinding.instance.window;
  final deviceSize = window.physicalSize / window.devicePixelRatio;
  final envService = EnvironmentService([
    EnvironmentConfig(
      name: 'Staging',
      environmentType: EnvironmentType.DEV,
      baseUrl: 'https://arrahmah.sasid.me/api',
    ),
    EnvironmentConfig(
      name: 'Dev-1',
      environmentType: EnvironmentType.DEV,
      baseUrl: 'http://192.168.86.199:8888/api',
    ),
  ]);
  final envConfig = envName != null
      ? envService.getEnvironments().singleWhere((env) => env.name == envName)
      : envService.getDefaultEnvironment();
  final connectivityService = ConnectivityService();

  final apiService = ApiService(connectivityService, deviceConfig,
      initialEnvironmentConfig: envConfig, deviceSize: deviceSize);

  await connectivityService.initConnectionStatus(envConfig, apiService);
  final appService = AppService(
      connectivityService, storageService, apiService, deviceStorageService);
  final appData = await appService.initData();

  final dependencies = <Inject<dynamic>>[];

  dependencies.addAll([
    Inject<EnvironmentConfig>(() => envConfig),
    Inject<AppData>(() => appData),
  ]);

  SL.register(() => deviceStorageService);
  SL.register(() => storageService);
  SL.register(() => deviceConfig);
  SL.register(() => envService);
  SL.register(() => connectivityService);
  SL.register(() => appService);
  SL.register(() => AudioPlayerService(storageService, apiService));

  runApp(App(dependencies: dependencies));
}
