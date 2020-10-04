class ReportDeliveryOrderDetail {
  int id;
  String name;
  int partnerId;
  String partnerDisplayName;
  String partnerFacebookId;
  String partnerFacebookLink;
  String address;
  String phone;
  String facebookName;
  String facebookNameNosign;
  String facebookId;
  String displayFacebookName;
  String deliver;
  double amountTotal;
  String userId;
  String userName;
  DateTime dateInvoice;
  String state;
  String showState;
  int companyId;
  String comment;
  double residual;
  String type;
  String number;
  String partnerNameNoSign;
  double deliveryPrice;
  int carrierId;
  String carrierName;
  double cashOnDelivery;
  String trackingRef;
  String shipStatus;
  String showShipStatus;
  String carrierDeliveryType;
  String trackingUrl;
  String wardName;
  String districtName;
  String cityName;
  String fullAddress;
  double weightTotal;
  double amountTax;
  double amountUntaxed;
  double discount;
  double discountAmount;
  double decreaseAmount;
  String shipPaymentStatus;
  String companyName;
  String shipReceiverName;
  String shipReceiverPhone;
  String shipReceiverStreet;
  double amountDeposit;
  double customerDeliveryPrice;
  String createdById;
  String deliveryNote;
  String partnerEmail;

  ReportDeliveryOrderDetail(
      {this.id,
      this.name,
      this.partnerId,
      this.partnerDisplayName,
      this.partnerFacebookId,
      this.partnerFacebookLink,
      this.address,
      this.phone,
      this.facebookName,
      this.facebookNameNosign,
      this.facebookId,
      this.displayFacebookName,
      this.deliver,
      this.amountTotal,
      this.userId,
      this.userName,
      this.dateInvoice,
      this.state,
      this.showState,
      this.companyId,
      this.comment,
      this.residual,
      this.type,
      this.number,
      this.partnerNameNoSign,
      this.deliveryPrice,
      this.carrierId,
      this.carrierName,
      this.cashOnDelivery,
      this.trackingRef,
      this.shipStatus,
      this.showShipStatus,
      this.carrierDeliveryType,
      this.trackingUrl,
      this.wardName,
      this.districtName,
      this.cityName,
      this.fullAddress,
      this.weightTotal,
      this.amountTax,
      this.amountUntaxed,
      this.discount,
      this.discountAmount,
      this.decreaseAmount,
      this.shipPaymentStatus,
      this.companyName,
      this.shipReceiverName,
      this.shipReceiverPhone,
      this.shipReceiverStreet,
      this.amountDeposit,
      this.customerDeliveryPrice,
      this.createdById,
      this.deliveryNote,
      this.partnerEmail});

  ReportDeliveryOrderDetail.fromJson(Map<String, dynamic> json) {
    if (json["DateInvoice"] != null) {
      String unixTimeStr =
          RegExp(r"(?<=Date\()\d+").stringMatch(json["DateInvoice"]);

      if (unixTimeStr != null && unixTimeStr.isNotEmpty) {
        int unixTime = int.parse(unixTimeStr);
        dateInvoice = DateTime.fromMillisecondsSinceEpoch(unixTime);
      } else {
        if (json["DateInvoice"] != null) {
          dateInvoice = DateTime.parse(json["DateInvoice"]).toLocal();
        }
      }
    }
    id = json['Id'];
    name = json['Name'];
    partnerId = json['PartnerId'];
    partnerDisplayName = json['PartnerDisplayName'];
    partnerFacebookId = json['PartnerFacebookId'];
    partnerFacebookLink = json['PartnerFacebookLink'];
    address = json['Address'];
    phone = json['Phone'];
    facebookName = json['FacebookName'];
    facebookNameNosign = json['FacebookNameNosign'];
    facebookId = json['FacebookId'];
    displayFacebookName = json['DisplayFacebookName'];
    deliver = json['Deliver'];
    amountTotal = json['AmountTotal'];
    userId = json['UserId'];
    userName = json['UserName'];
//    dateInvoice = json['DateInvoice'];
    state = json['State'];
    showState = json['ShowState'];
    companyId = json['CompanyId'];
    comment = json['Comment'];
    residual = json['Residual'];
    type = json['Type'];
    number = json['Number'];
    partnerNameNoSign = json['PartnerNameNoSign'];
    deliveryPrice = json['DeliveryPrice'];
    carrierId = json['CarrierId'];
    carrierName = json['CarrierName'];
    cashOnDelivery = json['CashOnDelivery'];
    trackingRef = json['TrackingRef'];
    shipStatus = json['ShipStatus'];
    showShipStatus = json['ShowShipStatus'];
    carrierDeliveryType = json['CarrierDeliveryType'];
    trackingUrl = json['TrackingUrl'];
    wardName = json['WardName'];
    districtName = json['DistrictName'];
    cityName = json['CityName'];
    fullAddress = json['FullAddress'];
    weightTotal = json['WeightTotal'];
    amountTax = json['AmountTax'];
    amountUntaxed = json['AmountUntaxed'];
    discount = json['Discount'];
    discountAmount = json['DiscountAmount'];
    decreaseAmount = json['DecreaseAmount'];
    shipPaymentStatus = json['ShipPaymentStatus'];
    companyName = json['CompanyName'];
    shipReceiverName = json['Ship_Receiver_Name'];
    shipReceiverPhone = json['Ship_Receiver_Phone'];
    shipReceiverStreet = json['Ship_Receiver_Street'];
    amountDeposit = json['AmountDeposit'];
    customerDeliveryPrice = json['CustomerDeliveryPrice'];
    createdById = json['CreatedById'];
    deliveryNote = json['DeliveryNote'];
    partnerEmail = json['PartnerEmail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['PartnerId'] = this.partnerId;
    data['PartnerDisplayName'] = this.partnerDisplayName;
    data['PartnerFacebookId'] = this.partnerFacebookId;
    data['PartnerFacebookLink'] = this.partnerFacebookLink;
    data['Address'] = this.address;
    data['Phone'] = this.phone;
    data['FacebookName'] = this.facebookName;
    data['FacebookNameNosign'] = this.facebookNameNosign;
    data['FacebookId'] = this.facebookId;
    data['DisplayFacebookName'] = this.displayFacebookName;
    data['Deliver'] = this.deliver;
    data['AmountTotal'] = this.amountTotal;
    data['UserId'] = this.userId;
    data['UserName'] = this.userName;
    data['DateInvoice'] = this.dateInvoice.toUtc().toIso8601String();
    data['State'] = this.state;
    data['ShowState'] = this.showState;
    data['CompanyId'] = this.companyId;
    data['Comment'] = this.comment;
    data['Residual'] = this.residual;
    data['Type'] = this.type;
    data['Number'] = this.number;
    data['PartnerNameNoSign'] = this.partnerNameNoSign;
    data['DeliveryPrice'] = this.deliveryPrice;
    data['CarrierId'] = this.carrierId;
    data['CarrierName'] = this.carrierName;
    data['CashOnDelivery'] = this.cashOnDelivery;
    data['TrackingRef'] = this.trackingRef;
    data['ShipStatus'] = this.shipStatus;
    data['ShowShipStatus'] = this.showShipStatus;
    data['CarrierDeliveryType'] = this.carrierDeliveryType;
    data['TrackingUrl'] = this.trackingUrl;
    data['WardName'] = this.wardName;
    data['DistrictName'] = this.districtName;
    data['CityName'] = this.cityName;
    data['FullAddress'] = this.fullAddress;
    data['WeightTotal'] = this.weightTotal;
    data['AmountTax'] = this.amountTax;
    data['AmountUntaxed'] = this.amountUntaxed;
    data['Discount'] = this.discount;
    data['DiscountAmount'] = this.discountAmount;
    data['DecreaseAmount'] = this.decreaseAmount;
    data['ShipPaymentStatus'] = this.shipPaymentStatus;
    data['CompanyName'] = this.companyName;
    data['Ship_Receiver_Name'] = this.shipReceiverName;
    data['Ship_Receiver_Phone'] = this.shipReceiverPhone;
    data['Ship_Receiver_Street'] = this.shipReceiverStreet;
    data['AmountDeposit'] = this.amountDeposit;
    data['CustomerDeliveryPrice'] = this.customerDeliveryPrice;
    data['CreatedById'] = this.createdById;
    data['DeliveryNote'] = this.deliveryNote;
    data['PartnerEmail'] = this.partnerEmail;
    return data;
  }
}
