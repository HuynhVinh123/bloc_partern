/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'package:tpos_api_client/tpos_api_client.dart';

class CreateInvoiceFromAppData {
  CreateInvoiceFromAppData(
      {this.id,
      this.name,
      this.partnerId,
      this.partner,
      this.partnerDisplayName,
      this.partnerEmail,
      this.partnerFacebookId,
      this.partnerFacebook,
      this.partnerPhone,
      this.priceListId,
      this.priceList,
      this.amountTotal,
      this.discount,
      this.discountAmount,
      this.decreaseAmount,
      this.weightTotal,
      this.amountTax,
      this.amountUntaxed,
      this.taxId,
      this.tax,
      this.userId,
      this.user,
      this.userName,
      this.dateInvoice,
      this.dateCreated,
      this.state,
      this.companyId,
      this.comment,
      this.warehouseId,
      this.warehouse,
      this.orderLines,
      this.residual,
      this.type,
      this.refundOrderId,
      this.refundOrder,
      this.accountId,
      this.account,
      this.journalId,
      this.journal,
      this.number,
      this.partnerNameNoSign,
      this.deliveryPrice,
      this.customerDeliveryPrice,
      this.carrierId,
      this.carrier,
      this.carrierName,
      this.carrierDeliveryType,
      this.deliveryNote,
      this.receiverName,
      this.receiverPhone,
      this.receiverAddress,
      this.receiverDate,
      this.receiverNote,
      this.cashOnDelivery,
      this.trackingRef,
      this.shipStatus,
      this.partnerShippingId,
      this.partnerShipping,
      this.paymentJournalId,
      this.paymentJournal,
      this.paymentAmount,
      this.saleOrderId,
      this.saleOrder,
      this.facebookName,
      this.facebookNameNosign,
      this.facebookId,
      this.displayFacebookName,
      this.deliver,
      this.shipWeight,
      this.shipPaymentStatus,
      this.oldCredit,
      this.newCredit,
      this.phone,
      this.address,
      this.amountTotalSigned,
      this.residualSigned,
      this.origin,
      this.amountDeposit,
      this.companyName,
      this.previousBalance,
      this.toPay,
      this.notModifyPriceFromSO,
      this.shipServiceId,
      this.shipServiceName,
      this.shipReceiver,
      this.saleOnlineIds,
      this.saleOnlineNames});

  CreateInvoiceFromAppData.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap["Id"];
    name = jsonMap["Name"];
    partnerId = jsonMap["PartnerId"];
    partner = jsonMap["Partner"];
    partnerDisplayName = jsonMap["PartnerDisplayName"];
    partnerEmail = jsonMap["PartnerEmail"];
    partnerFacebookId = jsonMap["PartnerFacebookId"];
    partnerId = jsonMap["PartnerId"];
    partnerFacebook = jsonMap["PartnerFacebook"];
    partnerPhone = jsonMap["PartnerPhone"];
    priceListId = jsonMap["PriceListId"];
    priceList = jsonMap["PriceList"];
    amountTotal = jsonMap["AmountTotal"];
    discount = jsonMap["Discount"];
    discountAmount = jsonMap["DiscountAmount"];
    decreaseAmount = (jsonMap["DecreaseAmount"])?.toDouble();
    weightTotal = jsonMap["WeightTotal"]?.toDouble();
    amountTax = jsonMap["AmountTax"];
    amountUntaxed = jsonMap["AmountUntaxed"];
    taxId = jsonMap["TaxId"];
    tax = jsonMap["Tax"];
    userId = jsonMap["UserId"];
    user = jsonMap["User"];
    userName = jsonMap["UserName"];
    dateInvoice = jsonMap["DateInvoice"];
    dateCreated = jsonMap["DateCreated"];
    state = jsonMap["State"];
    companyId = jsonMap["CompanyId"];
    comment = jsonMap["Comment"];
    warehouseId = jsonMap["WarehouseId"];
    warehouse = jsonMap["Warehouse"];
    residual = jsonMap["Residual"];
    type = jsonMap["Type"];
    refundOrderId = jsonMap["RefundOrderId"];
    refundOrder = jsonMap["RefundOrder"];
    accountId = jsonMap["AccountId"];
    account = jsonMap["Account"];
    journalId = jsonMap["JournalId"];
    journal = (jsonMap["Journal"])?.toDouble();
    number = jsonMap["Number"]?.toDouble();
    partnerNameNoSign = jsonMap["PartnerNameNoSign"];
    deliveryPrice = jsonMap["DeliveryPrice"];
    customerDeliveryPrice = jsonMap["CustomerDeliveryPrice"];
    carrierDeliveryType = jsonMap["CarrierDeliveryType"];
    deliveryNote = jsonMap["DeliveryNote"];
    receiverName = jsonMap["ReceiverName"];
    receiverPhone = jsonMap["ReceiverPhone"];
    receiverAddress = jsonMap["ReceiverAddress"];
    receiverDate = jsonMap["ReceiverDate"];
    receiverNote = jsonMap["ReceiverNote"];
    cashOnDelivery = jsonMap["CashOnDelivery"];
    trackingRef = jsonMap["TrackingRef"];
    shipStatus = jsonMap["ShipStatus"];
    partnerShippingId = (jsonMap["PartnerShippingId"])?.toDouble();
    partnerShipping = jsonMap["PartnerShipping"]?.toDouble();
    paymentJournalId = jsonMap["PaymentJournalId"];
    paymentJournal = jsonMap["PaymentJournal"];
    paymentAmount = jsonMap["PaymentAmount"];
    saleOrderId = jsonMap["SaleOrderId"];
    saleOrder = jsonMap["SaleOrder"];
    facebookName = jsonMap["FacebookName"];
    facebookNameNosign = jsonMap["FacebookNameNosign"];

    facebookId = jsonMap["facebookId"];
    deliver = jsonMap["Deliver"];
    shipWeight = jsonMap["ShipWeight"];
    shipPaymentStatus = jsonMap["ShipPaymentStatus"];
    oldCredit = jsonMap["OldCredit"];
    newCredit = jsonMap["NewCredit"];
    phone = (jsonMap["Phone"])?.toDouble();
    address = jsonMap["Address"]?.toDouble();
    amountTotalSigned = jsonMap["AmountTotalSigned"];
    residualSigned = jsonMap["ResidualSigned"];
    origin = jsonMap["Origin"];
    amountDeposit = jsonMap["AmountDeposit"];
    toPay = jsonMap["ToPay"];
    shipServiceId = jsonMap["Ship_ServiceId"];
    shipServiceName = jsonMap["Ship_ServiceName"];
    shipReceiver = CreateInvoiceFromAppRequestShipReceiver.fromJson(
        jsonMap["Ship_ServiceName"]);

    saleOnlineIds = jsonMap["SaleOnlineIds"]?.cast<String>();
    saleOnlineNames = jsonMap["SaleOnlineNames"]?.cast<String>();
  }
  int id;
  String name;
  int partnerId;
  Partner partner;
  String partnerDisplayName;
  String partnerEmail;
  String partnerFacebookId;
  String partnerFacebook;
  String partnerPhone;
  int priceListId;
  String priceList;
  double amountTotal;
  double discount;
  double discountAmount;
  double decreaseAmount;
  double weightTotal;
  double amountTax;
  double amountUntaxed;
  int taxId;
  String tax;
  int userId;
  String user;
  String userName;
  DateTime dateInvoice;
  DateTime dateCreated;
  String state;
  String companyId;
  String comment;
  int warehouseId;
  String warehouse;
  List<CreateInvoiceFromAppRequestOrderLine> orderLines;

  String residual;
  String type;
  String refundOrderId;
  String refundOrder;
  String accountId;
  String account;
  String journalId;
  String journal;
  int number;
  String partnerNameNoSign;
  double deliveryPrice;
  double customerDeliveryPrice;
  String carrierId;
  String carrier;
  String carrierName;
  String carrierDeliveryType;
  String deliveryNote;
  String receiverName;
  String receiverPhone;
  String receiverAddress;
  DateTime receiverDate;
  String receiverNote;
  double cashOnDelivery;
  String trackingRef;
  String shipStatus;
  String partnerShippingId;
  String partnerShipping;
  String paymentJournalId;
  String paymentJournal;
  double paymentAmount;
  String saleOrderId;
  String saleOrder;
  String facebookName;
  String facebookNameNosign;
  String facebookId;
  String displayFacebookName;
  String deliver;
  String shipWeight;
  String shipPaymentStatus;
  double oldCredit;
  double newCredit;
  String phone;
  String address;
  String amountTotalSigned;
  String residualSigned;
  String origin;
  double amountDeposit;
  String companyName;
  double previousBalance;
  String toPay;
  bool notModifyPriceFromSO;
  String shipServiceId;
  String shipServiceName;
  CreateInvoiceFromAppRequestShipReceiver shipReceiver;
  List<String> saleOnlineIds;
  List<String> saleOnlineNames;
  List<int> saleOrderIds;

  Map toJson() {
    return {
      "Id": id,
    };
  }
}

class CreateInvoiceFromAppRequestShipReceiver {
  CreateInvoiceFromAppRequestShipReceiver(
      {this.name,
      this.phone,
      this.street,
      this.city,
      this.district,
      this.ward});
  CreateInvoiceFromAppRequestShipReceiver.fromJson(Map jsonMap) {
    name = jsonMap["Name"];
    phone = jsonMap["Phone"];
    street = jsonMap["Street"];
    city = CityAddress.fromMap(jsonMap["City"]);
    district = DistrictAddress.fromMap(jsonMap["District"]);
    ward = WardAddress.fromMap(jsonMap["Ward"]);
  }
  String name;
  String phone;
  String street;
  CityAddress city;
  DistrictAddress district;
  WardAddress ward;

  Map toJson() {
    return {
      "Name": name,
      "Phone": phone,
      "Street": street,
      "City": city.toJson(),
      "District": district.toJson(),
      "Ward": ward.toJson(),
    };
  }
}

class CreateInvoiceFromAppRequestOrderLine {
  CreateInvoiceFromAppRequestOrderLine({
    this.id,
    this.productId,
    this.product,
    this.productUOMId,
    this.productUOM,
    this.priceUnit,
    this.productUOMQty,
    this.discount,
    this.discountFixed,
    this.priceTotal,
    this.priceSubTotal,
    this.weight,
    this.weightTotal,
    this.accountId,
    this.account,
    this.priceRecent,
    this.productName,
    this.productUOMName,
    this.saleLineIds,
    this.productNameGet,
    this.saleLineId,
    this.saleLine,
    this.type,
    this.promotionProgramId,
    this.note,
  });

  CreateInvoiceFromAppRequestOrderLine.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap["Id"];
    productId = jsonMap["ProductId"];
    product = jsonMap["Product"];
    productUOMId = jsonMap["ProductUOMId"];
    productUOM = jsonMap["ProductUOM"];
    priceUnit = jsonMap["PriceUnit"];
    productUOMQty = jsonMap["ProductUOMQty"];
    discount = jsonMap["Discount"];
    discountFixed = jsonMap["Discount_Fixed"];
    priceTotal = jsonMap["PriceTotal"];
    priceSubTotal = jsonMap["PriceSubTotal"];
    weight = jsonMap["Weight"];
    weightTotal = jsonMap["WeightTotal"];
    accountId = jsonMap["AccountId"];
    account = jsonMap["Account"];
    priceRecent = jsonMap["PriceRecent"];
    productName = jsonMap["ProductName"];
    productUOMName = jsonMap["ProductUOMName"];
    saleLineIds =
        (jsonMap["SaleLineIds"] as List).map((f) => int.parse(f)).toList();
    productNameGet = jsonMap["ProductNameGet"];
    saleLineId = jsonMap["SaleLineId"];
    saleLine = jsonMap["SaleLine"];
    type = jsonMap["Type"];
    promotionProgramId = jsonMap["PromotionProgramId"];
    note = jsonMap["Note"];
  }

  int id;
  int productId;
  dynamic product;
  int productUOMId;
  dynamic productUOM;
  double priceUnit;
  double productUOMQty;
  double discount;
  double discountFixed;
  double priceTotal;
  double priceSubTotal;
  double weight;
  double weightTotal;
  int accountId;
  Object account;
  double priceRecent;
  String productName;
  String productUOMName;
  List<int> saleLineIds;
  String productNameGet;
  int saleLineId;
  dynamic saleLine;
  String type;
  dynamic promotionProgramId;
  String note;

  Map toJson() {
    return {
      "Id": id,
      "ProductId": productId,
      "Product": product,
      "ProductUOMId": productUOMId,
      "ProductUOM": productUOM,
      "PriceUnit": priceUnit,
      "ProductUOMQty": productUOMQty,
      "Discount": discount,
      "Discount_Fixed": discountFixed,
      "PriceTotal": priceTotal,
      "PriceSubTotal": priceSubTotal,
      "Weight": weight,
      "WeightTotal": weightTotal,
      "AccountId": accountId,
      "Account": account,
      "PriceRecent": priceRecent,
      "ProductName": productName,
      "ProductUOMName": productUOMName,
      "SaleLineIds": saleLineIds,
      "ProductNameGet": productNameGet,
      "SaleLineId": saleLineId,
      "SaleLine": saleLine,
      "Type": type,
      "PromotionProgramId": promotionProgramId,
      "Note": note,
    };
  }
}

class GetSaleOnlineOrderFromAppResult {
  GetSaleOnlineOrderFromAppResult(
      {this.id, this.success, this.data, this.message});
  GetSaleOnlineOrderFromAppResult.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap["Id"];
    success = jsonMap["success"];
    data = jsonMap["data"];
    message = jsonMap["message"];
  }
  int id;
  bool success;
  Map data;
  String message;
}
