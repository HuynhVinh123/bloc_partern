/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:tpos_mobile/src/tpos_apis/models/OrderDetail.dart';
import 'package:tpos_mobile/src/facebook_apis/src/models.dart';

class CreateSaleOnlineOrderRequest {
  CreateSaleOnlineOrderRequest({
    this.dateCreated,
    this.session,
    this.sessionIndex,
    this.companyId,
    this.deposit,
    this.zaloOAId,
    this.facebookContent,
    this.facebookUserAvatar,
    this.zaloOrderId,
    this.zaloOrderCode,
    this.sourceFacebookMessageId,
    this.sourceFacebookUserId,
    this.source,
    this.partnerNameNosign,
    this.commentIds,
    this.facebookCommentsText,
    this.statusText,
    this.status,
    this.statusStr,
    this.code,
    this.id,
    this.liveCampaignId,
    this.facebookPostId,
    this.facebookUserId,
    this.facebookASUserId,
    this.facebookUserName,
    this.facebookCommentId,
    this.name,
    this.partnerId,
    this.partnerName,
    this.email,
    this.address,
    this.cityCode,
    this.cityName,
    this.districtCode,
    this.districtName,
    this.wardCode,
    this.wardName,
    this.totalQuantity,
    this.note,
    this.totalAmount,
    this.orderDetails,
    this.telephone,
    this.liveCampaignName,
    this.partnerCode,
    this.comments,
  });

  factory CreateSaleOnlineOrderRequest.fromMap(Map<String, dynamic> jsonMap) {
    List<OrderDetail> orderDetails;
    final detailMap = jsonMap["Details"] as List;
    orderDetails = detailMap.map((map) {
      return OrderDetail.fromMap(map);
    }).toList();

    return CreateSaleOnlineOrderRequest(
      dateCreated: DateTime.parse(jsonMap["DateCreated"]),
      orderDetails: orderDetails,
      id: jsonMap["Id"],
      code: jsonMap["Code"],
      facebookUserId: jsonMap["Facebook_UserId"],
      facebookPostId: jsonMap["Facebook_PostId"],
      facebookASUserId: jsonMap["Facebook_ASUserId"],
      facebookCommentId: jsonMap["Facebook_CommentId"],
      facebookUserName: jsonMap["Facebook_UserName"],
      facebookUserAvatar: jsonMap["Facebook_UserAvatar"],
      facebookContent: jsonMap["Facebook_Content"],
      telephone: jsonMap["Telephone"],
      address: jsonMap["Address"],
      name: jsonMap["Name"],
      email: jsonMap["Email"],
      note: jsonMap["Note"],
      deposit: jsonMap["Deposit"],
      liveCampaignId: jsonMap["LiveCampaignId"],
      liveCampaignName: jsonMap["LiveCampaignName"],
      partnerId: jsonMap["PartnerId"],
      partnerName: jsonMap["PartnerName"],
      partnerCode: jsonMap["PartnerCode"],
      cityCode: jsonMap["CityCode"],
      cityName: jsonMap["CityName"],
      districtCode: jsonMap["DistrictCode"],
      districtName: jsonMap["DistrictName"],
      wardCode: jsonMap["WardCode"],
      wardName: jsonMap["WardName"],
      totalAmount: jsonMap["TotalAmount"],
      totalQuantity: jsonMap["TotalQuantity"],
      status: jsonMap["Status"],
      statusText: jsonMap["StatusText"],
      facebookCommentsText: jsonMap["Facebook_CommentsText"],
      statusStr: jsonMap["StatusStr"],
      commentIds: jsonMap["CommentIds"],
      companyId: jsonMap["CompanyId"],
      partnerNameNosign: jsonMap["PartnerNameNosign"],
      sessionIndex: jsonMap["SessionIndex"],
      session: jsonMap["Session"],
      source: jsonMap["Source"],
      sourceFacebookUserId: jsonMap["Source_FacebookUserId"],
      sourceFacebookMessageId: jsonMap["Source_FacebookMessageId"],
      zaloOrderCode: jsonMap["ZaloOrderCode"],
      zaloOrderId: jsonMap["ZaloOrderId"],
      zaloOAId: jsonMap["ZaloOAId"],
    );
  }
  DateTime dateCreated;
  double companyId, deposit, partnerId;
  int totalQuantity, sessionIndex, session;
  String zaloOAId,
      facebookContent,
      facebookUserAvatar,
      zaloOrderId,
      zaloOrderCode,
      sourceFacebookMessageId,
      sourceFacebookUserId,
      source,
      partnerNameNosign,
      commentIds,
      facebookCommentsText,
      statusText,
      status,
      statusStr,
      code,
      telephone,
      liveCampaignName,
      partnerCode,
      id;

  String liveCampaignId,
      facebookPostId,
      facebookUserId,
      facebookASUserId,
      facebookUserName,
      facebookCommentId,
      name,
      partnerName,
      email,
      address,
      cityCode,
      cityName,
      districtCode,
      districtName,
      wardCode,
      wardName,
      note;

  double totalAmount;
  List<OrderDetail> orderDetails;
  List<FacebookComment> comments;

  Map<String, dynamic> toMap() {
    return {
      "LiveCampaignId": liveCampaignId,
      "Facebook_PostId": facebookPostId,
      "Facebook_UserId": facebookUserId,
      "Facebook_ASUserId": facebookASUserId,
      "Facebook_UserName": facebookUserName,
      "Facebook_CommentId": facebookCommentId,
      "PartnerId": partnerId,
      "PartnerName": partnerName,
      "Email": email,
      "Address": address,
      "CityCode": cityCode,
      "DistrictCode": districtCode,
      "DistrictName": districtName,
      "WardCode": wardCode,
      "WardName": wardName,
      "TotalQuantity": totalQuantity,
      "Note": note,
      "TotalAmount": totalAmount,
      "Facebook_Comments": comments?.map((comment) {
        return comment.toJson();
      })?.toList(),
      "Details": orderDetails?.map((orderDetail) {
        return orderDetail.toMap();
      })?.toList()
    };
  }
}
