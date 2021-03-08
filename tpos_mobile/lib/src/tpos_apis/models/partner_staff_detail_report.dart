class PartnerStaffDetailReport {
  PartnerStaffDetailReport(
      {this.id,
      this.name,
      this.partnerId,
      this.partnerDisplayName,
      this.priceListId,
      this.amountTotal,
      this.userId,
      this.userName,
      this.dateInvoice,
      this.state,
      this.showState,
      this.companyId,
      this.comment,
      this.warehouseId,
      this.saleOnlineIds,
      this.saleOnlineNames,
      this.residual,
      this.type,
      this.refundOrderId,
      this.accountId,
      this.journalId,
      this.number,
      this.partnerNameNoSign,
      this.deliveryPrice,
      this.carrierId,
      this.carrierName,
      this.cashOnDelivery,
      this.trackingRef,
      this.shipStatus,
      this.showShipStatus,
      this.saleOnlineName,
      this.discount,
      this.discountAmount,
      this.decreaseAmount,
      this.deliver,
      this.shipPaymentStatus,
      this.companyName,
      this.carrierDeliveryType,
      this.totalItem});

  PartnerStaffDetailReport.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    partnerId = json['PartnerId'];
    partnerDisplayName = json['PartnerDisplayName'];
    priceListId = json['PriceListId'];
    amountTotal = json['AmountTotal'];
    userId = json['UserId'];
    userName = json['UserName'];
    dateInvoice = json['DateInvoice'];
    state = json['State'];
    showState = json['ShowState'];
    companyId = json['CompanyId'];
    comment = json['Comment'];
    warehouseId = json['WarehouseId'];
//    if (json['SaleOnlineIds'] != null) {
//      saleOnlineIds = new List<Null>();
//      json['SaleOnlineIds'].forEach((v) {
//        saleOnlineIds.add(new Null.fromJson(v));
//      });
//    }
//    if (json['SaleOnlineNames'] != null) {
//      saleOnlineNames = new List<Null>();
//      json['SaleOnlineNames'].forEach((v) {
//        saleOnlineNames.add(new Null.fromJson(v));
//      });
//    }
    residual = json['Residual'];
    type = json['Type'];
    refundOrderId = json['RefundOrderId'];
    accountId = json['AccountId'];
    journalId = json['JournalId'];
    number = json['Number'];
    partnerNameNoSign = json['PartnerNameNoSign'];
    deliveryPrice = json['DeliveryPrice'];
    carrierId = json['CarrierId'];
    carrierName = json['CarrierName'];
    cashOnDelivery = json['CashOnDelivery'];
    trackingRef = json['TrackingRef'];
    shipStatus = json['ShipStatus'];
    showShipStatus = json['ShowShipStatus'];
    saleOnlineName = json['SaleOnlineName'];
    discount = json['Discount'];
    discountAmount = json['DiscountAmount'];
    decreaseAmount = json['DecreaseAmount'];
    deliver = json['Deliver'];
    shipPaymentStatus = json['ShipPaymentStatus'];
    companyName = json['CompanyName'];
    carrierDeliveryType = json['CarrierDeliveryType'];
  }
  int id;
  String name;
  int partnerId;
  String partnerDisplayName;
  int priceListId;
  double amountTotal;
  int userId;
  String userName;
  String dateInvoice;
  String state;
  String showState;
  int companyId;
  String comment;
  int warehouseId;
  List<dynamic> saleOnlineIds;
  List<dynamic> saleOnlineNames;
  double residual;
  String type;
  int refundOrderId;
  int accountId;
  int journalId;
  String number;
  String partnerNameNoSign;
  int deliveryPrice;
  int carrierId;
  String carrierName;
  int cashOnDelivery;
  String trackingRef;
  String shipStatus;
  String showShipStatus;
  String saleOnlineName;
  double discount;
  double discountAmount;
  double decreaseAmount;
  double deliver;
  String shipPaymentStatus;
  String companyName;
  String carrierDeliveryType;
  int totalItem;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['PartnerId'] = partnerId;
    data['PartnerDisplayName'] = partnerDisplayName;
    data['PriceListId'] = priceListId;
    data['AmountTotal'] = amountTotal;
    data['UserId'] = userId;
    data['UserName'] = userName;
    data['DateInvoice'] = dateInvoice;
    data['State'] = state;
    data['ShowState'] = showState;
    data['CompanyId'] = companyId;
    data['Comment'] = comment;
    data['WarehouseId'] = warehouseId;
//    if (saleOnlineIds != null) {
//      data['SaleOnlineIds'] =
//          saleOnlineIds.map((v) => v.toJson()).toList();
//    }
//    if (saleOnlineNames != null) {
//      data['SaleOnlineNames'] =
//          saleOnlineNames.map((v) => v.toJson()).toList();
//    }
    data['Residual'] = residual;
    data['Type'] = type;
    data['RefundOrderId'] = refundOrderId;
    data['AccountId'] = accountId;
    data['JournalId'] = journalId;
    data['Number'] = number;
    data['PartnerNameNoSign'] = partnerNameNoSign;
    data['DeliveryPrice'] = deliveryPrice;
    data['CarrierId'] = carrierId;
    data['CarrierName'] = carrierName;
    data['CashOnDelivery'] = cashOnDelivery;
    data['TrackingRef'] = trackingRef;
    data['ShipStatus'] = shipStatus;
    data['ShowShipStatus'] = showShipStatus;
    data['SaleOnlineName'] = saleOnlineName;
    data['Discount'] = discount;
    data['DiscountAmount'] = discountAmount;
    data['DecreaseAmount'] = decreaseAmount;
    data['Deliver'] = deliver;
    data['ShipPaymentStatus'] = shipPaymentStatus;
    data['CompanyName'] = companyName;
    data['CarrierDeliveryType'] = carrierDeliveryType;
    return data;
  }
}
