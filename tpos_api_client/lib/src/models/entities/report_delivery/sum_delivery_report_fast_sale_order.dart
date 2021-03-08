class SumDeliveryReportFastSaleOrder {
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['SumQuantityCollectionOrder'] = sumQuantityCollectionOrder;
    data['SumCollectionAmount'] = sumCollectionAmount;
    data['SumQuantityRefundedOrder'] = sumQuantityRefundedOrder;
    data['SumRefundedAmount'] = sumRefundedAmount;
    data['SumQuantityPaymentOrder'] = sumQuantityPaymentOrder;
    data['SumPaymentAmount'] = sumPaymentAmount;
    data['SumQuantityDelivering'] = sumQuantityDelivering;
    data['SumDeliveringAmount'] = sumDeliveringAmount;
    data['SumOtherAmount'] = sumOtherAmount;
    data['SumQuantityOther'] = sumQuantityOther;
    data['SumAmountDeposit'] = sumAmountDeposit;
    data['SumQuantityDeposit'] = sumQuantityDeposit;
    return data;
  }
}
