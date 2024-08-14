import 'package:arrahma_shared/shared.dart';
import 'package:arrahma_web_api/api.dart';
import 'package:arrahma_web_api/services/data_sync_service.dart';

import 'package:conduit_core/conduit_core.dart';

Future main() async {
  final isDebugging = Platform.environment['DEBUG'] == 'true';
  final certPath = Platform.environment['CERT_PATH'];
  final keyPath = Platform.environment['KEY_PATH'];
  final portVal = Platform.environment['PORT'];
  final port = (portVal != null ? int.tryParse(portVal) : null) ?? 8888;

  if (isDebugging) {
    print('Debugging mode enabled.');
  }

  if (!isDebugging && (certPath == null || keyPath == null)) {
    print('Certificate and key paths are required.');
    return;
  }
  final app = Application<ArrahmaChannel>()
    ..isolateStartupTimeout = Duration(minutes: 30 * (isDebugging ? 4 : 1))
    ..options.configurationFilePath = 'config.yaml'
    ..options.certificateFilePath = certPath
    ..options.privateKeyFilePath = keyPath
    ..options.port = port;

  await FileService().delete(DataSyncService.idFilePath);

  final count = Platform.numberOfProcessors ~/ 2;
  await app.start(numberOfInstances: count > 0 ? count : 1);

  print('Application started on port: ${app.options.port}.');
  print('Use Ctrl-C (SIGINT) to stop running the application.');
}
