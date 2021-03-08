import 'package:tpos_api_client/src/model.dart';

class TPosFacebookActivity {
  TPosFacebookActivity({
    this.createdTime,
    this.fromId,
    this.comment,
    this.message,
    this.updatedTime,
    this.id,
    this.lastUpdated,
  });

  TPosFacebookActivity.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (time != null) {
      time = DateTime.parse(json['time']);
    }
    if (json['attachments'] != null) {
      attachment = Attachment.fromJson(json['attachments']);
    }
    messageFormat = json['message_format'];
    fromId = json['from_id'];
    if (updatedTime != null) {
      updatedTime = DateTime.parse(json['updated_time']);
    }
    if (createdTime != null) {
      createdTime = DateTime.parse(json['created_time']);
    }
    id = json['id'];
    message = json['message'];
    if (json['from'] != null) {
      from = TPosFacebookUser.fromJson(json['from']);
    }
  }
  TPosFacebookComment comment;
  TPosFacebookUser from;
  DateTime createdTime;
  String fromId;
  String id;
  String message;
  int type;
  DateTime time;
  String messageFormat;
  DateTime updatedTime;
  DateTime lastUpdated;
  Attachment attachment;
  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "time": time.toIso8601String(),
      "created_time": createdTime?.toIso8601String(),
      "message_format": messageFormat,
      "from_id": fromId,
      "attachments": attachment,
      "updated_time": updatedTime,
      "id": id,
      "message": message,
      "from": from.toJson(),
    }..removeWhere((key, value) => value == null);
  }
}
