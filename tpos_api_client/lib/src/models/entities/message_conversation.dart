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
      this.attachments});
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
    if (json['attachments'] != null) {
      attachments = Attachment.fromJson(json['attachments']);
    }
  }

  DateTime dateCreated;
  DateTime createdTime;
  String fromId;
  String id;
  TPosFacebookActivity message;
  TPosFacebookUser createdBy;
  String fbid;
  DateTime lastUpdated;
  Attachment attachments;
  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['from_id'] = fromId;
    data['created_time'] = createdTime?.toIso8601String();
    data['id'] = id;
    data['fbid'] = fbid;
    data['CreatedBy'] = createdBy;
    data['message'] = data['message'] != null ? message.toJson() : null;
    data['LastUpdated'] = lastUpdated?.toIso8601String();
    data['attachments'] = attachments;
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
