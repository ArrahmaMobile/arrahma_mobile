import 'package:arrahma_mobile_app/services/models/environment_config.dart';

class EnvironmentService {
  List<EnvironmentConfig> getEnvironments() {
    return [
      EnvironmentConfig(
        environmentType: EnvironmentType.DEV,
        baseUrl: 'http://192.168.86.199:8888/api',
      ),
    ];
  }

  EnvironmentConfig getDefaultEnvironment() {
    return getEnvironments().first;
  }
}
