import 'package:flutter/material.dart';
import 'package:inherited_state/inherited_state.dart';
import 'router/router.dart';

class App extends StatelessWidget {
  const App({Key key, this.dependencies}) : super(key: key);
  final List<Inject> dependencies;

  @override
  Widget build(BuildContext context) {
    return InheritedState(
      states: [
        if (dependencies != null) ...dependencies,
      ],
      builder: (_) => MaterialApp(
        onGenerateRoute: AppRouter.generateRoute,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            color: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
