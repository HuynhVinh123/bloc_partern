class ReportDeliveryAggregates {
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
        ? PartnerDisplayName.fromJson(json['PartnerDisplayName'])
        : null;
    amountTotal = json['AmountTotal'] != null
        ? AmountTotal.fromJson(json['AmountTotal'])
        : null;
    cashOnDelivery = json['CashOnDelivery'] != null
        ? CashOnDelivery.fromJson(json['CashOnDelivery'])
        : null;
    deliveryPrice = json['DeliveryPrice'] != null
        ? DeliveryPrice.fromJson(json['DeliveryPrice'])
        : null;
  }

  AmountDeposit amountDeposit;
  PartnerDisplayName partnerDisplayName;
  AmountTotal amountTotal;
  CashOnDelivery cashOnDelivery;
  DeliveryPrice deliveryPrice;
  CustomerDeliveryPrice customerDeliveryPrice;
  WeightTotal weightTotal;

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
  PartnerDisplayName({this.count});

  PartnerDisplayName.fromJson(Map<String, dynamic> json) {
    count = json['count'];
  }
  int count;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    return data;
  }
}

class AmountTotal {
  AmountTotal({this.sum});

  AmountTotal.fromJson(Map<String, dynamic> json) {
    sum = json['sum'];
  }
  double sum;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sum'] = sum;
    return data;
  }
}

class CashOnDelivery {
  CashOnDelivery({this.sum});

  CashOnDelivery.fromJson(Map<String, dynamic> json) {
    sum = json['sum'];
  }
  double sum;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sum'] = sum;
    return data;
  }
}

class DeliveryPrice {
  DeliveryPrice({this.sum});

  DeliveryPrice.fromJson(Map<String, dynamic> json) {
    sum = json['sum'];
  }
  double sum;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sum'] = sum;
    return data;
  }
}

class AmountDeposit {
  AmountDeposit({this.sum});

  AmountDeposit.fromJson(Map<String, dynamic> json) {
    sum = json['sum'];
  }
  double sum;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sum'] = sum;
    return data;
  }
}

class CustomerDeliveryPrice {
  CustomerDeliveryPrice({this.sum});

  CustomerDeliveryPrice.fromJson(Map<String, dynamic> json) {
    sum = json['sum'];
  }
  double sum;

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
