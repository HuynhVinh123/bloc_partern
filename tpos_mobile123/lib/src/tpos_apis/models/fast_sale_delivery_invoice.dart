/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:tpos_mobile/src/tpos_apis/models/fast_sale_order_line.dart';
import 'package:tpos_mobile/src/tpos_apis/models/ship_receiver.dart';

class FastSaleDeliveryInvoice {
  int id;
  int partnerId;
  double discount;
  double discountAmount;
  double decreaseAmount;
  double weightTotal;
  int userId;
  String userName;
  DateTime dateInvoice;
  int companyId;
  String comment;
  String type;
  double deliveryPrice;
  int carrierId;
  String deliveryNote;
  double cashOnDelivery;
  int paymentJournalId;
  double paymentAmount;
  int shipWeight;
  int oldCredit;
  int newCredit;
  double amountDeposit;
  bool notModifyPriceFromSO;
  ShipReceiver shipReceiver;
  String shipServiceId;
  String shipServiceName;
  List<FastSaleOrderLine> fastSaleOrderLine;
  double amountTotal;
  String address;
  String phone;
  String showState;
  String partnerDisplayName;
  String partnerNameNoSign;
  String number;
  String carrierName;
  String trackingRef;
  String shipPaymentStatus;

  FastSaleDeliveryInvoice(
      {this.id,
      this.partnerId,
      this.discount,
      this.discountAmount,
      this.decreaseAmount,
      this.weightTotal,
      this.userId,
      this.userName,
      this.dateInvoice,
      this.companyId,
      this.comment,
      this.type,
      this.deliveryPrice,
      this.carrierId,
      this.deliveryNote,
      this.cashOnDelivery,
      this.paymentJournalId,
      this.paymentAmount,
      this.shipWeight,
      this.oldCredit,
      this.newCredit,
      this.amountDeposit,
      this.notModifyPriceFromSO,
      this.shipReceiver,
      this.shipServiceId,
      this.shipServiceName,
      this.fastSaleOrderLine,
      this.amountTotal,
      this.address,
      this.phone,
      this.showState,
      this.partnerDisplayName,
      this.partnerNameNoSign,
      this.number,
      this.carrierName,
      this.trackingRef,
      this.shipPaymentStatus});

  factory FastSaleDeliveryInvoice.fromMap(Map<String, dynamic> jsonMap) {
    List<FastSaleOrderLine> orderLines;
    var detailMap = jsonMap["OrderLines"] as List;
    orderLines = detailMap.map((map) {
      return FastSaleOrderLine.fromJson(map);
    }).toList();

    var shipReceiver = jsonMap["ShipReceiver"];
    if (shipReceiver != null) {
      orderLines = shipReceiver.map((map) {
        return ShipReceiver.fromJson(map);
      });
    }

    DateTime invoiceDate;
    String unixTimeStr =
        RegExp("\\d+").stringMatch(jsonMap["DateInvoice"]).toString();
    if (unixTimeStr != null) {
      int unixTime = int.parse(unixTimeStr);
      invoiceDate = DateTime.fromMillisecondsSinceEpoch(unixTime);
    }

    return new FastSaleDeliveryInvoice(
      id: jsonMap["Id"],
      partnerId: jsonMap["PartnerId"],
      discount: jsonMap["Discount"],
      discountAmount: jsonMap["DiscountAmount"],
      decreaseAmount: jsonMap["DecreaseAmount"],
      weightTotal: jsonMap["weightTotal"],
      userId: jsonMap["UserId"],
      userName: jsonMap["UserName"],
      dateInvoice: invoiceDate,
      companyId: jsonMap["CompanyId"],
      comment: jsonMap["Comment"],
      type: jsonMap["Type"],
      deliveryPrice: jsonMap["DeliveryPrice"],
      carrierId: jsonMap["CarrierId"],
      deliveryNote: jsonMap["DeliveryNote"],
      cashOnDelivery: jsonMap["CashOnDelivery"],
      paymentJournalId: jsonMap["PaymentJournalId"],
      shipWeight: jsonMap["ShipWeight"],
      oldCredit: jsonMap["OldCredit"],
      newCredit: jsonMap["NewCredit"],
      amountDeposit: jsonMap["AmountDeposit"],
      notModifyPriceFromSO: jsonMap["NotModifyPriceFromSO"],
      shipServiceId: jsonMap["ShipServiceId"],
      shipServiceName: jsonMap["ShipServiceName"],
      shipReceiver: shipReceiver,
      amountTotal: jsonMap["AmountTotal"],
      fastSaleOrderLine: orderLines,
      address: jsonMap["Address"],
      phone: jsonMap["Phone"],
      showState: jsonMap["ShowState"],
      partnerDisplayName: jsonMap["PartnerDisplayName"],
      partnerNameNoSign: jsonMap["PartnerNameNoSign"],
      number: jsonMap["Number"],
      carrierName: jsonMap["CarrierName"],
      trackingRef: jsonMap["TrackingRef"],
      shipPaymentStatus: jsonMap["ShipPaymentStatus"],
    );
  }
  Map toJson() {
    return {
      dateInvoice: "DateInvoice",
    };
  }
}

class DeliveryCarriers {
  String carrierId;

  DeliveryCarriers({this.carrierId});

  DeliveryCarriers.fromMap(Map<String, dynamic> jsonMap) {
    carrierId = jsonMap["CarrierId"];
  }
}
