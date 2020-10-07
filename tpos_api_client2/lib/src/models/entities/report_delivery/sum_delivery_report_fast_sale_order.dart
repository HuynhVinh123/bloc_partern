class SumDeliveryReportFastSaleOrder {
  int id;
  int sumQuantityCollectionOrder;
  double sumCollectionAmount;
  int sumQuantityRefundedOrder;
  double sumRefundedAmount;
  int sumQuantityPaymentOrder;
  double sumPaymentAmount;
  int sumQuantityDelivering;
  double sumDeliveringAmount;
  double sumOtherAmount;
  int sumQuantityOther;
  double sumAmountDeposit;
  int sumQuantityDeposit;

  SumDeliveryReportFastSaleOrder(
      {this.id,
      this.sumQuantityCollectionOrder,
      this.sumCollectionAmount,
      this.sumQuantityRefundedOrder,
      this.sumRefundedAmount,
      this.sumQuantityPaymentOrder,
      this.sumPaymentAmount,
      this.sumQuantityDelivering,
      this.sumDeliveringAmount,
      this.sumOtherAmount,
      this.sumQuantityOther,
      this.sumAmountDeposit,
      this.sumQuantityDeposit});

  SumDeliveryReportFastSaleOrder.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    sumQuantityCollectionOrder = json['SumQuantityCollectionOrder'];
    sumCollectionAmount = json['SumCollectionAmount']?.toDouble();
    sumQuantityRefundedOrder = json['SumQuantityRefundedOrder'];
    sumRefundedAmount = json['SumRefundedAmount']?.toDouble();
    sumQuantityPaymentOrder = json['SumQuantityPaymentOrder'];
    sumPaymentAmount = json['SumPaymentAmount']?.toDouble();
    sumQuantityDelivering = json['SumQuantityDelivering'];
    sumDeliveringAmount = json['SumDeliveringAmount']?.toDouble();
    sumOtherAmount = json['SumOtherAmount']?.toDouble();
    sumQuantityOther = json['SumQuantityOther'];
    sumAmountDeposit = json['SumAmountDeposit']?.toDouble();
    sumQuantityDeposit = json['SumQuantityDeposit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['SumQuantityCollectionOrder'] = this.sumQuantityCollectionOrder;
    data['SumCollectionAmount'] = this.sumCollectionAmount;
    data['SumQuantityRefundedOrder'] = this.sumQuantityRefundedOrder;
    data['SumRefundedAmount'] = this.sumRefundedAmount;
    data['SumQuantityPaymentOrder'] = this.sumQuantityPaymentOrder;
    data['SumPaymentAmount'] = this.sumPaymentAmount;
    data['SumQuantityDelivering'] = this.sumQuantityDelivering;
    data['SumDeliveringAmount'] = this.sumDeliveringAmount;
    data['SumOtherAmount'] = this.sumOtherAmount;
    data['SumQuantityOther'] = this.sumQuantityOther;
    data['SumAmountDeposit'] = this.sumAmountDeposit;
    data['SumQuantityDeposit'] = this.sumQuantityDeposit;
    return data;
  }
}
