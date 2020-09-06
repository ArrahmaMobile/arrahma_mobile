import 'package:arrahma_shared/shared.dart';
import 'package:flutter/foundation.dart';

import 'lifecycle.dart';

abstract class StoppableService {
  LifecycleEventHandler _handler;

  @protected
  var _isStarted = false;

  bool get isActive => _isStarted;

  void _initHandler() {
    _handler ??= LifecycleEventHandler(
      isSingleton: true,
      type: runtimeType,
      onResume: () => start(),
      onSuspend: () => stop(),
    );
  }

  void _disposeHandler() {
    _handler?.dispose();
    _handler = null;
  }

  void init() {
    if (_isStarted) return;
    stop();
    _initHandler();
    start();
    logger.verbose('$runtimeType: Initialized.');
  }

  @mustCallSuper
  @protected
  Future<void> stop() {
    _isStarted = false;
    logger.verbose('$runtimeType: Stopped.');
    return null;
  }

  @mustCallSuper
  @protected
  Future<void> start() {
    _isStarted = true;
    logger.verbose('$runtimeType: Started.');
    return null;
  }

  @mustCallSuper
  @protected
  void dispose() {
    stop();
    _disposeHandler();
    logger.verbose('$runtimeType: Disposed.');
  }
}
