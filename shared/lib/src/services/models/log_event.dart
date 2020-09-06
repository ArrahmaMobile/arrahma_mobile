enum LogLevel { Verbose, Info, Warning, Error }

class LogEvent {
  const LogEvent(
      {this.level, this.time, this.message, this.data, this.stackTrace});
  factory LogEvent.from({LogLevel level, String message}) {
    return LogEvent(level: level, message: message, time: DateTime.now());
  }
  final LogLevel level;
  final DateTime time;
  final String message;
  final Object data;
  final String stackTrace;
}
