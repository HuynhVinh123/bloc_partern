import 'package:facebook_api_client/facebook_api_client.dart';

class FacebookShareInfo {
  String id;
  dynamic story;
  String caption;
  String description;
  String link;
  String message;
  String name;
  dynamic picture;
  String permalinkUrl;
  dynamic source;
  String statusType;
  String parentId;
  String objectId;
  FacebookUser from;
  String createdTime;
  String updatedTime;

  FacebookShareInfo(
      {this.id,
      this.story,
      this.caption,
      this.description,
      this.link,
      this.message,
      this.name,
      this.picture,
      this.permalinkUrl,
      this.source,
      this.statusType,
      this.parentId,
      this.objectId,
      this.from,
      this.createdTime,
      this.updatedTime});

  FacebookShareInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    story = json['story'];
    caption = json['caption'];
    description = json['description'];
    link = json['link'];
    message = json['message'];
    name = json['name'];
    picture = json['picture'];
    permalinkUrl = json['permalink_url'];
    source = json['source'];
    statusType = json['status_type'];
    parentId = json['parent_id'];
    objectId = json['object_id'];
    from = json['from'] != null ? FacebookUser.fromMap(json['from']) : null;
    createdTime = json['created_time'];
    updatedTime = json['updated_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['story'] = story;
    data['caption'] = caption;
    data['description'] = description;
    data['link'] = link;
    data['message'] = message;
    data['name'] = name;
    data['picture'] = picture;
    data['permalink_url'] = permalinkUrl;
    data['source'] = source;
    data['status_type'] = statusType;
    data['parent_id'] = parentId;
    data['object_id'] = objectId;
    if (from != null) {
      data['from'] = from.toMap(removeNullValue: true);
    }
    data['created_time'] = createdTime;
    data['updated_time'] = updatedTime;
    return data;
  }
}
