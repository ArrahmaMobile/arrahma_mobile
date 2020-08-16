import 'package:flutter/material.dart';
import 'package:simple_json_mapper/simple_json_mapper.dart';

@JObj()
class AppConfig {
  const AppConfig({this.themeMode, this.environmentName});
  final ThemeMode themeMode;
  final String environmentName;

  AppConfig copyWith({ThemeMode themeMode, String environmentName}) {
    return AppConfig(
      themeMode: themeMode ?? this.themeMode,
      environmentName: environmentName ?? this.environmentName,
    );
  }
}
