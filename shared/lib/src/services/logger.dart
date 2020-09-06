import 'dev_logger.dart';
import 'models/log_event.dart';

ILogger logger = DevLogger();

abstract class ILogger {
  factory ILogger() => logger;

  List<LogEvent> get logs;
  Stream<LogEvent> get logStream;
  void log(LogEvent event);
  void error(String message, Object error, [StackTrace strackTrace]);
  void info(String message);
  void warning(String message, [Object data]);
  void verbose(String message, [Object data]);
}
