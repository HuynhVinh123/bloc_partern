/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

class TposFacebookUser {
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
      childs = <TposFacebookUserPage>[];
      json['Childs'].forEach((v) {
        childs.add(TposFacebookUserPage.fromJson(v));
      });
    }
  }
  int id;
  String name;
  dynamic zaloOAId;
  dynamic zaloSecretKey;
  bool active;
  int companyId;
  dynamic type;
  int countPage;
  int countGroup;
  String facebookUserId;
  String facebookASUserId;
  String facebookUserName;
  String facebookUserAvatar;
  dynamic facebookUserCover;
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
  dynamic facebookTokenExpired;
  String facebookTypeId;
  dynamic parentId;
  dynamic facebookConfigs;
  List<TposFacebookUserPage> childs;

  Map<String, dynamic> toJson({bool removeNullValue = false}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['ZaloOAId'] = zaloOAId;
    data['ZaloSecretKey'] = zaloSecretKey;
    data['Active'] = active;
    data['CompanyId'] = companyId;
    data['Type'] = type;
    data['CountPage'] = countPage;
    data['CountGroup'] = countGroup;
    data['Facebook_UserId'] = facebookUserId;
    data['Facebook_ASUserId'] = facebookASUserId;
    data['Facebook_UserName'] = facebookUserName;
    data['Facebook_UserAvatar'] = facebookUserAvatar;
    data['Facebook_UserCover'] = facebookUserCover;
    data['Facebook_UserToken'] = facebookUserToken;
    data['Facebook_UserPrivateToken'] = facebookUserPrivateToken;
    data['Facebook_UserPrivateToken2'] = facebookUserPrivateToken2;
    data['Facebook_PagePrivateToken'] = facebookPagePrivateToken;
    data['Facebook_PageId'] = facebookPageId;
    data['Facebook_PageName'] = facebookPageName;
    data['Facebook_PageLogo'] = facebookPageLogo;
    data['Facebook_PageCover'] = facebookPageCover;
    data['Facebook_PageToken'] = facebookPageToken;
    data['IsDefault'] = isDefault;
    data['Facebook_TokenExpired'] = facebookTokenExpired;
    data['Facebook_TypeId'] = facebookTypeId;
    data['ParentId'] = parentId;
    data['Facebook_Configs'] = facebookConfigs;
    if (childs != null) {
      data['Childs'] = childs.map((v) => v.toJson()).toList();
    }
    if (removeNullValue) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}

class TposFacebookUserPage {
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

  int id;
  String name;
  dynamic zaloOAId;
  dynamic zaloSecretKey;
  dynamic active;
  dynamic companyId;
  dynamic type;
  dynamic facebookUserId;
  String facebookASUserId;
  String facebookUserName;
  String facebookUserAvatar;
  dynamic facebookUserCover;
  String facebookUserToken;
  dynamic facebookUserPrivateToken;
  String facebookPageId;
  String facebookPageName;
  String facebookPageLogo;
  dynamic facebookPageCover;
  String facebookPageToken;
  bool isDefault;
  dynamic facebookTokenExpired;
  String facebookTypeId;
  dynamic facebookConfigs;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['ZaloOAId'] = zaloOAId;
    data['ZaloSecretKey'] = zaloSecretKey;
    data['Active'] = active;
    data['CompanyId'] = companyId;
    data['Type'] = type;
    data['Facebook_UserId'] = facebookUserId;
    data['Facebook_ASUserId'] = facebookASUserId;
    data['Facebook_UserName'] = facebookUserName;
    data['Facebook_UserAvatar'] = facebookUserAvatar;
    data['Facebook_UserCover'] = facebookUserCover;
    data['Facebook_UserToken'] = facebookUserToken;
    data['Facebook_UserPrivateToken'] = facebookUserPrivateToken;
    data['Facebook_PageId'] = facebookPageId;
    data['Facebook_PageName'] = facebookPageName;
    data['Facebook_PageLogo'] = facebookPageLogo;
    data['Facebook_PageCover'] = facebookPageCover;
    data['Facebook_PageToken'] = facebookPageToken;
    data['IsDefault'] = isDefault;
    data['Facebook_TokenExpired'] = facebookTokenExpired;
    data['Facebook_TypeId'] = facebookTypeId;
    data['Facebook_Configs'] = facebookConfigs;
    return data;
  }
}
