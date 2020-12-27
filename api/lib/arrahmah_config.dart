import 'dart:io';

import 'package:aqueduct/aqueduct.dart';

class ArrahmahConfiguration extends Configuration {
  ArrahmahConfiguration(String fileName) : super.fromFile(File(fileName));

  String googleApiKey;
  String youtubeChannelId;
}
