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

  /// Mã in ra barcode
  String shipCodeQRCode;
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
      this.trackingArea,
      this.shipCodeQRCode});

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    Map<String, dynamic> data = <String, dynamic>{};
    data["CompanyName"] = companyName;
    data["CompanyPhone"] = companyPhone;
    data["CompanyAddress"] = companyAddress;
    data["InvoiceNumber"] = invoiceNumber;

    data["InvoiceDate"] = "/Date(${invoiceDate.millisecondsSinceEpoch})/";
    data["ReceiverName"] = receiverName;
    data["ReceiverPhone"] = receiverPhone;
    data["ReceiverAddress"] = receiverAddress;
    data["ReceiverCityName"] = receiverCityName;
    data["ReceiverDistrictName"] = receiverDictrictName;
    data["ReceiverWardName"] = receiverWardName;
    data["InvoiceAmount"] = invoiceAmount;
    data["DeliveryPrice"] = deliveryPrice;
    data["CashOnDelivery"] = cashOnDeliveryPrice;
    data["DepositAmount"] = depositAmount;
    data["ProductQuantity"] = productQuantity;
    data["CarrierName"] = carrierName;
    data["CarrierService"] = carrierService;
    data["ShipCode"] = shipCode;
    data["ShipNote"] = shipNote;
    data["ShipWeight"] = shipWeight;
    data["Content"] = content;
    data["Note"] = note;
    data["TrackingRef"] = trackingRef;
    data["TrackingRefSort"] = trackingRefSort;
    data["TrackingRefToShow"] = trackingRefToShow;
    data["TrackingRefGHTK"] = trackingRefGHTK;
    data["Staff"] = staff;
    data["Sender"] = sender;
    data["TrackingArea"] = trackingArea;
    data['ShipCodeBarcode'] = shipCodeQRCode;

    return data..removeWhere((key, value) => value == null);
  }
}
