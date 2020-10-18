class PartnerStaffDetailReport {
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
  List<Null> saleOnlineIds;
  List<Null> saleOnlineNames;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['PartnerId'] = this.partnerId;
    data['PartnerDisplayName'] = this.partnerDisplayName;
    data['PriceListId'] = this.priceListId;
    data['AmountTotal'] = this.amountTotal;
    data['UserId'] = this.userId;
    data['UserName'] = this.userName;
    data['DateInvoice'] = this.dateInvoice;
    data['State'] = this.state;
    data['ShowState'] = this.showState;
    data['CompanyId'] = this.companyId;
    data['Comment'] = this.comment;
    data['WarehouseId'] = this.warehouseId;
//    if (this.saleOnlineIds != null) {
//      data['SaleOnlineIds'] =
//          this.saleOnlineIds.map((v) => v.toJson()).toList();
//    }
//    if (this.saleOnlineNames != null) {
//      data['SaleOnlineNames'] =
//          this.saleOnlineNames.map((v) => v.toJson()).toList();
//    }
    data['Residual'] = this.residual;
    data['Type'] = this.type;
    data['RefundOrderId'] = this.refundOrderId;
    data['AccountId'] = this.accountId;
    data['JournalId'] = this.journalId;
    data['Number'] = this.number;
    data['PartnerNameNoSign'] = this.partnerNameNoSign;
    data['DeliveryPrice'] = this.deliveryPrice;
    data['CarrierId'] = this.carrierId;
    data['CarrierName'] = this.carrierName;
    data['CashOnDelivery'] = this.cashOnDelivery;
    data['TrackingRef'] = this.trackingRef;
    data['ShipStatus'] = this.shipStatus;
    data['ShowShipStatus'] = this.showShipStatus;
    data['SaleOnlineName'] = this.saleOnlineName;
    data['Discount'] = this.discount;
    data['DiscountAmount'] = this.discountAmount;
    data['DecreaseAmount'] = this.decreaseAmount;
    data['Deliver'] = this.deliver;
    data['ShipPaymentStatus'] = this.shipPaymentStatus;
    data['CompanyName'] = this.companyName;
    data['CarrierDeliveryType'] = this.carrierDeliveryType;
    return data;
  }
}
