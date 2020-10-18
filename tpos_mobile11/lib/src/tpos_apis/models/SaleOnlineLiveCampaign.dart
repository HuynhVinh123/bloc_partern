/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

class SaleOnlineLiveCampaign {
  String id,
      name,
      facebookUserId,
      facebookUserName,
      facebookUserAvatar,
      facebookLiveId,
      note;
  bool isActive;
  DateTime dateCreated;

  SaleOnlineLiveCampaign(
      {this.id,
      this.name,
      this.facebookUserId,
      this.facebookUserName,
      this.facebookUserAvatar,
      this.facebookLiveId,
      this.note,
      this.isActive,
      this.dateCreated});

  factory SaleOnlineLiveCampaign.fromMap(Map<String, dynamic> jsonMap) {
    return new SaleOnlineLiveCampaign(
      id: jsonMap["Id"],
      name: jsonMap["Name"],
      facebookUserId: jsonMap["Facebook_UserId"],
      facebookUserName: jsonMap["Facebook_UserName"],
      facebookUserAvatar: jsonMap["Facebook_UserAvatar"],
      facebookLiveId: jsonMap["Facebook_LiveId"],
      note: jsonMap["Note"],
      isActive: jsonMap["IsActive"],
      dateCreated: DateTime.parse(jsonMap["DateCreated"]),
    );
  }
}
