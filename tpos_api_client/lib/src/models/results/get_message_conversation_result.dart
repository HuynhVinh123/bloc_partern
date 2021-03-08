import 'package:tpos_api_client/src/models/entities/message_conversation.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

class GetMessageConversationResult {
  GetMessageConversationResult.fromJson(Map<String, dynamic> json) {
    totalCount = json['TotalCount'] != null
        ? double.parse(json['TotalCount']?.toString())
        : 0;

    totalPages = json['TotalPages'] != null
        ? double.parse(json['TotalPages']?.toString())
        : 0;
    hasNextPage = json['HasNextPage'];
    hasPreviousPage = json['HasPreviousPage'];
    if (json['Items'] != null && json['Items'] is List) {
      items = (json['Items'] as List<dynamic>)
          .map((dynamic f) => MessageConversation.fromJson(f))
          .toList();
    }
    if (json['Extras'] != null) {
      extras = Extras.fromJson(json['Extras']);
    }
  }
  bool hasNextPage;
  bool hasPreviousPage;
  double totalCount;
  double totalPages;
  List<MessageConversation> items;
  Extras extras;
}

class Extras {
  Extras({this.posts});
  Extras.fromJson(Map<String, dynamic> json) {
    if (json['posts'] != null) {
      posts = (json['posts'] as Map<String, dynamic>)
          .map((k, e) => MapEntry(
              k,
              e == null
                  ? null
                  : PostExtras.fromJson(e as Map<String, dynamic>)))
          .values
          .toList();
    }
  }
  List<PostExtras> posts;
}

class PostExtras {
  PostExtras(
      {this.dateCreated,
      this.lastUpdated,
      this.pageId,
      this.message,
      this.story,
      this.type,
      this.statusType,
      this.promotionStatus,
      this.picture,
      this.fullPicture,
      this.permalinkUrl,
      this.isExpired,
      this.isHidden,
      this.isPublished,
      this.isSpherical,
      this.attachments,
      this.countComments,
      this.countReactions,
      this.countShares,
      this.updatedTime,
      this.createdTime,
      this.id});
  PostExtras.fromJson(Map<String, dynamic> json) {
    if (json['created_time'] != null) {
      createdTime = DateTime.parse(json['created_time']);
    }
    if (json['DateCreated'] != null) {
      dateCreated = DateTime.parse(json['DateCreated']);
    }
    if (json['LastUpdated'] != null) {
      lastUpdated = DateTime.parse(json['LastUpdated']);
    }
    if (json['updated_time'] != null) {
      updatedTime = DateTime.parse(json['updated_time']);
    }
    pageId = json['page_id'];
    message = json['message'];
    story = json['story'];
    type = json['type'];
    statusType = json['status_type'];
    promotionStatus = json['promotion_status'];
    picture = json['picture'];
    fullPicture = json['full_picture'];
    permalinkUrl = json['permalink_url'];
    isExpired = json['is_expired'];
    isHidden = json['is_hidden'];
    isPublished = json['is_published'];
    isSpherical = json['is_spherical'];
    countComments = json['count_comments'];
    countReactions = json['count_reactions'];
    countShares = json['count_shares'];

    id = json['id'];
  }
  DateTime dateCreated;
  DateTime lastUpdated;
  String pageId;
  String message;
  String story;
  String type;
  String statusType;
  String promotionStatus;
  String picture;
  String fullPicture;
  String permalinkUrl;
  bool isExpired;
  bool isHidden;
  bool isPublished;
  bool isSpherical;
  AttachmentPost attachments;
  int countComments;
  int countReactions;
  int countShares;
  DateTime updatedTime;
  DateTime createdTime;
  String id;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['DateCreated'] = dateCreated.toIso8601String();
    data['LastUpdated'] = lastUpdated.toIso8601String();
    data['page_id'] = pageId;
    data['message'] = message;
    data['story'] = story;
    data['type'] = type;
    data['status_type'] = statusType;
    data['promotion_status'] = promotionStatus;
    data['picture'] = picture;
    data['full_picture'] = fullPicture;
    data['permalink_url'] = permalinkUrl;
    data['is_expired'] = isExpired;
    data['is_hidden'] = isHidden;
    data['is_published'] = isPublished;
    data['is_spherical'] = isSpherical;
    if (attachments != null) {
      data['attachments'] = attachments.toJson();
    }
    data['count_comments'] = countComments;
    data['count_reactions'] = countReactions;
    data['count_shares'] = countShares;
    data['updated_time'] = updatedTime.toIso8601String();
    data['created_time'] = createdTime.toIso8601String();
    data['id'] = id;
    return data;
  }
}

class AttachmentPost {
  AttachmentPost({this.data});
  AttachmentPost.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(DataAttachment.fromJson(v));
      });
    }
  }
  List<DataAttachment> data;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataAttachment {
  DataAttachment({this.media, this.target, this.type, this.url});
  DataAttachment.fromJson(Map<String, dynamic> json) {
    media = json['media'] != null ? Media.fromJson(json['media']) : null;
    target = json['target'] != null ? Target.fromJson(json['target']) : null;
    type = json['type'];
    url = json['url'];
  }
  Media media;
  Target target;
  String type;
  String url;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (media != null) {
      data['media'] = media.toJson();
    }

    if (target != null) {
      data['target'] = target.toJson();
    }
    data['type'] = type;
    data['url'] = url;
    return data;
  }
}

class Media {
  Media({this.image, this.source});
  Media.fromJson(Map<String, dynamic> json) {
    image = json['image'] != null ? ImageMedia.fromJson(json['image']) : null;
    source = json['source'];
  }
  ImageMedia image;
  String source;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (image != null) {
      data['image'] = image.toJson();
    }
    data['source'] = source;
    return data;
  }
}

class ImageMedia {
  ImageMedia({this.height, this.src, this.width});
  ImageMedia.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    src = json['src'];
    width = json['width'];
  }
  int height;
  String src;
  int width;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['height'] = height;
    data['src'] = src;
    data['width'] = width;
    return data;
  }
}

class Target {
  Target({this.id, this.url});
  Target.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
  }
  String id;
  String url;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['url'] = url;
    return data;
  }
}
