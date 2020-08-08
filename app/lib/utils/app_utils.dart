import 'dart:io';

import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';
import 'package:system_info/system_info.dart';

import 'enum_utils.dart';
import 'models/device_info.dart';

enum DevicePlatform { Android, IOS, Other }
enum Mode { DEBUG, PROFILE, RELEASE }
const int MEGABYTE = 1024 * 1024;

class AppUtils {
  const AppUtils._internal(this._appName, this._appVersion, this._packageName,
      this._buildNumber, this._deviceInfo);

  factory AppUtils.init(PackageInfo packageInfo, DeviceInfo deviceInfo) {
    _instance ??= AppUtils._internal(packageInfo.appName, packageInfo.version,
        packageInfo.packageName, packageInfo.buildNumber, deviceInfo);
    return _instance;
  }

  static AppUtils _instance;

  final String _appName;
  final String _appVersion;
  final String _packageName;
  final String _buildNumber;
  final DeviceInfo _deviceInfo;

  static String get appName => _instance._appName;
  static String get appVersion => _instance._appVersion;
  static String get packageName => _instance._packageName;
  static String get buildNumber => _instance._buildNumber;

  static DeviceInfo get deviceInfo => _instance._deviceInfo;

  static Mode get buildMode => foundation.kReleaseMode
      ? Mode.RELEASE
      : foundation.kDebugMode
          ? Mode.DEBUG
          : foundation.kProfileMode ? Mode.PROFILE : Mode.DEBUG;

  static String get buildModeName => EnumUtils.enumToString(buildMode, true);
  static bool get isDebug => buildMode == Mode.DEBUG;

  static DevicePlatform get platform => isWeb
      ? DevicePlatform.Other
      : Platform.isAndroid
          ? DevicePlatform.Android
          : Platform.isIOS ? DevicePlatform.IOS : DevicePlatform.Other;
  static String get platformName => isWeb
      ? 'Web'
      : platform == DevicePlatform.IOS
          ? 'iOS'
          : EnumUtils.enumToString(platform, true);

  static bool get isAndroid => platform == DevicePlatform.Android;
  static bool get isIOS => platform == DevicePlatform.IOS;
  static bool get isWeb => kIsWeb;

  static String get totalPhysicalMemory =>
      '${SysInfo.getTotalPhysicalMemory() ~/ MEGABYTE} MB';
  static String get freePhysicalMemory =>
      '${SysInfo.getFreePhysicalMemory() ~/ MEGABYTE} MB';
  static String get totalVirtualMemory =>
      '${SysInfo.getTotalVirtualMemory() ~/ MEGABYTE} MB';
  static String get freeVirtualMemory =>
      '${SysInfo.getFreeVirtualMemory() ~/ MEGABYTE} MB';
  static String get virtualMemorySize =>
      '${SysInfo.getVirtualMemorySize() ~/ MEGABYTE} MB';
}
