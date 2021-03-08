import 'package:tpos_api_client/src/models/entities/tag_status_facebook.dart';
import 'package:tpos_api_client/src/models/entities/tpos_message.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

import '../tpos_facebook_activity.dart';

class Conversation {
  Conversation.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    assignedToId = json['assigned_to_id'];
    countUnreadActivities = json['count_unread_activities'] != null
        ? double.parse(json['count_unread_activities'].toString())
        : 0;
    countUnreadComments = json['count_unread_comments'] != null
        ? double.parse(json['count_unread_comments'].toString())
        : 0;
    countUnreadMessages = json['count_unread_messages'] != null
        ? double.parse(json['count_unread_messages'].toString())
        : 0;
    if (json['DateCreated'] != null) {
      dateCreated = DateTime.parse(json['DateCreated']);
    }
    hasAddress = json['has_address'];
    hasOrder = json['has_order'];
    hasPhone = json['has_phone'];
    id = json['id'];
    name = json['name'];
    partnerId = json['partner_id'];
    if (json['LastUpdated'] != null) {
      lastUpdated = DateTime.parse(json['LastUpdated']);
    }
    pageId = json['page_id'];
    phone = json['phone'];
    psid = json['psid'];
    message = json['message'];
    if (json['last_message_received_time'] != null) {
      lastMessageReceivedTime =
          DateTime.parse(json['last_message_received_time']);
    }

    if (json['from'] != null) {
      facebookTposUser = TPosFacebookUser.fromJson(json['from']);
    }
    if (json['last_activity'] != null) {
      lastActivity = TPosFacebookActivity.fromJson(json['last_activity']);
    }
    if (json['tags'] != null) {
      tags = <TagStatusFacebook>[];
      json['tags'].forEach((dynamic v) {
        tags.add(TagStatusFacebook.fromJson(v));
      });
    }
    if (json['last_activity'] != null) {
      lastActivity = TPosFacebookActivity.fromJson(json['last_activity']);
    }
    if (json['last_comment'] != null) {
      lastComment = TPosFacebookComment.fromMap(json['last_comment']);
    }
    if (json['assigned_to'] != null) {
      assignedToFacebook = ApplicationUser.fromJson(json['assigned_to']);
    }
    if (json['last_message'] != null) {
      lastMessage = TposMessage.fromJson(json['last_message']);
    }
    if (json['CreatedBy'] != null) {
      createdBy = TPosFacebookUser.fromJson(json['CreatedBy']);
    }
  }
  String address;
  String assignedToId;

  DateTime dateCreated;
  bool hasAddress;
  bool hasOrder;
  bool hasPhone;
  double countUnreadActivities;
  double countUnreadComments;
  double countUnreadMessages;

  String id;
  DateTime lastUpdated;
  String name;
  String pageId;
  String phone;
  String psid;
  DateTime lastMessageReceivedTime;
  TPosFacebookUser facebookTposUser;
  TPosFacebookActivity lastActivity;
  TPosFacebookComment lastComment;
  TposMessage lastMessage;
  List<TagStatusFacebook> tags = [];
  ApplicationUser assignedToFacebook;
  int partnerId;
  TPosFacebookUser createdBy;

  ///notes
  String message;
  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['address'] = address;
    data['assigned_to_id'] = assignedToId;
    data['count_unread_activities'] = countUnreadActivities;
    data['count_unread_comments'] = countUnreadComments;
    data['count_unread_messages'] = countUnreadMessages;
    data['DateCreated'] = dateCreated?.toIso8601String();
    data['has_address'] = hasAddress;
    data['has_order'] = hasOrder;
    data['has_phone'] = hasPhone;
    data['partner_id'] = partnerId;
    data['id'] = id;
    data['Name'] = name;
    data['CreatedBy'] = data['CreatedBy'] != null ? createdBy.toJson() : null;
    data['LastUpdated'] = lastUpdated?.toIso8601String();
    data['last_comment'] = lastComment;
    data['page_id'] = pageId;
    data['phone'] = phone;
    data['psid'] = psid;
    data['from'] = data['from'] != null ? facebookTposUser.toJson() : null;
    data['last_activity'] =
        data['last_activity'] != null ? lastActivity.toJson() : null;
    data['last_message_received_time'] =
        lastMessageReceivedTime?.toIso8601String();
    data['assigned_to'] =
        data['assigned_to'] != null ? assignedToFacebook.toJson() : null;
    data['tags'] = tags?.map((f) => f.toJson())?.toList();
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
