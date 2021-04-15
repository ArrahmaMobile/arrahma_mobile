import 'package:simple_json_mapper/simple_json_mapper.dart';

@JObj()
class ServerStatus {
  const ServerStatus({
    this.status,
    this.isDataStale,
    this.broadcastStatus,
    this.lastScrapedOn,
    this.lastScrapeAttemptOn,
  });
  final ServerConnectionStatus status;
  final bool isDataStale;
  final BroadcastStatus broadcastStatus;
  final DateTime lastScrapedOn;
  final DateTime lastScrapeAttemptOn;
}

enum ServerConnectionStatus {
  Available,
  Maintenance,
  Unavailable,
}

class BroadcastStatus {
  const BroadcastStatus(
      {this.isYoutubeLive, this.isFacebookLive, this.isMixlrLive});
  const BroadcastStatus.init()
      : isFacebookLive = false,
        isYoutubeLive = false,
        isMixlrLive = false;
  final bool isYoutubeLive;
  final bool isFacebookLive;
  final bool isMixlrLive;
}
