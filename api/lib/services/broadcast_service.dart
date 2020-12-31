import 'dart:convert';

import 'package:arrahma_shared/shared.dart';
import 'package:arrahma_web_api/api.dart';
import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';

import 'data_sync_service.dart';

class BroadcastService {
  BroadcastService(this.youtubeChannelId, this.googleApiKey);

  static const lastVideoIdFile = 'data/lastVideoId.txt';

  final String youtubeChannelId;
  final String googleApiKey;

  final _client = Client();
  final _fileService = FileService();
  DataSyncService _dataSyncService;

  String _lastVideoId;
  bool _isLive;

  bool get isLive => _isLive;

  Timer _liveStatusCheckTimer;

  Future<void> init() async {
    _dataSyncService = await DataSyncService.init('$BroadcastService');

    if (_dataSyncService.isMain) {
      _lastVideoId = await _fileService.read(lastVideoIdFile);
      await _performliveCheck();
      _liveStatusCheckTimer = Timer.periodic(
          const Duration(seconds: 30), (_) => _performliveCheck());
    } else {
      _dataSyncService.valueStreamCtrl.stream.listen((eventStr) {
        final event = json.decode(eventStr) as Map;
        _isLive = event['isLive'];
        _lastVideoId = event['lastVideoId'];
      }, onError: (err) => _dataSyncService.log(err));
    }
  }

  Future<void> _performliveCheck() async => _isLive = await checkIsLive();

  Future<bool> checkIsLive() async {
    final videoId =
        await _getLiveResultFromHtml(); //await _getLiveResultFromApi();
    final isLive = videoId != null;
    if (isLive && videoId != _lastVideoId) {
      await _fileService.write(lastVideoIdFile, videoId);
      _lastVideoId = videoId;
    }
    _dataSyncService.valueStreamCtrl.add(json.encode({
      'isLive': isLive,
      'lastVideoId': _lastVideoId,
    }));
    return isLive;
  }

  Future<String> _getLiveResultFromApi() async {
    final url =
        'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$youtubeChannelId&type=video&eventType=live&key=$googleApiKey';
    final response = await _client.get(url).catchError((_) => null);
    if (response?.body?.isEmpty ?? true) return null;
    final result = json.decode(response.body) as Map<String, dynamic>;
    if (result == null) return null;
    final isLive = result['pageInfo']['totalResults'] > 0;
    if (isLive) {
      return result['items'][0]['id']['videoId'];
    }
    return null;
  }

  Future<String> _getLiveResultFromHtml() async {
    final url = 'https://www.youtube.com/channel/$youtubeChannelId';
    final response = await _client.get(url).catchError((_) => null);
    if (response?.body?.isEmpty ?? true) return null;
    // final document = parse(response.body);
    // final isLive =
    //     document.querySelector('#thumbnail #overlays [overlay-style="LIVE"]') !=
    //         null;
    // if (isLive) {
    //   return Uri.parse(document.querySelector('#thumbnail').attributes['href'])
    //       .queryParameters['v'];
    // }
    return RegExp(
            r'https://i.ytimg.com/vi/([A-Za-z0-9\-_]+)/hqdefault_live.jpg')
        .firstMatch(response.body)
        ?.group(1);
  }

  void dispose() {
    _liveStatusCheckTimer?.cancel();
  }
}
