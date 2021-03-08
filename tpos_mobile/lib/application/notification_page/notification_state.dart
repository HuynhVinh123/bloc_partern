import 'package:flutter/cupertino.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

abstract class NotificationState {}

class NotificationUnInitial extends NotificationState {}

class NotificationLoadSuccess extends NotificationState {
  NotificationLoadSuccess(
      {this.popupRead = false, @required this.notificationResult});
  final GetNotificationResult notificationResult;
  final bool popupRead;
}

class NotificationLoadFailure extends NotificationState {
  NotificationLoadFailure(this.message);
  final String message;
}

class NotificationLoading extends NotificationState {}
