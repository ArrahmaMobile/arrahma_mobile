import 'dart:convert';

import 'package:arrahma_shared/shared.dart';
import 'package:arrahma_web_api/api.dart';
import 'package:http/http.dart';

import '../arrahmah_config.dart';
import 'data_sync_service.dart';

class BroadcastService {
  BroadcastService._(this.config);

  static const lastVideoIdsFile = 'data/lastVideoIds.txt';

  final ArrahmahConfiguration config;

  final _client = Client();
  final _fileService = FileService();
  late DataSyncService _dataSyncService;

  List<String?>? _lastVideoIds;

  BroadcastStatus _broadcastStatus = BroadcastStatus.init();
  BroadcastStatus get broadcastStatus => _broadcastStatus;

  Timer? _liveStatusCheckTimer;

  static Future<BroadcastService> init(ArrahmahConfiguration config) async {
    final service = BroadcastService._(config);
    service._dataSyncService = await DataSyncService.init('$BroadcastService');

    if (service._dataSyncService.isMain) {
      service._lastVideoIds =
          (await service._fileService.read(lastVideoIdsFile))?.split(',') ??
              ['', '', ''];
      await service._performliveCheck();
      service._liveStatusCheckTimer = Timer.periodic(
          const Duration(seconds: 30), (_) => service._performliveCheck());
    } else {
      service._dataSyncService.valueStreamCtrl.stream.listen((eventStr) {
        final event = json.decode(eventStr) as Map;
        service._broadcastStatus = BroadcastStatus(
          isYoutubeLive: event['isYoutubeLive'],
          isFacebookLive: event['isFacebookLive'],
          isMixlrLive: event['isMixlrLive'],
        );
      }, onError: (err) => service._dataSyncService.log(err));
    }

    return service;
  }

  Future<void> _performliveCheck() async {
    if (!_dataSyncService.isMain) return;

    _broadcastStatus = await checkIsLive();
  }

  Future<BroadcastStatus> checkIsLive() async {
    final youtubeVideoId =
        await _getYoutubeLiveResultFromHtml(); //await _getLiveResultFromApi();
    final isYoutubeLive = youtubeVideoId != null;
    final lastYoutubeVideoId = _lastVideoIds![0];

    final facebookVideoId = await _getFacebookLiveResultFromHtml();
    final isFacebookLive = facebookVideoId != null;
    final lastFacebookVideoId = _lastVideoIds![1];

    final mixlrVideoId = await _getMixlrLiveResultFromApi();
    final isMixlrLive = mixlrVideoId != null;
    final lastMixlrVideoId = _lastVideoIds![2];

    final hasChanged = lastYoutubeVideoId != youtubeVideoId ||
        lastFacebookVideoId != facebookVideoId ||
        lastMixlrVideoId != mixlrVideoId;

    if (!hasChanged) return _broadcastStatus;

    _lastVideoIds = [youtubeVideoId, facebookVideoId, mixlrVideoId];
    await _fileService.write(lastVideoIdsFile, _lastVideoIds!.join(','));

    final broadcaseStatus = BroadcastStatus(
      isYoutubeLive: isYoutubeLive,
      isFacebookLive: isFacebookLive,
      isMixlrLive: isMixlrLive,
    );
    _dataSyncService.valueStreamCtrl.add(json.encode({
      'isYoutubeLive': broadcaseStatus.isYoutubeLive,
      'isFacebookLive': broadcaseStatus.isFacebookLive,
      'isMixlrLive': broadcaseStatus.isMixlrLive,
    }));
    return broadcaseStatus;
  }

  Future<String?> _getLiveResultFromApi() async {
    try {
      final url =
          'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=${config.youtubeChannelId}&type=video&eventType=live&key=${config.googleApiKey}';
      final response = await _client.get(Uri.parse(url));
      if (response.body.isEmpty) return null;
      final result = json.decode(response.body);
      if (result == null) return null;
      final isLive = result['pageInfo']['totalResults'] > 0;
      if (isLive) {
        return result['items'][0]['id']['videoId'];
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> _getYoutubeLiveResultFromHtml() async {
    final url = 'https://www.youtube.com/channel/${config.youtubeChannelId}';
    try {
      final response = await _client.get(Uri.parse(url));
      if (response.body.isEmpty) return null;
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
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> _getFacebookLiveResultFromHtml() async {
    try {
      final url =
          'https://www.facebook.com/${config.facebookChannelId}/live_videos';
      final response = await _client.get(Uri.parse(url));
      if (response.body.isEmpty) return null;
      return RegExp(r'"videoID":"(\d+)"').firstMatch(response.body)?.group(1);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> _getMixlrLiveResultFromApi() async {
    try {
      final url =
          'https://api.mixlr.com/users/${config.mixlrChannelId}?source=embed';
      final response = await _client.get(Uri.parse(url));
      if (response.body.isEmpty) return null;
      final data = json.decode(response.body);
      final isLive = (data['is_live'] ?? false) as bool;
      final ids = (data['broadcast_ids'] as List<dynamic>?)?.cast<String>() ?? [];
      return isLive && ids.isNotEmpty ? ids.first : null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void dispose() {
    _liveStatusCheckTimer?.cancel();
  }
}
