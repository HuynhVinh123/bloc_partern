/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:intl/intl.dart';

import 'sale_online_order_detail.dart';
import 'tpos_facebook_comment.dart';

class SaleOnlineOrder {
  SaleOnlineOrder({
    this.checked,
    this.id,
    this.dateCreated,
    this.facebookPostId,
    this.facebookUserId,
    this.facebookAsuid,
    this.facebookCommentId,
    this.facebookUserName,
    this.facebookContent,
    this.index,
    this.code,
    this.name,
    this.email,
    this.telephone,
    this.address,
    this.note,
    this.partnerId,
    this.partnerName,
    this.partnerCode,
    this.session,
    this.sessionIndex,
    this.liveCompaignId,
    this.liveCampaignName,
    this.totalAmount,
    this.totalQuantity,
    this.cityCode,
    this.cityName,
    this.districtCode,
    this.districtName,
    this.wardCode,
    this.wardName,
    this.status,
    this.statusText,
    this.companyId,
    this.details,
    this.crmTeamId,
    // this.comments
  });

  SaleOnlineOrder.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap["Id"];
    address = jsonMap["Address"];
    List<SaleOnlineOrderDetail> orderDetails;
    final detailMap = jsonMap["Details"] as List;
    if (detailMap != null) {
      orderDetails = detailMap.map((map) {
        return SaleOnlineOrderDetail.fromJson(map);
      }).toList();
    }

    details = orderDetails;

    if (jsonMap["DateCreated"] != null) {
      dateCreated = DateTime.parse(jsonMap['DateCreated']);
    }

    facebookPostId = jsonMap["Facebook_PostId"];
    facebookUserId = jsonMap["Facebook_UserId"];
    facebookAsuid = jsonMap["Facebook_ASUserId"];
    facebookCommentId = jsonMap["Facebook_CommentId"];
    facebookUserName = jsonMap["Facebook_UserName"];

    name = jsonMap["Name"];
    note = jsonMap["Note"];
    partnerId = jsonMap["PartnerId"];
    partnerName = jsonMap["PartnerName"];
    partnerCode = jsonMap["PartnerCode"];
    telephone = jsonMap["Telephone"];
    code = jsonMap["Code"];
    sessionIndex = jsonMap["SessionIndex"];
    liveCompaignId = jsonMap["LiveCampaignId"];

    totalAmount = (jsonMap["TotalAmount"])?.toDouble();
    totalQuantity = jsonMap["TotalQuantity"]?.toDouble();

    cityCode = jsonMap["CityCode"];
    cityName = jsonMap["CityName"];
    districtCode = jsonMap["DistrictCode"];
    districtName = jsonMap["DistrictName"];
    wardCode = jsonMap["WardCode"];
    wardName = jsonMap["WardName"];
    email = jsonMap["Email"];
    status = jsonMap["Status"];
    statusText = jsonMap["StatusText"];
    companyId = jsonMap["CompanyId"];
    session = jsonMap["Session"];
    crmTeamId = jsonMap["CRMTeamId"];
    printCount = jsonMap["PrintCount"];
  }

  bool checked = false;
  String id;

  DateTime dateCreated;
  String facebookPostId;
  String facebookUserId;
  String facebookAsuid;
  String facebookCommentId;
  String facebookUserName;
  String facebookContent;
  int index;
  String code;
  String name;
  String email;
  String telephone;
  String address;
  String note;
  int partnerId;
  String partnerName;
  String partnerCode;
  int session;
  int sessionIndex;
  String liveCompaignId;
  String liveCampaignName;
  double totalAmount;
  double totalQuantity;

  String cityCode;
  String cityName;
  String districtCode;
  String districtName;
  String wardCode;
  String wardName;
  dynamic status;
  String statusText;
  int companyId;
  int crmTeamId;
  // Số lần chốt và in
  int printCount;

  List<SaleOnlineOrderDetail> details;
  List<TPosFacebookComment> comments;

  double getProductCount() {
    if (details == null || details.isEmpty) {
      return 0;
    }

    return details.map((f) => f.quantity ?? 0).reduce((a, b) => a + b);
  }

  Map toJson([bool removeIfNull = false]) {
    final data = {
      "Id": id,
      "LiveCampaignId": liveCompaignId,
      "LiveCampaignName": liveCampaignName,
      "Facebook_PostId": facebookPostId,
      "Facebook_ASUserId": facebookAsuid,
      "Facebook_UserId": facebookUserId,
      "Facebook_UserName": facebookUserName,
      "Facebook_CommentId": facebookCommentId,
      "Name": name,
      "Note": note,
      "TotalAmount": totalAmount,
      "Code": code,
      "Details": details != null
          ? details.map((f) => f.toJson(removeIfNull)).toList()
          : null,
      // "Facebook_Comments":
      //     comments != null ? comments.map((f) => f.toJson()).toList() : null,
      "PartnerId": partnerId,
      "PartnerName": partnerName,
      "TotalQuantity": totalQuantity,
      "Email": email,
      "Telephone": telephone,
      "CityCode": cityCode,
      "CityName": cityName,
      "DistrictCode": districtCode,
      "DistrictName": districtName,
      "WardCode": wardCode,
      "WardName": wardName,
      "Address": address,
      "Status": status,
      "StatusText": statusText,
      "CompanyId": companyId,
      "Session": session,
      "CRMTeamId": crmTeamId,
    };

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }

    return data;
  }
}

class ViewSaleOnlineOrder {
  ViewSaleOnlineOrder(
      {this.checked,
      this.id,
      this.dateCreated,
      this.facebookPostId,
      this.facebookUserId,
      this.facebookAsuid,
      this.facebookCommentId,
      this.facebookUserName,
      this.facebookContent,
      this.index,
      this.code,
      this.name,
      this.email,
      this.telephone,
      this.address,
      this.note,
      this.partnerId,
      this.partnerName,
      this.partnerCode,
      this.session,
      this.sessionIndex,
      this.liveCompaignId,
      this.liveCampaignName,
      this.totalAmount,
      this.totalQuantity,
      this.cityCode,
      this.cityName,
      this.districtCode,
      this.districtName,
      this.wardCode,
      this.wardName,
      this.status,
      this.statusText,
      this.companyId,
      this.details,
      this.crmTeamId,
      this.comments});

  ViewSaleOnlineOrder.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap["Id"];
    address = jsonMap["Address"];
    List<SaleOnlineOrderDetail> orderDetails;
    final detailMap = jsonMap["Details"] as List;
    if (detailMap != null) {
      orderDetails = detailMap.map((map) {
        return SaleOnlineOrderDetail.fromJson(map);
      }).toList();
    }

    details = orderDetails;

    if (jsonMap["DateCreated"] != null) {
      dateCreated =
          DateFormat("yyyy-MM-ddThh:mm:ss").parse(jsonMap['DateCreated']);
    }

    facebookPostId = jsonMap["Facebook_PostId"];
    facebookUserId = jsonMap["Facebook_UserId"];
    facebookAsuid = jsonMap["Facebook_ASUserId"];
    facebookCommentId = jsonMap["Facebook_CommentId"];
    facebookUserName = jsonMap["Facebook_UserName"];

    name = jsonMap["Name"];
    note = jsonMap["Note"];
    partnerId = jsonMap["PartnerId"];
    partnerName = jsonMap["PartnerName"];
    partnerCode = jsonMap["PartnerCode"];
    telephone = jsonMap["Telephone"];
    code = jsonMap["Code"];
    sessionIndex = jsonMap["SessionIndex"];
    liveCompaignId = jsonMap["LiveCampaignId"];

    totalAmount = (jsonMap["TotalAmount"])?.toDouble();
    totalQuantity = jsonMap["TotalQuantity"]?.toDouble();

    cityCode = jsonMap["CityCode"];
    cityName = jsonMap["CityName"];
    districtCode = jsonMap["DistrictCode"];
    districtName = jsonMap["DistrictName"];
    wardCode = jsonMap["WardCode"];
    wardName = jsonMap["WardName"];
    email = jsonMap["Email"];
    status = jsonMap["Status"];
    statusText = jsonMap["StatusText"];
    companyId = jsonMap["CompanyId"];
    session = jsonMap["Session"];
    crmTeamId = jsonMap["CRMTeamId"];
    printCount = jsonMap["PrintCount"];
  }

  bool checked = false;
  String address;
  int crmTeamId;
  String code;
  String id;
  DateTime dateCreated;
  String facebookPostId;
  String facebookUserId;
  String facebookAsuid;
  String facebookCommentId;
  String facebookUserName;
  String facebookContent;
  int index;

  String name;
  String email;
  String telephone;

  String note;
  int partnerId;
  String partnerName;
  String partnerCode;
  int session;
  int sessionIndex;
  String liveCompaignId;
  String liveCampaignName;
  double totalAmount;
  double totalQuantity;

  String cityCode;
  String cityName;
  String districtCode;
  String districtName;
  String wardCode;
  String wardName;
  String status;
  String statusText;
  int companyId;
  // Số lần chốt và in
  int printCount;

  List<SaleOnlineOrderDetail> details;
  List<TPosFacebookComment> comments;

  Map toJson([bool removeIfNull = false]) {
    final data = {
      "Id": id,
      "LiveCampaignId": liveCompaignId,
      "LiveCampaignName": liveCampaignName,
      "Facebook_PostId": facebookPostId,
      "Facebook_ASUserId": facebookAsuid,
      "Facebook_UserId": facebookUserId,
      "Facebook_UserName": facebookUserName,
      "Facebook_CommentId": facebookCommentId,
      "Name": name,
      "Note": note,
      "TotalAmount": totalAmount,
      "Code": code,
      "Details": details != null
          ? details.map((f) => f.toJson(removeIfNull)).toList()
          : null,
      "Facebook_Comments":
          comments != null ? comments.map((f) => f.toJson()).toList() : null,
      "PartnerId": partnerId,
      "PartnerName": partnerName,
      "TotalQuantity": totalQuantity,
      "Email": email,
      "Telephone": telephone,
      "CityCode": cityCode,
      "CityName": cityName,
      "DistrictCode": districtCode,
      "DistrictName": districtName,
      "WardCode": wardCode,
      "WardName": wardName,
      "Address": address,
      "Status": status,
      "StatusText": statusText,
      "CompanyId": companyId,
      "Session": session,
      "CRMTeamId": crmTeamId,
    };

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }

    return data;
  }
}
