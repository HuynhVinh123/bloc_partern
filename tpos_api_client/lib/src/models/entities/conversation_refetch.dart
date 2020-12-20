import 'package:tpos_api_client/tpos_api_client.dart';

class ConversationRefetch {
  ConversationRefetch({this.conversation, this.activities});
  ConversationRefetch.fromJson(Map<String, dynamic> json) {
    conversation = json['conversation'] != null
        ? Conversation.fromJson(json['conversation'])
        : null;
    if (json['activities'] != null) {
      activities = [];
      json['activities'].forEach((v) {
        activities.add(MessageConversation.fromJson(v));
      });
    }
  }
  Conversation conversation;
  List<MessageConversation> activities;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (conversation != null) {
      data['conversation'] = conversation.toJson();
    }
    if (activities != null) {
      data['activities'] = activities.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
