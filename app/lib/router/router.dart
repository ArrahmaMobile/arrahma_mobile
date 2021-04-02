import 'package:arrahma_mobile_app/views/home_page.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_framework/flutter_framework.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return BaseAppRouter.generateRoute(settings, (context) {
      return AudioServiceWidget(
        child: HomePage(),
      );
    });
  }
}
