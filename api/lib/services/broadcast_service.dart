import 'dart:convert';

import 'package:arrahma_shared/shared.dart';
import 'package:arrahma_web_api/api.dart';
import 'package:http/http.dart';

class BroadcastService {
  BroadcastService(this.youtubeChannelId, this.googleApiKey);

  static const lastVideoIdFile = 'data/lastVideoId.txt';

  final String youtubeChannelId;
  final String googleApiKey;

  final _client = Client();
  final _fileService = FileService();

  String _lastVideoId;
  bool _isLive;

  bool get isLive => _isLive;

  Timer _liveStatusCheckTimer;

  Future<void> init() async {
    _lastVideoId = await _fileService.read(lastVideoIdFile);
    await _initLiveCheck();
    _liveStatusCheckTimer = Timer(const Duration(seconds: 30), _initLiveCheck);
  }

  void _initLiveCheck() async => _isLive = await checkIsLive();

  Future<bool> checkIsLive() async {
    final url =
        'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$youtubeChannelId&type=video&eventType=live&key=$googleApiKey';
    final response = await _client.get(url).catchError((_) => null);
    if (response?.body?.isEmpty ?? true) return false;
    final result = json.decode(response.body) as Map<String, dynamic>;
    if (result == null) return false;
    final isLive = result['pageInfo']['totalResults'] > 0;
    if (isLive) {
      final videoId = result['items'][0]['id']['videoId'];
      if (videoId != _lastVideoId) {
        await _fileService.write(lastVideoIdFile, videoId);
      }
    }
    return isLive;
  }

  void dispose() {
    _liveStatusCheckTimer?.cancel();
  }
}
