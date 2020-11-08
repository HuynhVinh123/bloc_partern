import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart' as loggerPackage;
import 'package:logger/logger.dart';
import 'package:logging/logging.dart' as loggingPackage;

import '../../locator.dart';
import 'log_server_service.dart';

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
    for (var line in event.lines) {
      debugPrint(line);
    }
  }
}

class LoggerLogService extends LogService {
  LogServerService _logServerService;
  LoggerLogService({LogServerService logServer}) {
    _logServerService = logServer ?? locator<LogServerService>();
  }

  var logger = new loggerPackage.Logger(
    filter: loggerPackage.DevelopmentFilter(),
    output: MyLogOutput(),
    printer: loggerPackage.PrefixPrinter(loggerPackage.PrettyPrinter()),
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
    loggingPackage.Logger.root.level = loggingPackage.Level.ALL;
    loggingPackage.Logger.root.onRecord.listen((log) {
      print("${log.loggerName} | ${log.message}");
      if (log.error != null) print(log.error);
      if (log.stackTrace != null) print(log.stackTrace);
    });
  }
  @override
  void debug(Object message) {
    loggingPackage.Logger.root.fine(message);
  }

  @override
  void error(Object message, Object error, Object stackTrade) {
    loggingPackage.Logger.root.severe(message, error, stackTrade);
  }

  @override
  void info(Object message) {
    loggingPackage.Logger.root.info(message);
  }

  @override
  void warning(Object message) {
    loggingPackage.Logger.root.warning(message);
  }

  @override
  bool get enableSendErrorToServer => true;

  @override
  bool get enableSendExceptionToServer => true;
}
