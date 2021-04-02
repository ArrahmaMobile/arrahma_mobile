import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';
import 'package:inherited_state/inherited_state.dart';
import 'router/router.dart';

class App extends StatelessWidget {
  const App({Key key, this.dependencies}) : super(key: key);
  final List<Inject> dependencies;

  @override
  Widget build(BuildContext context) {
    final themeVariants = context.on<ThemeVariants>();
    final userPreferences = context.on<UserPreferences>();
    return MaterialApp(
      title: 'Arrahmah',
      color: Colors.white,
      theme: themeVariants.light.theme,
      darkTheme: themeVariants.dark.theme,
      themeMode: userPreferences?.themePerference?.themeMode ?? ThemeMode.dark,
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
