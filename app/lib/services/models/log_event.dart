import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum LogLevel { Verbose, Info, Warning, Error }

const LogLevelColorMap = <LogLevel, Color>{
  LogLevel.Verbose: Colors.grey,
  LogLevel.Info: Colors.white,
  LogLevel.Warning: Colors.yellow,
  LogLevel.Error: Colors.red,
};

class LogEvent {
  const LogEvent(
      {@required this.level,
      @required this.time,
      @required this.message,
      this.data,
      this.stackTrace});
  factory LogEvent.from({@required LogLevel level, @required String message}) {
    return LogEvent(level: level, message: message, time: DateTime.now());
  }
  final LogLevel level;
  final DateTime time;
  final String message;
  final Object data;
  final String stackTrace;
}
