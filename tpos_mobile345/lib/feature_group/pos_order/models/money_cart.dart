class MoneyCart {
  MoneyCart(
      {this.discountMethod,
      this.discount,
      this.position,
      this.partnerId,
      this.taxId,
      this.amountTax});

  MoneyCart.fromJson(Map<String, dynamic> json) {
    discountMethod = json['discountMethod'];
    discount = json['discount'];
    position = json['position'];
    partnerId = json['partnerId'];
    taxId = json['taxId'];

    amountTax = json['amountTax'];
  }

  int discountMethod;
  double discount;
  String position;
  int partnerId;
  int taxId;
  double amountTax;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['discountMethod'] = discountMethod;
    data['discount'] = discount;
    data['position'] = position;
    data['partnerId'] = partnerId;
    data['taxId'] = taxId;
    data['amountTax'] = amountTax;

    return data;
  }
}
