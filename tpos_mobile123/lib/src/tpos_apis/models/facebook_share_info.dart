import 'package:tpos_mobile/src/facebook_apis/facebook_api.dart';

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
    from = json['from'] != null ? new FacebookUser.fromMap(json['from']) : null;
    createdTime = json['created_time'];
    updatedTime = json['updated_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['story'] = this.story;
    data['caption'] = this.caption;
    data['description'] = this.description;
    data['link'] = this.link;
    data['message'] = this.message;
    data['name'] = this.name;
    data['picture'] = this.picture;
    data['permalink_url'] = this.permalinkUrl;
    data['source'] = this.source;
    data['status_type'] = this.statusType;
    data['parent_id'] = this.parentId;
    data['object_id'] = this.objectId;
    if (this.from != null) {
      data['from'] = this.from.toMap(removeNullValue: true);
    }
    data['created_time'] = this.createdTime;
    data['updated_time'] = this.updatedTime;
    return data;
  }
}
