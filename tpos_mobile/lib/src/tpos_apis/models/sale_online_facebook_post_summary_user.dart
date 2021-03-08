import 'package:flutter/material.dart';

class SaleOnlineFacebookPostSummaryUser {
  SaleOnlineFacebookPostSummaryUser({
    this.odataContext,
    this.id,
    this.countComment,
    this.countUserComment,
    this.countShare,
    this.countUserShare,
    this.countOrder,
    this.availableInsertPartners,
    this.users,
    this.post,
  });

  SaleOnlineFacebookPostSummaryUser.fromJson(Map<String, dynamic> json) {
    odataContext = json['@odata.context'];
    id = json['Id'];
    countComment = json['CountComment'];
    countUserComment = json['CountUserComment'];
    countShare = json['CountShare'];
    countUserShare = json['CountUserShare'];
    countOrder = json['CountOrder'];
    if (json['AvailableInsertPartners'] != null) {
      availableInsertPartners = <AvailableInsertPartners>[];
      json['AvailableInsertPartners'].forEach((v) {
        availableInsertPartners.add(AvailableInsertPartners.fromJson(v));
      });
    }
    if (json['Users'] != null) {
      users = <Users>[];
      json['Users'].forEach((v) {
        users.add(Users.fromJson(v));
      });
    }
    post = json['Post'] != null ? Post.fromJson(json['Post']) : null;
  }

  String odataContext;
  String id;
  int countComment;
  int countUserComment;
  int countShare;
  int countUserShare;
  int countOrder;
  List<AvailableInsertPartners> availableInsertPartners;
  List<Users> users;
  Post post;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['@odata.context'] = odataContext;
    data['Id'] = id;
    data['CountComment'] = countComment;
    data['CountUserComment'] = countUserComment;
    data['CountShare'] = countShare;
    data['CountUserShare'] = countUserShare;
    data['CountOrder'] = countOrder;
    if (availableInsertPartners != null) {
      data['AvailableInsertPartners'] =
          availableInsertPartners.map((v) => v.toJson()).toList();
    }
    if (users != null) {
      data['Users'] = users.map((v) => v.toJson()).toList();
    }
    if (post != null) {
      data['Post'] = post.toJson();
    }
    return data;
  }
}

class AvailableInsertPartners {
  AvailableInsertPartners(
      {this.name,
      this.facebookAvatar,
      this.facebookName,
      this.facebookUserId,
      this.facebookASUserId,
      this.phone,
      this.email,
      this.note,
      this.hasExisted,
      this.phoneExisted,
      this.address});

  AvailableInsertPartners.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    facebookAvatar = json['FacebookAvatar'];
    facebookName = json['FacebookName'];
    facebookUserId = json['FacebookUserId'];
    facebookASUserId = json['FacebookASUserId'];
    phone = json['Phone'];
    email = json['Email'];
    note = json['Note'];
    hasExisted = json['HasExisted'];
    phoneExisted = json['PhoneExisted'];
//    if (json['OtherPhones'] != null) {
//      otherPhones = new List<Null>();
//      json['OtherPhones'].forEach((v) {
//        otherPhones.add(new Null.fromJson(v));
//      });
//    }
    address = json['Address'];
  }
  String name;
  String facebookAvatar;
  String facebookName;
  String facebookUserId;
  String facebookASUserId;
  String phone;
  String email;
  String note;
  bool hasExisted;
  bool phoneExisted;
//  List<Null> otherPhones;
  String address;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Name'] = name;
    data['FacebookAvatar'] = facebookAvatar;
    data['FacebookName'] = facebookName;
    data['FacebookUserId'] = facebookUserId;
    data['FacebookASUserId'] = facebookASUserId;
    data['Phone'] = phone;
    data['Email'] = email;
    data['Note'] = note;
    data['HasExisted'] = hasExisted;
    data['PhoneExisted'] = phoneExisted;
//    if (this.otherPhones != null) {
//      data['OtherPhones'] = this.otherPhones.map((v) => v.toJson()).toList();
//    }
    data['Address'] = address;
    return data;
  }
}

class Users {
  Users(
      {this.id,
      this.uId,
      this.name,
      this.picture,
      this.countShare,
      this.countComment,
      this.hasOrder,
      this.numbers,
      this.image});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    uId = json['UId'];
    name = json['Name'];
    picture = json['Picture'];
    countShare = json['CountShare'];
    countComment = json['CountComment'];
    hasOrder = json['HasOrder'];
  }
  String id;
  String uId;
  String name;
  String picture;
  int countShare;
  int countComment;
  bool hasOrder;
  List<int> numbers = <int>[];
  NetworkImage image;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['UId'] = uId;
    data['Name'] = name;
    data['Picture'] = picture;
    data['CountShare'] = countShare;
    data['CountComment'] = countComment;
    data['HasOrder'] = hasOrder;
    return data;
  }
}

class Post {
  Post(
      {this.id,
      this.facebookId,
      this.message,
      this.source,
      this.story,
      this.description,
      this.link,
      this.caption,
      this.picture,
      this.fullPicture,
      this.liveCampaignId,
      this.liveCampaignName,
      this.createdTime});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    facebookId = json['facebook_id'];
    message = json['message'];
    source = json['source'];
    story = json['story'];
    description = json['description'];
    link = json['link'];
    caption = json['caption'];
    picture = json['picture'];
    fullPicture = json['full_picture'];
    liveCampaignId = json['LiveCampaignId'];
    liveCampaignName = json['LiveCampaignName'];
    createdTime = DateTime.parse(json['created_time']);
  }
  String id;
  String facebookId;
  String message;
  String source;
  String story;
  String description;
  String link;
  String caption;
  String picture;
  String fullPicture;
  String liveCampaignId;
  String liveCampaignName;
  DateTime createdTime;
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['facebook_id'] = facebookId;
    data['message'] = message;
    data['source'] = source;
    data['story'] = story;
    data['description'] = description;
    data['link'] = link;
    data['caption'] = caption;
    data['picture'] = picture;
    data['full_picture'] = fullPicture;
    data['LiveCampaignId'] = liveCampaignId;
    data['LiveCampaignName'] = liveCampaignName;
    data['created_time'] = createdTime?.toString();
    return data;
  }
}
