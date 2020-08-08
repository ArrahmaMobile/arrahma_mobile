import 'package:arrahma_mobile_app/services/environment_service.dart';
import 'package:arrahma_mobile_app/services/models/environment_config.dart';
import 'package:flutter/material.dart';
import 'package:inherited_state/inherited_state.dart';

import 'Home_Page/home_page.dart';
import 'router/router.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    registerServices();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedState(
      states: [
        Inject<EnvironmentConfig>(
            () => SL.get<EnvironmentService>().getDefaultEnvironment()),
      ],
      builder: (_) => MaterialApp(
        initialRoute: '/home',
        onGenerateRoute: Router.generateRoute,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          ),
        ),
        home: HomePage(),
      ),
    );
  }

  void registerServices() {
    SL.register(() => EnvironmentService());
  }
}
