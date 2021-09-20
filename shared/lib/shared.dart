export 'src/models/models.dart';
export 'src/app_metadata.dart';
export 'src/run_metadata.dart';
export 'src/services/services.dart';

import 'mapper.g.dart' as mapper;

void init() {
  mapper.init();
}
