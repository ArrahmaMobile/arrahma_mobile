import 'package:arrahma_mobile_app/app.dart';
import 'package:arrahma_mobile_app/services/app.dart';
import 'package:arrahma_shared/shared.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';
import 'package:inherited_state/inherited_state.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'core/app_theme.dart';
import 'core/serialization/mapper.dart';
import 'services/device_storage_service.dart';

Future main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.arrahmah.app.audio',
    androidNotificationChannelName: 'Arrahmah Audio Player',
    androidNotificationOngoing: true,
  );
  Mapper.init();
  setJsonMapperInitFn(Mapper.init);
  WidgetsFlutterBinding.ensureInitialized();

  final dependencies = await AppStartup.initAppDependencies(
    backgroundImageUrls: (_) => [],
    logoProvider: null,
    environments: [
      EnvironmentConfig(
        name: 'Staging',
        environmentType: EnvironmentType.STAGING,
        baseUrl: 'https://arrahmah.sasid.me/api',
      ),
      if (kDebugMode)
        EnvironmentConfig(
          name: 'Dev-1',
          environmentType: EnvironmentType.DEV,
          baseUrl: 'http://192.168.86.97:8888/api', //   86.68
        ),
    ],
    theme: AppThemeUtils.getThemeVariants(),
  );
  final apiService = SL.get<ApiService>()!;
  final connectivityService = SL.get<ConnectivityService>()!;
  final storageService = SL.get<IStorageService>()!;
  final deviceStorageService = DeviceStorageService(storageService);

  final appService = AppService(
      connectivityService, storageService, apiService, deviceStorageService);
  final appData = await appService.initApp();

  dependencies.addAll([
    Inject<AppData>(() => appData),
  ]);

  SL.register(() => deviceStorageService);
  SL.register(() => appService);

  final mainApp = AppStartup.enableFeedback(
    InheritedState(states: [...dependencies], builder: (_) => const App()),
  );
  final appWidget = await AppStartup.verifyBioAuth()
      ? mainApp
      : AppStartup.defaultBioAuthFallbackWidget(mainApp);

  runApp(
    // AppUtils.isDebug
    //     ? DevicePreview(enabled: true, builder: (_) => appWidget)
    //     : appWidget,
    appWidget,
  );
}
