import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import '../background/audio-context.dart';
import '../background/audio-task-decorator.dart';
import '../background/audio-task.dart';
import '../background/icontext-audio-task.dart';
import './position-data-manager.dart';
import './position-manager.dart';
import './position.dart';

/// The background component to [PositionManager]. Decorates an audio task by persisting
/// current media position, if it has an ID.
class PositionedAudioTask extends AudioTaskDecorater {
  PositionedAudioTask({@required IContextAudioTask audioTask, this.dataManager})
      : super(baseTask: audioTask) {
    IsolateNameServer.removePortNameMapping(SendPortID);
    IsolateNameServer.registerPortWithName(_receivePort.sendPort, SendPortID);

    _receivePort
        .listen((dynamic data) => _answerPortMessage(data as List<dynamic>));
  }

  /// Initilize a [PositionedAudioTask] with default audio task and data manager implementations.
  PositionedAudioTask.standard()
      : this(audioTask: AudioTask(), dataManager: HivePositionDataManager());

  static const String SendPortID = 'position_send_port';
  static const String GetPositionsCommand = 'getPosition';
  static const String SetPositionCommand = 'setPosition';

  final IPositionDataManager dataManager;

  final ReceivePort _receivePort = ReceivePort();

  /// Messages can come in before any backing data service is initilized.
  /// Here, we keep track of when things are ready. This is awaited in [_answerPortMessage(message)].
  final Completer<void> _readyToAnswerMessages = Completer();

  StreamSubscription subscription;

  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    // This must be called on start to ensure that we know the psition if UI
    // asks for it.
    await dataManager.init();

    _readyToAnswerMessages.complete();

    subscription = context.mediaStateStream
        // The only thing we don't want to update for is stopped.
        // stop - is tricky, because by convention stop means to reset the saved position.
        .where((event) =>
            event.playing ||
            event.processingState == AudioProcessingState.ready)
        .listen((state) => dataManager.setPosition(Position(
            id: context.mediaItem.id, position: state.currentPosition)));

    context.mediaStateStream
        .where(
            (event) => event.processingState == AudioProcessingState.completed)
        .listen((state) => dataManager.setPosition(
            Position(id: context.mediaItem.id, position: Duration.zero)));

    await super.onStart(params);
  }

  @override
  // super is called in _endTaskAtPosition
  // ignore: must_call_super
  Future<void> onStop() async {
    // On android we can tell the diffirence between a user requested stop
    // and the process ending e.g. through swiping away the notification, so
    // interpert stop in the traditional method of "start from begginging".
    final position = Platform.isAndroid &&
            context.playBackState.processingState !=
                AudioProcessingState.completed
        ? Duration.zero
        : context.playBackState.currentPosition;

    try {
      await _endTaskAtPosition(position);
    } finally {}
  }

  @override
  Future<void> onPlayFromMediaId(String mediaId) async {
    _loadPosition(mediaId);
    super.onPlayFromMediaId(mediaId);
  }

  @override
  Future<void> onSkipToQueueItem(String mediaId) async {
    if (mediaId == context.mediaItem?.id) return;
    _loadPosition(mediaId);
    super.onSkipToQueueItem(mediaId);
  }

  @override
  Future<void> onSkipToNext() async {
    if (!baseTask.context.hasNext()) return;
    final id = baseTask.context.getNext().id;
    _loadPosition(id);
    super.onSkipToQueueItem(id);
  }

  @override
  Future<void> onSkipToPrevious() async {
    if (!baseTask.context.hasPrevious()) return;
    final id = baseTask.context.getPrevious().id;
    _loadPosition(id);
    super.onSkipToQueueItem(id);
  }

  Future<void> _loadPosition(String mediaId) async {
    final startPosition =
        await dataManager.getPosition(context.getIdFromUrl(mediaId));

    if (startPosition != Duration.zero) {
      context.upcomingPlaybackSettings =
          context.upcomingPlaybackSettings.copyWith(position: startPosition);
    }
  }

  @override
  Future<void> onTaskRemoved() => onClose();

  @override
  Future<void> onClose() =>
      _endTaskAtPosition(context.playBackState.currentPosition);

  Future<void> _endTaskAtPosition(Duration position) async {
    await dataManager
        .setPosition(Position(id: context.mediaItem.id, position: position));

    IsolateNameServer.removePortNameMapping(SendPortID);
    _receivePort.close();
    subscription.cancel();
    await dataManager.close();

    await super.onStop();
  }

  /// Send the correct response according to the message that we recieved from
  /// the UI isolate.
  /// The first item in the list will always be a [SendPort].
  /// The second is the name of the command, for example [GetPositionsCommand].
  Future<void> _answerPortMessage(List<dynamic> message) async {
    await _readyToAnswerMessages.future;

    final sendPort = message[0] as SendPort;
    final command = message[1] as String;

    switch (command) {
      case GetPositionsCommand:

        /// The final arguments are the IDs to retrieve.
        final idsToGetPositionOf = (message[2] as List<dynamic>).cast<String>();
        final sendablePositions = (await dataManager
                .getPositions(idsToGetPositionOf))
            .map((position) => [position.id, position.position.inMilliseconds])
            .toList();
        sendPort.send(sendablePositions);
        break;
      case SetPositionCommand:

        /// The final arguments are the ID and position to set.
        final idToSet = message[2] as String;
        final position = Position(
            id: idToSet, position: Duration(milliseconds: message[3] as int));
        await dataManager.setPosition(position);
        break;
    }
  }
}
