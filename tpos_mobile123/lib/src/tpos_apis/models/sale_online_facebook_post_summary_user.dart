import 'package:flutter/material.dart';

class SaleOnlineFacebookPostSummaryUser {
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
      availableInsertPartners = new List<AvailableInsertPartners>();
      json['AvailableInsertPartners'].forEach((v) {
        availableInsertPartners.add(new AvailableInsertPartners.fromJson(v));
      });
    }
    if (json['Users'] != null) {
      users = new List<Users>();
      json['Users'].forEach((v) {
        users.add(new Users.fromJson(v));
      });
    }
    post = json['Post'] != null ? new Post.fromJson(json['Post']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['@odata.context'] = this.odataContext;
    data['Id'] = this.id;
    data['CountComment'] = this.countComment;
    data['CountUserComment'] = this.countUserComment;
    data['CountShare'] = this.countShare;
    data['CountUserShare'] = this.countUserShare;
    data['CountOrder'] = this.countOrder;
    if (this.availableInsertPartners != null) {
      data['AvailableInsertPartners'] =
          this.availableInsertPartners.map((v) => v.toJson()).toList();
    }
    if (this.users != null) {
      data['Users'] = this.users.map((v) => v.toJson()).toList();
    }
    if (this.post != null) {
      data['Post'] = this.post.toJson();
    }
    return data;
  }
}

class AvailableInsertPartners {
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['FacebookAvatar'] = this.facebookAvatar;
    data['FacebookName'] = this.facebookName;
    data['FacebookUserId'] = this.facebookUserId;
    data['FacebookASUserId'] = this.facebookASUserId;
    data['Phone'] = this.phone;
    data['Email'] = this.email;
    data['Note'] = this.note;
    data['HasExisted'] = this.hasExisted;
    data['PhoneExisted'] = this.phoneExisted;
//    if (this.otherPhones != null) {
//      data['OtherPhones'] = this.otherPhones.map((v) => v.toJson()).toList();
//    }
    data['Address'] = this.address;
    return data;
  }
}

class Users {
  String id;
  String uId;
  String name;
  String picture;
  int countShare;
  int countComment;
  bool hasOrder;
  List<int> numbers = <int>[];
  NetworkImage image;

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['UId'] = this.uId;
    data['Name'] = this.name;
    data['Picture'] = this.picture;
    data['CountShare'] = this.countShare;
    data['CountComment'] = this.countComment;
    data['HasOrder'] = this.hasOrder;
    return data;
  }
}

class Post {
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['facebook_id'] = this.facebookId;
    data['message'] = this.message;
    data['source'] = this.source;
    data['story'] = this.story;
    data['description'] = this.description;
    data['link'] = this.link;
    data['caption'] = this.caption;
    data['picture'] = this.picture;
    data['full_picture'] = this.fullPicture;
    data['LiveCampaignId'] = this.liveCampaignId;
    data['LiveCampaignName'] = this.liveCampaignName;
    data['created_time'] = this.createdTime?.toString();
    return data;
  }
}
