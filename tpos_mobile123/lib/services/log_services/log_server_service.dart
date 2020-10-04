import 'dart:collection';

abstract class LogServerService {
  Future<void> sendCrashToServer(
      {String userId, dynamic error, dynamic stackTrade});
}

class SentryLogService extends LogServerService {
  Queue<ErrorMessage> _jobQueue = new Queue();

  @override
  Future<void> sendCrashToServer(
      {String userId, dynamic error, dynamic stackTrade}) {
    // TODO: implement sendCrashToServer
    _jobQueue.add(ErrorMessage(error: error, stackTrade: stackTrade));
    _jobQueue.forEach((f) {
      //send and send
    });
    return null;
  }
}

class CrashlyticLogService extends LogServerService {
  @override
  Future<void> sendCrashToServer(
      {String userId, dynamic error, dynamic stackTrade}) {
    // TODO: implement sendCrashToServer
    return null;
  }
}

class ErrorMessage {
  DateTime dateCreated;
  String message;
  dynamic error;
  dynamic stackTrade;

  ErrorMessage({this.message, this.error, this.stackTrade}) {
    dateCreated = DateTime.now();
  }
}
