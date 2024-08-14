import 'package:dart_json_mapper/dart_json_mapper.dart';

@jsonSerializable
class ServerStatus {
  const ServerStatus({
    required this.status,
    required this.isDataStale,
    required this.broadcastStatus,
    required this.lastScrapedOn,
    required this.lastScrapeAttemptOn,
    this.lastDataHash,
  });
  final ServerConnectionStatus status;
  final bool isDataStale;
  final BroadcastStatus broadcastStatus;
  final DateTime lastScrapedOn;
  final DateTime lastScrapeAttemptOn;
  final String? lastDataHash;
}

@jsonSerializable
enum ServerConnectionStatus {
  Available,
  Maintenance,
  Unavailable,
}

@jsonSerializable
class BroadcastStatus {
  const BroadcastStatus(
      {required this.isYoutubeLive, required this.isFacebookLive, required this.isMixlrLive});
  const BroadcastStatus.init()
      : isFacebookLive = false,
        isYoutubeLive = false,
        isMixlrLive = false;
  final bool isYoutubeLive;
  final bool isFacebookLive;
  final bool isMixlrLive;
}
