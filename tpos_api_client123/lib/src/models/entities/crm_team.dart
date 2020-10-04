/// Object Kênh bán hàng (Facebook, Zalo, Shoppe)
class CRMTeam {
  int id;
  String name;
  String zaloOAId;
  String zaloSecretKey;
  bool active;
  int companyId;
  String type;
  String shopeeId;
  int countPage;
  int countGroup;
  String facebookUserId;
  String facebookASUserId;
  String facebookUserName;
  String facebookUserAvatar;
  String facebookUserCover;
  String facebookUserToken;
  String facebookUserPrivateToken;
  String facebookUserPrivateToken2;
  String facebookPagePrivateToken;
  String facebookPageId;
  String facebookPageName;
  String facebookPageLogo;
  String facebookPageCover;
  String facebookPageToken;
  String facebookLink;
  bool isDefault;
  DateTime facebookTokenExpired;
  String facebookTypeId;
  int parentId;
  String parentName;
  String shopId;
  dynamic facebookConfigs;
  List<CRMTeam> childs;
  CRMTeam parent;

  String get userAsuidOrPageId {
    switch (this.facebookTypeId) {
      case "User":
        return this.facebookASUserId;
        break;
      case "Page":
        return this.facebookPageId;
        break;
      case "Group":
        return this.facebookPageId;
        break;
      default:
        return this.facebookASUserId;
        break;
    }
  }

  String get userUidOrPageId {
    switch (this.facebookTypeId) {
      case "User":
        return this.facebookUserId;
        break;
      case "Page":
        return this.facebookPageId;
        break;
      case "Group":
        return this.facebookPageId;
        break;
      default:
        return this.facebookUserId;
        break;
    }
  }

  String get userOrPageToken {
    switch (this.facebookTypeId) {
      case "User":
        return this.facebookUserToken;
        break;
      case "Page":
        return this.facebookPageToken;
        break;
      case "Group":
        return this.facebookPageToken;
        break;
      default:
        return this.facebookUserToken;
        break;
    }
  }

  String get facebookId {
    switch (this.facebookTypeId) {
      case "User":
        return this.facebookUserId;
        break;
      case "Page":
        return this.facebookPageId;
      default:
        return this.facebookUserId;
        break;
    }
  }

  CRMTeam(
      {this.id,
      this.name,
      this.zaloOAId,
      this.zaloSecretKey,
      this.active,
      this.companyId,
      this.type,
      this.shopeeId,
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
      this.facebookLink,
      this.isDefault,
      this.facebookTokenExpired,
      this.facebookTypeId,
      this.parentId,
      this.parentName,
      this.shopId,
      this.facebookConfigs,
      this.childs,
      this.parent});

  CRMTeam.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    zaloOAId = json['ZaloOAId'];
    zaloSecretKey = json['ZaloSecretKey'];
    active = json['Active'];
    companyId = json['CompanyId'];
    type = json['Type'];
    shopeeId = json['ShopeeId'];
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
    facebookLink = json['Facebook_Link'];
    isDefault = json['IsDefault'];
    facebookTokenExpired = json['Facebook_TokenExpired'];
    facebookTypeId = json['Facebook_TypeId'];
    parentId = json['ParentId'];
    parentName = json['ParentName'];
    shopId = json['ShopId'];
    facebookConfigs = json['Facebook_Configs'];
    if (json['Childs'] != null) {
      childs = new List<CRMTeam>();
      json['Childs'].forEach((v) {
        childs.add(new CRMTeam.fromJson(v)..parent = this);
      });
    }
  }

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['ZaloOAId'] = this.zaloOAId;
    data['ZaloSecretKey'] = this.zaloSecretKey;
    data['Active'] = this.active;
    data['CompanyId'] = this.companyId;
    data['Type'] = this.type;
    data['ShopeeId'] = this.shopeeId;
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
    data['Facebook_Link'] = this.facebookLink;
    data['IsDefault'] = this.isDefault;
    data['Facebook_TokenExpired'] = this.facebookTokenExpired;
    data['Facebook_TypeId'] = this.facebookTypeId;
    data['ParentId'] = this.parentId;
    data['ParentName'] = this.parentName;
    data['ShopId'] = this.shopId;
    data['Facebook_Configs'] = this.facebookConfigs;
    if (this.childs != null) {
      data['Childs'] = this.childs.map((v) => v.toJson()).toList();
    }

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
