import 'dart:io';

import 'package:conduit/conduit.dart';

class ArrahmahConfiguration extends Configuration {
  ArrahmahConfiguration(String fileName) : super.fromFile(File(fileName));

  late String googleApiKey;
  late String youtubeChannelId;
  late String facebookChannelId;
  late String mixlrChannelId;
  late String errorEmailRecipient;
  late String senderEmail;
  late String senderEmailPassword;
}
