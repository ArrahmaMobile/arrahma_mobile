import 'dart:async';

import 'package:flutter/services.dart';

class AppLauncher {
  static const MethodChannel _channel = const MethodChannel('core_plugin');

  static Future<bool> isAppInstalled(String packageName) async {
    return await _channel.invokeMethod(
      'isAppInstalled',
      <String, dynamic>{"packageName": packageName},
    );
  }

  static Future<bool> launchApp(String packageName) async {
    return await _channel.invokeMethod(
      'launchApp',
      <String, dynamic>{"packageName": packageName},
    );
  }
}
