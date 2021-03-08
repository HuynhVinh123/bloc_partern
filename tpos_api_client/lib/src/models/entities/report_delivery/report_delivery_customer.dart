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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PartnerId'] = partnerId;
    data['UserId'] = userId;
    data['UserName'] = userName;
    data['AmountTotal'] = amountTotal;
    data['PartnerDisplayName'] = partnerDisplayName;
    data['Address'] = address;
    data['Phone'] = phone;
    data['DeliveryPrice'] = deliveryPrice;
    data['Ship_Receiver_Phone'] = shipReceiverPhone;
    data['Ship_Receiver_Name'] = shipReceiverName;
    data['Ship_Receiver_Street'] = shipReceiverStreet;
    data['CashOnDelivery'] = cashOnDelivery;
    data['DiscountAmount'] = discountAmount;
    data['DateInvoice'] = dateInvoice;
    data['AmountDeposit'] = amountDeposit;
    data['TotalBill'] = totalBill;
    data['PartnerFacebookLink'] = partnerFacebookLink;
    data['TrackingUrl'] = trackingUrl;
    data['ShowShipStatus'] = showShipStatus;
    data['ShipStatus'] = shipStatus;
    data['CarrierDeliveryType'] = carrierDeliveryType;
    data['PartnerFacebookId'] = partnerFacebookId;
    data['Number'] = number;
    data['CarrierName'] = carrierName;
    data['TrackingRef'] = trackingRef;
    data['ShipPaymentStatus'] = shipPaymentStatus;
    data['CompanyName'] = companyName;
    data['CustomerDeliveryPrice'] = customerDeliveryPrice;
    data['WeightTotal'] = weightTotal;
    data['CarrierId'] = carrierId;
    return data;
  }
}
