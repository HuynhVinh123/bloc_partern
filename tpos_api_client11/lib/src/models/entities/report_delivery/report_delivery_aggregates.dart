class ReportDeliveryAggregates {
  AmountDeposit amountDeposit;
  PartnerDisplayName partnerDisplayName;
  AmountTotal amountTotal;
  CashOnDelivery cashOnDelivery;
  DeliveryPrice deliveryPrice;
  CustomerDeliveryPrice customerDeliveryPrice;
  WeightTotal weightTotal;

  ReportDeliveryAggregates(
      {this.partnerDisplayName,
      this.amountTotal,
      this.cashOnDelivery,
      this.deliveryPrice,
      this.amountDeposit,
      this.customerDeliveryPrice,
      this.weightTotal});

  ReportDeliveryAggregates.fromJson(Map<String, dynamic> json) {
    partnerDisplayName = json['PartnerDisplayName'] != null
        ? new PartnerDisplayName.fromJson(json['PartnerDisplayName'])
        : null;
    amountTotal = json['AmountTotal'] != null
        ? new AmountTotal.fromJson(json['AmountTotal'])
        : null;
    cashOnDelivery = json['CashOnDelivery'] != null
        ? new CashOnDelivery.fromJson(json['CashOnDelivery'])
        : null;
    deliveryPrice = json['DeliveryPrice'] != null
        ? DeliveryPrice.fromJson(json['DeliveryPrice'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (partnerDisplayName != null) {
      data['PartnerDisplayName'] = partnerDisplayName.toJson();
    }
    if (amountTotal != null) {
      data['AmountTotal'] = amountTotal.toJson();
    }
    if (cashOnDelivery != null) {
      data['CashOnDelivery'] = cashOnDelivery.toJson();
    }
    if (deliveryPrice != null) {
      data['DeliveryPrice'] = deliveryPrice.toJson();
    }
    return data;
  }
}

class PartnerDisplayName {
  int count;

  PartnerDisplayName({this.count});

  PartnerDisplayName.fromJson(Map<String, dynamic> json) {
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    return data;
  }
}

class AmountTotal {
  double sum;

  AmountTotal({this.sum});

  AmountTotal.fromJson(Map<String, dynamic> json) {
    sum = json['sum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sum'] = sum;
    return data;
  }
}

class CashOnDelivery {
  double sum;

  CashOnDelivery({this.sum});

  CashOnDelivery.fromJson(Map<String, dynamic> json) {
    sum = json['sum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sum'] = sum;
    return data;
  }
}

class DeliveryPrice {
  double sum;

  DeliveryPrice({this.sum});

  DeliveryPrice.fromJson(Map<String, dynamic> json) {
    sum = json['sum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sum'] = sum;
    return data;
  }
}

class AmountDeposit {
  double sum;

  AmountDeposit({this.sum});

  AmountDeposit.fromJson(Map<String, dynamic> json) {
    sum = json['sum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sum'] = this.sum;
    return data;
  }
}

class CustomerDeliveryPrice {
  double sum;

  CustomerDeliveryPrice({this.sum});

  CustomerDeliveryPrice.fromJson(Map<String, dynamic> json) {
    sum = json['sum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sum'] = sum;
    return data;
  }
}

class WeightTotal {
  WeightTotal({this.sum});
  WeightTotal.fromJson(Map<String, dynamic> json) {
    sum = json['sum'];
  }

  double sum;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sum'] = sum;
    return data;
  }
}