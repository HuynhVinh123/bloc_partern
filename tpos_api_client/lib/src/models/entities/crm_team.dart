/// Object Kênh bán hàng (Facebook, Zalo, Shoppe)
class CRMTeam {
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

  /// Lưu tạm kết quả lấy hình đại diện. Nếu quá trình lấy hình thất bại thì isImageErorr =true.
  bool isImageError = false;

  String get userAsuidOrPageId {
    switch (facebookTypeId) {
      case "User":
        return facebookASUserId;
        break;
      case "Page":
        return facebookPageId;
        break;
      case "Group":
        return facebookPageId;
        break;
      default:
        return facebookASUserId;
        break;
    }
  }

  String get userUidOrPageId {
    switch (facebookTypeId) {
      case "User":
        return facebookUserId;
        break;
      case "Page":
        return facebookPageId;
        break;
      case "Group":
        return facebookPageId;
        break;
      default:
        return facebookUserId;
        break;
    }
  }

  String get userOrPageToken {
    switch (facebookTypeId) {
      case "User":
        return facebookUserToken;
        break;
      case "Page":
        return facebookPageToken;
        break;
      case "Group":
        return facebookPageToken;
        break;
      default:
        return facebookUserToken;
        break;
    }
  }

  String get facebookId {
    switch (facebookTypeId) {
      case "User":
        return facebookUserId;
        break;
      case "Page":
        return facebookPageId;
      default:
        return facebookUserId;
        break;
    }
  }

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
    facebookTypeId = json['Facebook_TypeId'].toString();
    parentId = json['ParentId'];
    parentName = json['ParentName'];
    shopId = json['ShopId'];
    facebookConfigs = json['Facebook_Configs'];
    if (json['Childs'] != null) {
      childs = <CRMTeam>[];
      json['Childs'].forEach((v) {
        childs.add(CRMTeam.fromJson(v)..parent = this);
      });
    }
  }

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = id;
    data['Name'] = name;
    data['ZaloOAId'] = zaloOAId;
    data['ZaloSecretKey'] = zaloSecretKey;
    data['Active'] = active;
    data['CompanyId'] = companyId;
    data['Type'] = type;
    data['ShopeeId'] = shopeeId;
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
    data['Facebook_Link'] = facebookLink;
    data['IsDefault'] = isDefault;
    data['Facebook_TokenExpired'] = facebookTokenExpired;
    data['Facebook_TypeId'] = facebookTypeId;
    data['ParentId'] = parentId;
    data['ParentName'] = parentName;
    data['ShopId'] = shopId;
    data['Facebook_Configs'] = facebookConfigs;
    if (childs != null) {
      data['Childs'] = childs.map((v) => v.toJson()).toList();
    }

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
