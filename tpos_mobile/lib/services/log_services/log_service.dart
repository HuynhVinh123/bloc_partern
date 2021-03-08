import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart' as logger_package;
import 'package:logger/logger.dart';
import 'package:logging/logging.dart' as logging_package;

abstract class LogService {
  void info(Object message);
  void warning(Object message);
  void error(Object message, Object error, Object stackTrade);
  void debug(Object message);

  bool get enableSendErrorToServer;
  bool get enableSendExceptionToServer;
}

class MyLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    event.lines.forEach((element) {
      debugPrint(element);
    });
  }
}

class LoggerLogService extends LogService {
  LoggerLogService();

  var logger = logger_package.Logger(
    filter: logger_package.DevelopmentFilter(),
    output: MyLogOutput(),
    printer: logger_package.PrefixPrinter(logger_package.PrettyPrinter()),
  );

  @override
  void debug(Object message) {
    logger.d(message);
  }

  @override
  void error(Object message, Object error, Object stackTrade) {
    logger.e(message, error, stackTrade);
  }

  @override
  void info(Object message) {
    logger.i(message);
  }

  @override
  void warning(Object message) {
    logger.w(message);
  }

  @override
  bool get enableSendErrorToServer => true;

  @override
  bool get enableSendExceptionToServer => true;
}

class LoggingLogService extends LogService {
  LoggingLogService() {
    logging_package.Logger.root.level = logging_package.Level.ALL;
    logging_package.Logger.root.onRecord.listen((log) {
      print("${log.loggerName} | ${log.message}");
      if (log.error != null) print(log.error);
      if (log.stackTrace != null) print(log.stackTrace);
    });
  }
  @override
  void debug(Object message) {
    logging_package.Logger.root.fine(message);
  }

  @override
  void error(Object message, Object error, Object stackTrade) {
    logging_package.Logger.root.severe(message, error, stackTrade);
  }

  @override
  void info(Object message) {
    logging_package.Logger.root.info(message);
  }

  @override
  void warning(Object message) {
    logging_package.Logger.root.warning(message);
  }

  @override
  bool get enableSendErrorToServer => true;

  @override
  bool get enableSendExceptionToServer => true;
}
