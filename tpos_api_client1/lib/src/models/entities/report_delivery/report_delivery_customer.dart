class ReportDeliveryCustomer {
  ReportDeliveryCustomer(
      {this.partnerId,
      this.userId,
      this.userName,
      this.amountTotal,
      this.partnerDisplayName,
      this.address,
      this.phone,
      this.deliveryPrice,
      this.shipReceiverPhone,
      this.shipReceiverName,
      this.shipReceiverStreet,
      this.cashOnDelivery,
      this.discountAmount,
      this.dateInvoice,
      this.amountDeposit,
      this.totalBill,
      this.partnerFacebookLink,
      this.trackingUrl,
      this.showShipStatus,
      this.shipStatus,
      this.carrierDeliveryType,
      this.partnerFacebookId,
      this.number,
      this.carrierName,
      this.trackingRef,
      this.shipPaymentStatus,
      this.companyName,
      this.customerDeliveryPrice,
      this.weightTotal,
      this.carrierId});

  ReportDeliveryCustomer.fromJson(Map<String, dynamic> json) {
    partnerId = json['PartnerId'];
    userId = json['UserId'];
    userName = json['UserName'];
    amountTotal = json['AmountTotal'];
    partnerDisplayName = json['PartnerDisplayName'];
    address = json['Address'];
    phone = json['Phone'];
    deliveryPrice = json['DeliveryPrice'];
    shipReceiverPhone = json['Ship_Receiver_Phone'];
    shipReceiverName = json['Ship_Receiver_Name'];
    shipReceiverStreet = json['Ship_Receiver_Street'];
    cashOnDelivery = json['CashOnDelivery'];
    discountAmount = json['DiscountAmount'];
    dateInvoice = json['DateInvoice'];
    amountDeposit = json['AmountDeposit'];
    totalBill = json['TotalBill'];
    partnerFacebookLink = json['PartnerFacebookLink'];
    trackingUrl = json['TrackingUrl'];
    showShipStatus = json['ShowShipStatus'];
    shipStatus = json['ShipStatus'];
    carrierDeliveryType = json['CarrierDeliveryType'];
    partnerFacebookId = json['PartnerFacebookId'];
    number = json['Number'];
    carrierName = json['CarrierName'];
    trackingRef = json['TrackingRef'];
    shipPaymentStatus = json['ShipPaymentStatus'];
    companyName = json['CompanyName'];
    customerDeliveryPrice = json['CustomerDeliveryPrice'];
    weightTotal = json['WeightTotal'];
    carrierId = json['CarrierId'];
  }

  int partnerId;
  String userId;
  String userName;
  double amountTotal;
  String partnerDisplayName;
  String address;
  String phone;
  double deliveryPrice;
  String shipReceiverPhone;
  String shipReceiverName;
  String shipReceiverStreet;
  double cashOnDelivery;
  double discountAmount;
  String dateInvoice;
  double amountDeposit;
  int totalBill;
  String partnerFacebookLink;
  String trackingUrl;
  String showShipStatus;
  String shipStatus;
  String carrierDeliveryType;
  String partnerFacebookId;
  dynamic number;
  String carrierName;
  dynamic trackingRef;
  dynamic shipPaymentStatus;
  String companyName;
  double customerDeliveryPrice;
  int weightTotal;
  dynamic carrierId;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PartnerId'] = this.partnerId;
    data['UserId'] = this.userId;
    data['UserName'] = this.userName;
    data['AmountTotal'] = this.amountTotal;
    data['PartnerDisplayName'] = this.partnerDisplayName;
    data['Address'] = this.address;
    data['Phone'] = this.phone;
    data['DeliveryPrice'] = this.deliveryPrice;
    data['Ship_Receiver_Phone'] = this.shipReceiverPhone;
    data['Ship_Receiver_Name'] = this.shipReceiverName;
    data['Ship_Receiver_Street'] = this.shipReceiverStreet;
    data['CashOnDelivery'] = this.cashOnDelivery;
    data['DiscountAmount'] = this.discountAmount;
    data['DateInvoice'] = this.dateInvoice;
    data['AmountDeposit'] = this.amountDeposit;
    data['TotalBill'] = this.totalBill;
    data['PartnerFacebookLink'] = this.partnerFacebookLink;
    data['TrackingUrl'] = this.trackingUrl;
    data['ShowShipStatus'] = this.showShipStatus;
    data['ShipStatus'] = this.shipStatus;
    data['CarrierDeliveryType'] = this.carrierDeliveryType;
    data['PartnerFacebookId'] = this.partnerFacebookId;
    data['Number'] = this.number;
    data['CarrierName'] = this.carrierName;
    data['TrackingRef'] = this.trackingRef;
    data['ShipPaymentStatus'] = this.shipPaymentStatus;
    data['CompanyName'] = this.companyName;
    data['CustomerDeliveryPrice'] = this.customerDeliveryPrice;
    data['WeightTotal'] = this.weightTotal;
    data['CarrierId'] = this.carrierId;
    return data;
  }
}
