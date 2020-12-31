import 'package:arrahma_shared/shared.dart';
import 'package:arrahma_web_api/api.dart';
import 'package:arrahma_web_api/services/data_sync_service.dart';

Future main() async {
  final isDebugging = Platform.environment['DEBUG'] == 'true';
  final app = Application<ArrahmaChannel>()
    ..isolateStartupTimeout = Duration(minutes: 30 * (isDebugging ? 4 : 1))
    ..options.configurationFilePath = 'config.yaml'
    ..options.certificateFilePath = Platform.environment['CERT_PATH']
    ..options.privateKeyFilePath = Platform.environment['KEY_PATH']
    ..options.port =
        int.tryParse(Platform.environment['PORT'] ?? 8888.toString());

  await FileService().delete(DataSyncService.idFilePath);

  final count = Platform.numberOfProcessors ~/ 2;
  await app.start(numberOfInstances: count > 0 ? count : 1);

  print('Application started on port: ${app.options.port}.');
  print('Use Ctrl-C (SIGINT) to stop running the application.');
}
