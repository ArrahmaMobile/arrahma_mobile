import '../app_utils.dart';

class DeviceInfo {
  const DeviceInfo(
      {this.isPhysical,
      this.manufacturer,
      this.platform,
      this.version,
      this.sdkVersion,
      this.name,
      this.model,
      this.attributes});
  final bool isPhysical;
  final String manufacturer;

  final DevicePlatform platform;
  final String version;
  final String sdkVersion;
  final String name;
  final String model;

  final Map<String, String> attributes;
}
