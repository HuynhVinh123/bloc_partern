/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 7/5/19 4:54 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 7/5/19 10:09 AM
 *
 */

class PrintShipData {
  String companyName;
  String companyPhone;
  String companyAddress;

  String receiverName;
  String receiverPhone;
  String receiverAddress;
  String receiverCityName;
  String receiverDictrictName;
  String receiverWardName;
  String receiverAddressFull;
  String imageLogo;

  String invoiceNumber;
  DateTime invoiceDate;
  double invoiceAmount;
  double deliveryPrice;
  double cashOnDeliveryPrice;

  /// Tiền cọc
  double depositAmount;

  /// Số lượng sản phẩm
  double productQuantity;

  String carrierName;
  String carrierService;
  String shipCode;
  String shipNote;
  String note;
  int shipWeight;
  String content;
  String trackingRef;
  String trackingRefSort;
  String trackingRefToShow;
  String trackingRefGHTK;
  String trackingArea;

  /// Tên nhân viên
  String staff;

  /// [sender] config from company setting to print extra info to ship receipt
  String sender;

  PrintShipData(
      {this.companyName,
      this.companyPhone,
      this.companyAddress,
      this.invoiceNumber,
      this.invoiceDate,
      this.receiverName,
      this.receiverPhone,
      this.receiverAddress,
      this.receiverCityName,
      this.receiverDictrictName,
      this.receiverWardName,
      this.invoiceAmount,
      this.deliveryPrice,
      this.cashOnDeliveryPrice,
      this.carrierName,
      this.carrierService,
      this.shipCode,
      this.shipWeight,
      this.shipNote,
      this.content,
      this.note,
      this.trackingRef,
      this.trackingRefSort,
      this.trackingRefToShow,
      this.trackingRefGHTK,
      this.staff,
      this.depositAmount,
      this.productQuantity,
      this.sender,
      this.imageLogo,
      this.trackingArea});

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data["CompanyName"] = this.companyName;
    data["CompanyPhone"] = this.companyPhone;
    data["CompanyAddress"] = this.companyAddress;
    data["InvoiceNumber"] = this.invoiceNumber;

    data["InvoiceDate"] = "/Date(${invoiceDate.millisecondsSinceEpoch})/";
    data["ReceiverName"] = this.receiverName;
    data["ReceiverPhone"] = this.receiverPhone;
    data["ReceiverAddress"] = this.receiverAddress;
    data["ReceiverCityName"] = this.receiverCityName;
    data["ReceiverDistrictName"] = this.receiverDictrictName;
    data["ReceiverWardName"] = this.receiverWardName;
    data["InvoiceAmount"] = this.invoiceAmount;
    data["DeliveryPrice"] = this.deliveryPrice;
    data["CashOnDelivery"] = this.cashOnDeliveryPrice;
    data["DepositAmount"] = this.depositAmount;
    data["ProductQuantity"] = this.productQuantity;
    data["CarrierName"] = this.carrierName;
    data["CarrierService"] = this.carrierService;
    data["ShipCode"] = this.shipCode;
    data["ShipNote"] = this.shipNote;
    data["ShipWeight"] = this.shipWeight;
    data["Content"] = this.content;
    data["Note"] = this.note;
    data["TrackingRef"] = this.trackingRef;
    data["TrackingRefSort"] = this.trackingRefSort;
    data["TrackingRefToShow"] = this.trackingRefToShow;
    data["TrackingRefGHTK"] = this.trackingRefGHTK;
    data["Staff"] = this.staff;
    data["Sender"] = this.sender;
    data["TrackingArea"] = this.trackingArea;

    return data..removeWhere((key, value) => value == null);
  }
}
