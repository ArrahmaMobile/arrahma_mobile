import 'package:arrahma_mobile_app/pages/home_page.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute<dynamic>(
      builder: (context) => AudioServiceWidget(
        child: HomePage(),
      ),
    );
  }
}
