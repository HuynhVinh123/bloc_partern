/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'dart:convert';

import 'ship_extra.dart';

class DeliveryCarrier {
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
    configTransportId = json[
        'Config_TransportId']; //TODO(namnv) fix type data ()OneByString is not subtype of int
    configTransportName = json['Config_TransportName'];
    configDefaultFee = json['Config_DefaultFee']?.toDouble();
    configDefaultWeight = json['Config_DefaultWeight']?.toDouble();
    extrasText = json['ExtrasText'];
    if (json["Extras"] != null) {
      extras = ShipExtra.fromJson(json["Extras"]);
    }

    if (json["ExtrasText"] != null) {
      final jsonMap = json["ExtrasText"];
      extrasFromText = ShipExtra.fromJson(jsonDecode(jsonMap));
    }
  }

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
  String configTransportId;
  String configTransportName;
  double configDefaultFee;
  double configDefaultWeight;
  String extrasText;
  ShipExtra extras;
  ShipExtra extrasFromText;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['DeliveryType'] = deliveryType;
    data['IsPrintCustom'] = isPrintCustom;
    data['SenderName'] = senderName;
    data['Sequence'] = sequence;
    data['Active'] = active;
    data['ProductId'] = productId;
    data['FixedPrice'] = fixedPrice;
    data['CompanyId'] = companyId;
    data['Amount'] = amount;
    data['FreeOver'] = freeOver;
    data['Margin'] = margin;
    data['HCMPTConfigId'] = hCMPTConfigId;
    data['GHN_ApiKey'] = gHNApiKey;
    data['GHN_ClientId'] = gHNClientId;
    data['GHN_NoteCode'] = gHNNoteCode;
    data['GHN_PaymentTypeId'] = gHNPaymentTypeId;
    data['GHN_PackageWidth'] = gHNPackageWidth;
    data['GHN_PackageLength'] = gHNPackageLength;
    data['GHN_PackageHeight'] = gHNPackageHeight;
    data['GHN_ServiceId'] = gHNServiceId;
    data['ViettelPost_UserName'] = viettelPostUserName;
    data['ViettelPost_Password'] = viettelPostPassword;
    data['ViettelPost_Token'] = viettelPostToken;
    data['ViettelPost_ServiceId'] = viettelPostServiceId;
    data['ViettelPost_ProductType'] = viettelPostProductType;
    data['ViettelPost_OrderPayment'] = viettelPostOrderPayment;
    data['ShipChung_ServiceId'] = shipChungServiceId;
    data['ShipChung_PaymentTypeID'] = shipChungPaymentTypeID;
    data['ShipChung_ApiKey'] = shipChungApiKey;
    data['HCMPost_sI'] = hCMPostSI;
    data['HCMPost_sK'] = hCMPostSK;
    data['HCMPost_ShopID'] = hCMPostShopID;
    data['HCMPost_ShopName'] = hCMPostShopName;
    data['HCMPost_ServiceId'] = hCMPostServiceId;
    data['TokenShip'] = tokenShip;
    data['VNPost_ClientId'] = vNPostClientId;
    data['VNPost_ServiceId'] = vNPostServiceId;
    data['VNPost_IsContracted'] = vNPostIsContracted;
    data['VNPost_PickupType'] = vNPostPickupType;
    data['GHTK_Token'] = gHTKToken;
    data['GHTK_ClientId'] = gHTKClientId;
    data['GHTK_IsFreeShip'] = gHTKIsFreeShip;
    data['SuperShip_Token'] = superShipToken;
    data['SuperShip_ClientId'] = superShipClientId;
    data['Config_TransportId'] = configTransportId;
    data['Config_TransportName'] = configTransportName;
    data['Config_DefaultFee'] = configDefaultFee;
    data['Config_DefaultWeight'] = configDefaultWeight;
    data['ExtrasText'] = extrasText;
    data['Extras'] = extras?.toJson(true);
    if (removeIfNull) {
      return data..removeWhere((key, value) => value == null);
    } else {
      return data;
    }
  }
}

class DeliveryCarrierExtraText {
  DeliveryCarrierExtraText({this.pickWorkShift, this.pickWorkShiftName});
  String pickWorkShift;
  String pickWorkShiftName;
}
