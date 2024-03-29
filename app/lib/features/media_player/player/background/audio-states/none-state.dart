import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';

import '../audio-context.dart';
import '../audio-state-base.dart';
import 'connecting-state.dart';

class NoneState extends MediaStateBase {
  NoneState({@required AudioContextBase context}) : super(context: context);

  @override
  Future<void> pause() async {}

  @override
  Future<void> seek(Duration position) async =>
      super.setFutureSeekValue(position);

  @override
  Future<void> stop() async {}

  @override
  Future<void> play() async {}

  @override
  Future<void> setItem(String mediaId) async {
    context.stateHandler = ConnectingState(context: context);
    await context.stateHandler.setItem(mediaId);
  }
}
