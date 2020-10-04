/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'dart:convert';

import 'package:tpos_mobile/src/tpos_apis/models/ShipExtra.dart';

class DeliveryCarrier {
  int id;
  String name;
  String deliveryType;
  bool isPrintCustom;
  String senderName;
  int sequence;
  bool active;
  int productId;
  dynamic fixedPrice;
  int companyId;
  dynamic amount;
  bool freeOver;
  dynamic margin;
  dynamic hCMPTConfigId;
  dynamic gHNApiKey;
  dynamic gHNClientId;
  String gHNNoteCode;
  int gHNPaymentTypeId;
  int gHNPackageWidth;
  int gHNPackageLength;
  int gHNPackageHeight;
  dynamic gHNServiceId;
  String viettelPostUserName;
  String viettelPostPassword;
  String viettelPostToken;
  String viettelPostServiceId;
  dynamic viettelPostProductType;
  dynamic viettelPostOrderPayment;
  dynamic shipChungServiceId;
  dynamic shipChungPaymentTypeID;
  dynamic shipChungApiKey;
  dynamic hCMPostSI;
  dynamic hCMPostSK;
  dynamic hCMPostShopID;
  String hCMPostShopName;
  dynamic hCMPostServiceId;
  String tokenShip;
  String vNPostClientId;
  dynamic vNPostServiceId;
  bool vNPostIsContracted;
  String vNPostPickupType;
  String gHTKToken;
  String gHTKClientId;
  int gHTKIsFreeShip;
  String superShipToken;
  dynamic superShipClientId;
  int configTransportId;
  String configTransportName;
  double configDefaultFee;
  double configDefaultWeight;
  String extrasText;
  ShipExtra extras;
  ShipExtra extrasFromText;
  DeliveryCarrier(
      {this.id,
      this.name,
      this.deliveryType,
      this.isPrintCustom,
      this.senderName,
      this.sequence,
      this.active,
      this.productId,
      this.fixedPrice,
      this.companyId,
      this.amount,
      this.freeOver,
      this.margin,
      this.hCMPTConfigId,
      this.gHNApiKey,
      this.gHNClientId,
      this.gHNNoteCode,
      this.gHNPaymentTypeId,
      this.gHNPackageWidth,
      this.gHNPackageLength,
      this.gHNPackageHeight,
      this.gHNServiceId,
      this.viettelPostUserName,
      this.viettelPostPassword,
      this.viettelPostToken,
      this.viettelPostServiceId,
      this.viettelPostProductType,
      this.viettelPostOrderPayment,
      this.shipChungServiceId,
      this.shipChungPaymentTypeID,
      this.shipChungApiKey,
      this.hCMPostSI,
      this.hCMPostSK,
      this.hCMPostShopID,
      this.hCMPostShopName,
      this.hCMPostServiceId,
      this.tokenShip,
      this.vNPostClientId,
      this.vNPostServiceId,
      this.vNPostIsContracted,
      this.vNPostPickupType,
      this.gHTKToken,
      this.gHTKClientId,
      this.gHTKIsFreeShip,
      this.superShipToken,
      this.superShipClientId,
      this.configTransportId,
      this.configTransportName,
      this.configDefaultFee,
      this.configDefaultWeight,
      this.extrasText,
      this.extras});

  DeliveryCarrier.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    deliveryType = json['DeliveryType'];
    isPrintCustom = json['IsPrintCustom'];
    senderName = json['SenderName'];
    sequence = json['Sequence'];
    active = json['Active'];
    productId = json['ProductId'];
    fixedPrice = json['FixedPrice'];
    companyId = json['CompanyId'];
    amount = json['Amount'];
    freeOver = json['FreeOver'];
    margin = json['Margin'];
    hCMPTConfigId = json['HCMPTConfigId'];
    gHNApiKey = json['GHN_ApiKey'];
    gHNClientId = json['GHN_ClientId'];
    gHNNoteCode = json['GHN_NoteCode'];
    gHNPaymentTypeId = json['GHN_PaymentTypeId'];
    gHNPackageWidth = json['GHN_PackageWidth'];
    gHNPackageLength = json['GHN_PackageLength'];
    gHNPackageHeight = json['GHN_PackageHeight'];
    gHNServiceId = json['GHN_ServiceId'];
    viettelPostUserName = json['ViettelPost_UserName'];
    viettelPostPassword = json['ViettelPost_Password'];
    viettelPostToken = json['ViettelPost_Token'];
    viettelPostServiceId = json['ViettelPost_ServiceId'];
    viettelPostProductType = json['ViettelPost_ProductType'];
    viettelPostOrderPayment = json['ViettelPost_OrderPayment'];
    shipChungServiceId = json['ShipChung_ServiceId'];
    shipChungPaymentTypeID = json['ShipChung_PaymentTypeID'];
    shipChungApiKey = json['ShipChung_ApiKey'];
    hCMPostSI = json['HCMPost_sI'];
    hCMPostSK = json['HCMPost_sK'];
    hCMPostShopID = json['HCMPost_ShopID'];
    hCMPostShopName = json['HCMPost_ShopName'];
    hCMPostServiceId = json['HCMPost_ServiceId'];
    tokenShip = json['TokenShip'];
    vNPostClientId = json['VNPost_ClientId'];
    vNPostServiceId = json['VNPost_ServiceId'];
    vNPostIsContracted = json['VNPost_IsContracted'];
    vNPostPickupType = json['VNPost_PickupType'];
    gHTKToken = json['GHTK_Token'];
    gHTKClientId = json['GHTK_ClientId'];
    gHTKIsFreeShip = json['GHTK_IsFreeShip'];
    superShipToken = json['SuperShip_Token'];
    superShipClientId = json['SuperShip_ClientId'];
    configTransportId = json['Config_TransportId'];
    configTransportName = json['Config_TransportName'];
    configDefaultFee = json['Config_DefaultFee']?.toDouble();
    configDefaultWeight = json['Config_DefaultWeight']?.toDouble();
    extrasText = json['ExtrasText'];
    if (json["Extras"] != null) {
      extras = ShipExtra.fromJson(json["Extras"]);
    }

    if (json["ExtrasText"] != null) {
      var jsonMap = json["ExtrasText"];
      extrasFromText = ShipExtra.fromJson(jsonDecode(jsonMap));
    }
  }

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['DeliveryType'] = this.deliveryType;
    data['IsPrintCustom'] = this.isPrintCustom;
    data['SenderName'] = this.senderName;
    data['Sequence'] = this.sequence;
    data['Active'] = this.active;
    data['ProductId'] = this.productId;
    data['FixedPrice'] = this.fixedPrice;
    data['CompanyId'] = this.companyId;
    data['Amount'] = this.amount;
    data['FreeOver'] = this.freeOver;
    data['Margin'] = this.margin;
    data['HCMPTConfigId'] = this.hCMPTConfigId;
    data['GHN_ApiKey'] = this.gHNApiKey;
    data['GHN_ClientId'] = this.gHNClientId;
    data['GHN_NoteCode'] = this.gHNNoteCode;
    data['GHN_PaymentTypeId'] = this.gHNPaymentTypeId;
    data['GHN_PackageWidth'] = this.gHNPackageWidth;
    data['GHN_PackageLength'] = this.gHNPackageLength;
    data['GHN_PackageHeight'] = this.gHNPackageHeight;
    data['GHN_ServiceId'] = this.gHNServiceId;
    data['ViettelPost_UserName'] = this.viettelPostUserName;
    data['ViettelPost_Password'] = this.viettelPostPassword;
    data['ViettelPost_Token'] = this.viettelPostToken;
    data['ViettelPost_ServiceId'] = this.viettelPostServiceId;
    data['ViettelPost_ProductType'] = this.viettelPostProductType;
    data['ViettelPost_OrderPayment'] = this.viettelPostOrderPayment;
    data['ShipChung_ServiceId'] = this.shipChungServiceId;
    data['ShipChung_PaymentTypeID'] = this.shipChungPaymentTypeID;
    data['ShipChung_ApiKey'] = this.shipChungApiKey;
    data['HCMPost_sI'] = this.hCMPostSI;
    data['HCMPost_sK'] = this.hCMPostSK;
    data['HCMPost_ShopID'] = this.hCMPostShopID;
    data['HCMPost_ShopName'] = this.hCMPostShopName;
    data['HCMPost_ServiceId'] = this.hCMPostServiceId;
    data['TokenShip'] = this.tokenShip;
    data['VNPost_ClientId'] = this.vNPostClientId;
    data['VNPost_ServiceId'] = this.vNPostServiceId;
    data['VNPost_IsContracted'] = this.vNPostIsContracted;
    data['VNPost_PickupType'] = this.vNPostPickupType;
    data['GHTK_Token'] = this.gHTKToken;
    data['GHTK_ClientId'] = this.gHTKClientId;
    data['GHTK_IsFreeShip'] = this.gHTKIsFreeShip;
    data['SuperShip_Token'] = this.superShipToken;
    data['SuperShip_ClientId'] = this.superShipClientId;
    data['Config_TransportId'] = this.configTransportId;
    data['Config_TransportName'] = this.configTransportName;
    data['Config_DefaultFee'] = this.configDefaultFee;
    data['Config_DefaultWeight'] = this.configDefaultWeight;
    data['ExtrasText'] = this.extrasText;
    data['Extras'] = this.extras?.toJson(true);
    if (removeIfNull) {
      return data..removeWhere((key, value) => value == null);
    } else {
      return data;
    }
  }
}

class DeliveryCarrierExtraText {
  String pickWorkShift;
  String pickWorkShiftName;
  DeliveryCarrierExtraText({this.pickWorkShift, this.pickWorkShiftName});
}
