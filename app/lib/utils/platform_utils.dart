import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_utils.dart';
import 'models/device_info.dart';

class PlatformUtils {
  static PageRoute<T> getPageRouteTransition<T>(WidgetBuilder builder,
      [RouteSettings settings]) {
    return AppUtils.isIOS
        ? CupertinoPageRoute<T>(builder: builder, settings: settings)
        : MaterialPageRoute<T>(builder: builder, settings: settings);
  }

  static IconData getBackArrow() {
    return AppUtils.isIOS ? Icons.arrow_back_ios : Icons.arrow_back;
  }

  static IconData getForwardArrow() {
    return AppUtils.isIOS ? Icons.arrow_forward_ios : Icons.arrow_forward;
  }

  static Future<DeviceInfo> getDeviceInfo() async {
    if (AppUtils.isWeb) {
      return const DeviceInfo(
        isPhysical: true,
        manufacturer: 'Web',
        platform: DevicePlatform.Other,
        version: '',
        name: '',
        model: '',
      );
    } else {
      final DeviceInfoPlugin plugin = DeviceInfoPlugin();
      if (AppUtils.isIOS) {
        final info = await plugin.iosInfo;
        return DeviceInfo(
          isPhysical: info.isPhysicalDevice,
          manufacturer: 'Apple, Inc.',
          platform: AppUtils.platform,
          version: info.systemVersion,
          name: info.name,
          model: info.model,
        );
      } else {
        final info = await plugin.androidInfo;
        return DeviceInfo(
          isPhysical: info.isPhysicalDevice,
          manufacturer: info.manufacturer,
          platform: AppUtils.platform,
          version: info.version.release,
          sdkVersion: info.version.sdkInt.toString(),
          name: info.product,
          model: info.model,
          attributes: {
            'Brand': info.brand,
            'Device': info.device,
            'BuildId': info.display,
            'Fingerprint': info.fingerprint,
          },
        );
      }
    }
  }
}
