import 'package:arrahma_mobile_app/services/models/environment_config.dart';

class EnvironmentService {
  List<EnvironmentConfig> getEnvironments() {
    return [
      EnvironmentConfig(
        environmentType: EnvironmentType.DEV,
        baseUrl: 'https://localhost:8080/api',
      ),
    ];
  }

  EnvironmentConfig getDefaultEnvironment() {
    return getEnvironments().first;
  }
}
