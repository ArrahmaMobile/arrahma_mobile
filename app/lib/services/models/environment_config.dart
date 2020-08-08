import 'package:arrahma_mobile_app/utils/enum_utils.dart';
import 'package:flutter/material.dart';

enum EnvironmentType { DEV, STAGING, PRODUCTION }
const Map<EnvironmentType, Color> EnvironmentTypeColorMap = {
  EnvironmentType.DEV: Colors.blue,
  EnvironmentType.STAGING: Colors.deepPurpleAccent,
  EnvironmentType.PRODUCTION: Colors.green,
};

@immutable
class EnvironmentConfig {
  factory EnvironmentConfig(
      {String name,
      EnvironmentType environmentType,
      bool isInternal = false,
      Color color,
      String baseUrl}) {
    final normalizedBaseUrl = baseUrl != null
        ? baseUrl.endsWith('/') ? baseUrl : '$baseUrl/'
        : baseUrl;
    final env = EnvironmentConfig._internal(
        name, environmentType, isInternal, color, normalizedBaseUrl, null);
    final parsedBaseUrl = Uri.parse(env.baseUrl);
    return EnvironmentConfig._internal(name, environmentType, isInternal, color,
        normalizedBaseUrl, parsedBaseUrl);
  }

  const EnvironmentConfig._internal(this._name, this._environmentType,
      this._isInternal, this._color, this._baseUrl, this.parsedBaseUrl);

  static EnvironmentType defaultEnvironmentType = EnvironmentType.PRODUCTION;

  final String _baseUrl;
  final String _name;
  final EnvironmentType _environmentType;
  final bool _isInternal;
  final Color _color;
  final Uri parsedBaseUrl;

  EnvironmentType get environmentType =>
      _environmentType ?? defaultEnvironmentType;
  bool get isInternal => _isInternal;
  String get environmentTypeName =>
      EnumUtils.enumToString(environmentType, true);

  String get name => _name ?? environmentTypeName;
  Color get color =>
      _color ?? EnvironmentTypeColorMap[environmentType] ?? Colors.red;

  bool isProduction() => environmentType == EnvironmentType.PRODUCTION;

  bool isDevelopment() => environmentType == EnvironmentType.DEV;

  bool isStaging() => environmentType == EnvironmentType.STAGING;

  String get baseUrl => _baseUrl;
}
