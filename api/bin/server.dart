import 'package:arrahma_web_api/api.dart';

Future main() async {
  final app = Application<ArrahmaChannel>()
    ..options.configurationFilePath = 'config.yaml'
    ..options.port =
        int.tryParse(Platform.environment['PORT'] ?? 8888.toString());

  final count = Platform.numberOfProcessors ~/ 2;
  await app.start(numberOfInstances: count > 0 ? count : 1);

  print('Application started on port: ${app.options.port}.');
  print('Use Ctrl-C (SIGINT) to stop running the application.');
}