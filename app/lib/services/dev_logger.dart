import 'dart:async';
import 'dart:developer' as developer;

import 'package:arrahma_mobile_app/utils/date_utils.dart';
import 'package:arrahma_mobile_app/utils/wrap_list.dart';
import 'package:logging/logging.dart';

import 'logger.dart';
import 'models/log_event.dart';

class DevLogger implements ILogger {
  final _logs = WrapList<LogEvent>(100);
  @override
  List<LogEvent> get logs => _logs.list;

  final _logStreamController = StreamController<LogEvent>.broadcast();
  @override
  Stream<LogEvent> get logStream => _logStreamController.stream;

  static const LogLevelMap = <LogLevel, Level>{
    LogLevel.Verbose: Level.FINEST,
    LogLevel.Info: Level.INFO,
    LogLevel.Warning: Level.WARNING,
    LogLevel.Error: Level.SEVERE,
  };

  @override
  void log(LogEvent event) {
    logs.add(event);
    _logStreamController.add(event);
    developer.log(
      '[${DateUtils.formatReadableFixedLengthTime(event.time)}] ${event.message}',
      time: event.time,
      level: LogLevelMap[event.level].value,
      error: event.data,
      stackTrace: event.stackTrace != null
          ? StackTrace.fromString(event.stackTrace)
          : null,
    );
  }

  @override
  void error(String message, Object error, [StackTrace stackTrace]) {
    final event = LogEvent(
      message: message,
      data: error,
      stackTrace: stackTrace.toString(),
      time: DateTime.now(),
      level: LogLevel.Error,
    );
    log(event);
  }

  @override
  void info(String message) {
    final event = LogEvent(
      message: message,
      time: DateTime.now(),
      level: LogLevel.Info,
    );
    log(event);
  }

  @override
  void verbose(String message, [Object data]) {
    final event = LogEvent(
      message: message,
      data: data,
      time: DateTime.now(),
      level: LogLevel.Verbose,
    );
    log(event);
  }

  @override
  void warning(String message, [Object data]) {
    final event = LogEvent(
      message: message,
      data: data,
      time: DateTime.now(),
      level: LogLevel.Warning,
    );
    log(event);
  }
}
