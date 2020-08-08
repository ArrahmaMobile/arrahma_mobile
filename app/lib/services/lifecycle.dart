import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'logger.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  factory LifecycleEventHandler(
      {@required Type type,
      AsyncCallback onResume,
      AsyncCallback onSuspend,
      @required bool isSingleton}) {
    final handler = LifecycleEventHandler._instance(
        type: type,
        resumeCallBack: onResume,
        suspendingCallBack: onSuspend,
        isSingleton: isSingleton);
    if (type != null && isSingleton) {
      handlerMap[type]?.dispose();
      handlerMap[type] = handler;
    }

    WidgetsBinding.instance.addObserver(handler);
    logger.verbose('[${handler.runtimeType}] $type: Initialized.');
    return handler;
  }

  LifecycleEventHandler._instance({
    this.isSingleton,
    this.type,
    this.resumeCallBack,
    this.suspendingCallBack,
  });

  static Map<Type, LifecycleEventHandler> handlerMap = {};

  final bool isSingleton;
  final Type type;
  final AsyncCallback resumeCallBack;
  final AsyncCallback suspendingCallBack;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (resumeCallBack != null) {
          await resumeCallBack();
        }
        break;
      case AppLifecycleState.detached:
        if (suspendingCallBack != null) {
          await suspendingCallBack();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        break;
    }
    logger.verbose('[$runtimeType] $type: $state.');
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (type != null && isSingleton) handlerMap.remove(type);
    logger.verbose('[$runtimeType] $type: Disposed.');
  }
}
