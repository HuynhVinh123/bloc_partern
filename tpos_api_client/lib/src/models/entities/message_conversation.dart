import 'package:tpos_api_client/src/models/entities/conversation_comment.dart';
import 'package:tpos_api_client/src/models/tpos_facebook_activity.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

class MessageConversation {
  MessageConversation(
      {this.dateCreated,
      this.createdTime,
      this.fromId,
      this.id,
      this.message,
      this.fbid,
      this.lastUpdated,
      this.createdBy,
      this.comment,
      this.messageFormat});
  MessageConversation.fromJson(Map<String, dynamic> json) {
    if (json['DateCreated'] != null) {
      dateCreated = DateTime.parse(json['DateCreated']);
    }
    fromId = json['from_id'];
    if (json['created_time'] != null) {
      createdTime = DateTime.parse(json['created_time']);
    }
    id = json['id'];
    fbid = json['fbid'];
    if (json['LastUpdated'] != null) {
      lastUpdated = DateTime.parse(json['LastUpdated']);
    }
    if (json['message'] != null) {
      message = TPosFacebookActivity.fromJson(json['message']);
    }
    if (json['CreatedBy'] != null) {
      createdBy = TPosFacebookUser.fromJson(json['CreatedBy']);
    }

    if (json['comment'] != null) {
      comment = ConversationComment.fromJson(json['comment']);
    }
    if (json['message_format'] != null) {
      messageFormat = json['message_format'];
    }
  }

  DateTime dateCreated;
  DateTime createdTime;
  String fromId;
  String id;
  String messageFormat;
  TPosFacebookActivity message;
  TPosFacebookUser createdBy;
  String fbid;
  DateTime lastUpdated;
  ConversationComment comment;
  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['comment'] = data['comment'] != null ? comment.toJson() : null;
    data['from_id'] = fromId;
    data['created_time'] = createdTime?.toIso8601String();
    data['id'] = id;
    data['fbid'] = fbid;
    data['CreatedBy'] = createdBy;
    data['message'] = data['message'] != null ? message.toJson() : null;
    data['LastUpdated'] = lastUpdated?.toIso8601String();

    data['message_format'] = messageFormat;
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
