import 'package:tpos_api_client/tpos_api_client.dart';

class ConversationComment {
  ConversationComment(
      {this.message,
      this.messageFormat,
      this.postId,
      this.parentId,
      this.post,
      this.from,
      this.createdTime,
      this.id});
  ConversationComment.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    messageFormat = json['message_format'];
    postId = json['post_id'];
    parentId = json['parent_id'];
    post = json['post'] != null ? PostExtras.fromJson(json['post']) : null;
    from =
        json['from'] != null ? AssignedToFacebook.fromJson(json['from']) : null;
    createdTime = json['created_time'];
    id = json['id'];
  }
  String message;
  String messageFormat;
  String postId;
  String parentId;
  PostExtras post;
  AssignedToFacebook from;
  String createdTime;
  String id;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['message'] = message;
    data['message_format'] = messageFormat;
    data['post_id'] = postId;
    data['parent_id'] = parentId;
    if (post != null) {
      data['post'] = post.toJson();
    }
    if (from != null) {
      data['from'] = from.toJson();
    }
    data['created_time'] = createdTime;
    data['id'] = id;
    return data;
  }
}
