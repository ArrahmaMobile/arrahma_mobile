/// Shared shared for the arrahma app.
///
/// Used by the mobile app and the scraper projects.
library shared;

export 'src/models/models.dart';
export 'src/app_metadata.dart';
export 'src/run_metadata.dart';
export 'src/services/services.dart';
export 'src/utils/utils.dart';

import 'mapper.g.dart' as mapper;

void init() {
  mapper.init();
}