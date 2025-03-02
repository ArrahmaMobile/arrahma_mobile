import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';
import 'package:inherited_state/inherited_state.dart';
import 'router/router.dart';

class App extends StatelessWidget {
  const App({super.key, this.dependencies});
  final List<Inject>? dependencies;

  @override
  Widget build(BuildContext context) {
    final themeVariants = context.on<ThemeVariants>();
    final userPreferences = context.on<UserPreferences>();
    return MaterialApp(
      title: 'Arrahmah',
      color: Colors.white,
      theme: themeVariants.light.theme,
      darkTheme: themeVariants.dark.theme,
      themeMode: userPreferences.themePerference.themeMode,
      locale: AppUtils.isDebug ? DevicePreview.locale(context) : null,
      builder: AppUtils.isDebug ? DevicePreview.appBuilder : null,
      onGenerateRoute: AppRouter.generateRoute,
      // theme: ThemeData(
      //   primaryColor: Colors.red,
      //   appBarTheme: const AppBarTheme(
      //     color: Colors.white,
      //     iconTheme: IconThemeData(color: Colors.black),
      //   ),
      // ),
    );
  }
}
