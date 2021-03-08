class ReportDeliveryOrderDetail {
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
      final String unixTimeStr =
          RegExp(r"(?<=Date\()\d+").stringMatch(json["DateInvoice"]);

      if (unixTimeStr != null && unixTimeStr.isNotEmpty) {
        final int unixTime = int.parse(unixTimeStr);
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['PartnerId'] = partnerId;
    data['PartnerDisplayName'] = partnerDisplayName;
    data['PartnerFacebookId'] = partnerFacebookId;
    data['PartnerFacebookLink'] = partnerFacebookLink;
    data['Address'] = address;
    data['Phone'] = phone;
    data['FacebookName'] = facebookName;
    data['FacebookNameNosign'] = facebookNameNosign;
    data['FacebookId'] = facebookId;
    data['DisplayFacebookName'] = displayFacebookName;
    data['Deliver'] = deliver;
    data['AmountTotal'] = amountTotal;
    data['UserId'] = userId;
    data['UserName'] = userName;
    data['DateInvoice'] = dateInvoice.toUtc().toIso8601String();
    data['State'] = state;
    data['ShowState'] = showState;
    data['CompanyId'] = companyId;
    data['Comment'] = comment;
    data['Residual'] = residual;
    data['Type'] = type;
    data['Number'] = number;
    data['PartnerNameNoSign'] = partnerNameNoSign;
    data['DeliveryPrice'] = deliveryPrice;
    data['CarrierId'] = carrierId;
    data['CarrierName'] = carrierName;
    data['CashOnDelivery'] = cashOnDelivery;
    data['TrackingRef'] = trackingRef;
    data['ShipStatus'] = shipStatus;
    data['ShowShipStatus'] = showShipStatus;
    data['CarrierDeliveryType'] = carrierDeliveryType;
    data['TrackingUrl'] = trackingUrl;
    data['WardName'] = wardName;
    data['DistrictName'] = districtName;
    data['CityName'] = cityName;
    data['FullAddress'] = fullAddress;
    data['WeightTotal'] = weightTotal;
    data['AmountTax'] = amountTax;
    data['AmountUntaxed'] = amountUntaxed;
    data['Discount'] = discount;
    data['DiscountAmount'] = discountAmount;
    data['DecreaseAmount'] = decreaseAmount;
    data['ShipPaymentStatus'] = shipPaymentStatus;
    data['CompanyName'] = companyName;
    data['Ship_Receiver_Name'] = shipReceiverName;
    data['Ship_Receiver_Phone'] = shipReceiverPhone;
    data['Ship_Receiver_Street'] = shipReceiverStreet;
    data['AmountDeposit'] = amountDeposit;
    data['CustomerDeliveryPrice'] = customerDeliveryPrice;
    data['CreatedById'] = createdById;
    data['DeliveryNote'] = deliveryNote;
    data['PartnerEmail'] = partnerEmail;
    return data;
  }
}
