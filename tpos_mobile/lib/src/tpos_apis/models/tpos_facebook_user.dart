/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

class TposFacebookUser {
  int id;
  String name;
  var zaloOAId;
  var zaloSecretKey;
  bool active;
  int companyId;
  var type;
  int countPage;
  int countGroup;
  String facebookUserId;
  String facebookASUserId;
  String facebookUserName;
  String facebookUserAvatar;
  var facebookUserCover;
  String facebookUserToken;
  String facebookUserPrivateToken;
  String facebookUserPrivateToken2;
  String facebookPagePrivateToken;
  String facebookPageId;
  String facebookPageName;
  String facebookPageLogo;
  String facebookPageCover;
  String facebookPageToken;
  bool isDefault;
  var facebookTokenExpired;
  String facebookTypeId;
  var parentId;
  var facebookConfigs;
  List<TposFacebookUserPage> childs;

  TposFacebookUser(
      {this.id,
      this.name,
      this.zaloOAId,
      this.zaloSecretKey,
      this.active,
      this.companyId,
      this.type,
      this.countPage,
      this.countGroup,
      this.facebookUserId,
      this.facebookASUserId,
      this.facebookUserName,
      this.facebookUserAvatar,
      this.facebookUserCover,
      this.facebookUserToken,
      this.facebookUserPrivateToken,
      this.facebookUserPrivateToken2,
      this.facebookPagePrivateToken,
      this.facebookPageId,
      this.facebookPageName,
      this.facebookPageLogo,
      this.facebookPageCover,
      this.facebookPageToken,
      this.isDefault,
      this.facebookTokenExpired,
      this.facebookTypeId,
      this.parentId,
      this.facebookConfigs,
      this.childs});

  TposFacebookUser.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    zaloOAId = json['ZaloOAId'];
    zaloSecretKey = json['ZaloSecretKey'];
    active = json['Active'];
    companyId = json['CompanyId'];
    type = json['Type'];
    countPage = json['CountPage'];
    countGroup = json['CountGroup'];
    facebookUserId = json['Facebook_UserId'];
    facebookASUserId = json['Facebook_ASUserId'];
    facebookUserName = json['Facebook_UserName'];
    facebookUserAvatar = json['Facebook_UserAvatar'];
    facebookUserCover = json['Facebook_UserCover'];
    facebookUserToken = json['Facebook_UserToken'];
    facebookUserPrivateToken = json['Facebook_UserPrivateToken'];
    facebookUserPrivateToken2 = json['Facebook_UserPrivateToken2'];
    facebookPagePrivateToken = json['Facebook_PagePrivateToken'];
    facebookPageId = json['Facebook_PageId'];
    facebookPageName = json['Facebook_PageName'];
    facebookPageLogo = json['Facebook_PageLogo'];
    facebookPageCover = json['Facebook_PageCover'];
    facebookPageToken = json['Facebook_PageToken'];
    isDefault = json['IsDefault'];
    facebookTokenExpired = json['Facebook_TokenExpired'];
    facebookTypeId = json['Facebook_TypeId'];
    parentId = json['ParentId'];
    facebookConfigs = json['Facebook_Configs'];
    if (json['Childs'] != null) {
      childs = new List<TposFacebookUserPage>();
      json['Childs'].forEach((v) {
        childs.add(new TposFacebookUserPage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson({bool removeNullValue = false}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['ZaloOAId'] = this.zaloOAId;
    data['ZaloSecretKey'] = this.zaloSecretKey;
    data['Active'] = this.active;
    data['CompanyId'] = this.companyId;
    data['Type'] = this.type;
    data['CountPage'] = this.countPage;
    data['CountGroup'] = this.countGroup;
    data['Facebook_UserId'] = this.facebookUserId;
    data['Facebook_ASUserId'] = this.facebookASUserId;
    data['Facebook_UserName'] = this.facebookUserName;
    data['Facebook_UserAvatar'] = this.facebookUserAvatar;
    data['Facebook_UserCover'] = this.facebookUserCover;
    data['Facebook_UserToken'] = this.facebookUserToken;
    data['Facebook_UserPrivateToken'] = this.facebookUserPrivateToken;
    data['Facebook_UserPrivateToken2'] = this.facebookUserPrivateToken2;
    data['Facebook_PagePrivateToken'] = this.facebookPagePrivateToken;
    data['Facebook_PageId'] = this.facebookPageId;
    data['Facebook_PageName'] = this.facebookPageName;
    data['Facebook_PageLogo'] = this.facebookPageLogo;
    data['Facebook_PageCover'] = this.facebookPageCover;
    data['Facebook_PageToken'] = this.facebookPageToken;
    data['IsDefault'] = this.isDefault;
    data['Facebook_TokenExpired'] = this.facebookTokenExpired;
    data['Facebook_TypeId'] = this.facebookTypeId;
    data['ParentId'] = this.parentId;
    data['Facebook_Configs'] = this.facebookConfigs;
    if (this.childs != null) {
      data['Childs'] = this.childs.map((v) => v.toJson()).toList();
    }
    if (removeNullValue) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}

class TposFacebookUserPage {
  int id;
  String name;
  var zaloOAId;
  var zaloSecretKey;
  var active;
  var companyId;
  var type;
  var facebookUserId;
  String facebookASUserId;
  String facebookUserName;
  String facebookUserAvatar;
  var facebookUserCover;
  String facebookUserToken;
  var facebookUserPrivateToken;
  String facebookPageId;
  String facebookPageName;
  String facebookPageLogo;
  var facebookPageCover;
  String facebookPageToken;
  bool isDefault;
  var facebookTokenExpired;
  String facebookTypeId;
  var facebookConfigs;

  TposFacebookUserPage(
      {this.id,
      this.name,
      this.zaloOAId,
      this.zaloSecretKey,
      this.active,
      this.companyId,
      this.type,
      this.facebookUserId,
      this.facebookASUserId,
      this.facebookUserName,
      this.facebookUserAvatar,
      this.facebookUserCover,
      this.facebookUserToken,
      this.facebookUserPrivateToken,
      this.facebookPageId,
      this.facebookPageName,
      this.facebookPageLogo,
      this.facebookPageCover,
      this.facebookPageToken,
      this.isDefault,
      this.facebookTokenExpired,
      this.facebookTypeId,
      this.facebookConfigs});

  TposFacebookUserPage.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    zaloOAId = json['ZaloOAId'];
    zaloSecretKey = json['ZaloSecretKey'];
    active = json['Active'];
    companyId = json['CompanyId'];
    type = json['Type'];
    facebookUserId = json['Facebook_UserId'];
    facebookASUserId = json['Facebook_ASUserId'];
    facebookUserName = json['Facebook_UserName'];
    facebookUserAvatar = json['Facebook_UserAvatar'];
    facebookUserCover = json['Facebook_UserCover'];
    facebookUserToken = json['Facebook_UserToken'];
    facebookUserPrivateToken = json['Facebook_UserPrivateToken'];
    facebookPageId = json['Facebook_PageId'];
    facebookPageName = json['Facebook_PageName'];
    facebookPageLogo = json['Facebook_PageLogo'];
    facebookPageCover = json['Facebook_PageCover'];
    facebookPageToken = json['Facebook_PageToken'];
    isDefault = json['IsDefault'];
    facebookTokenExpired = json['Facebook_TokenExpired'];
    facebookTypeId = json['Facebook_TypeId'];
    facebookConfigs = json['Facebook_Configs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['ZaloOAId'] = this.zaloOAId;
    data['ZaloSecretKey'] = this.zaloSecretKey;
    data['Active'] = this.active;
    data['CompanyId'] = this.companyId;
    data['Type'] = this.type;
    data['Facebook_UserId'] = this.facebookUserId;
    data['Facebook_ASUserId'] = this.facebookASUserId;
    data['Facebook_UserName'] = this.facebookUserName;
    data['Facebook_UserAvatar'] = this.facebookUserAvatar;
    data['Facebook_UserCover'] = this.facebookUserCover;
    data['Facebook_UserToken'] = this.facebookUserToken;
    data['Facebook_UserPrivateToken'] = this.facebookUserPrivateToken;
    data['Facebook_PageId'] = this.facebookPageId;
    data['Facebook_PageName'] = this.facebookPageName;
    data['Facebook_PageLogo'] = this.facebookPageLogo;
    data['Facebook_PageCover'] = this.facebookPageCover;
    data['Facebook_PageToken'] = this.facebookPageToken;
    data['IsDefault'] = this.isDefault;
    data['Facebook_TokenExpired'] = this.facebookTokenExpired;
    data['Facebook_TypeId'] = this.facebookTypeId;
    data['Facebook_Configs'] = this.facebookConfigs;
    return data;
  }
}
