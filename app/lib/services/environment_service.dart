import 'package:arrahma_mobile_app/services/models/environment_config.dart';

class EnvironmentService {
  List<EnvironmentConfig> getEnvironments() {
    return [
      EnvironmentConfig(
        name: 'Dev-1',
        environmentType: EnvironmentType.DEV,
        baseUrl: 'http://192.168.86.199:8888/api',
      ),
      EnvironmentConfig(
        name: 'Dev-2',
        environmentType: EnvironmentType.DEV,
        baseUrl: 'http://192.168.86.204:8888/api',
      ),
    ];
  }

  EnvironmentConfig getDefaultEnvironment() {
    return getEnvironments().first;
  }
}
