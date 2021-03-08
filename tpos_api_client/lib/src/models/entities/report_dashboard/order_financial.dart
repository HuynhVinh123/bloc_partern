class OrderFinancial {
  OrderFinancial(
      {this.id,
      this.date,
      this.amountSale,
      this.refundSale,
      this.capitalSale,
      this.capitalRefund,
      this.profit,
      this.amountProfit,
      this.amountProfitNoTax,
      this.orderCode,
      this.quantitySale,
      this.quantityRefund,
      this.fastId,
      this.pOSId,
      this.typeFast,
      this.productName,
      this.url,
      this.amountTotalByOrder,
      this.promotion,
      this.staffId,
      this.staffName,
      this.customerId,
      this.customerName,
      this.productId,
      this.revenue,
      this.companyName,
      this.companyId,
      this.categId,
      this.defaultCode,
      this.userId,
      this.userName,
      this.amountTax,
      this.orderCount,
      this.refundAmountTax,
      this.refundOrderId});

  OrderFinancial.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    date = DateTime.parse(json['Date']);
    amountSale = json['AmountSale'];
    refundSale = json['RefundSale'];
    capitalSale = json['CapitalSale'];
    capitalRefund = json['CapitalRefund'];
    profit = json['Profit'];
    amountProfit = json['AmountProfit'];
    amountProfitNoTax = json['AmountProfitNoTax'];
    orderCode = json['OrderCode'];
    quantitySale = json['QuantitySale'];
    quantityRefund = json['QuantityRefund'];
    fastId = json['FastId'];
    pOSId = json['POSId'];
    typeFast = json['TypeFast'];
    productName = json['ProductName'];
    url = json['Url'];
    amountTotalByOrder = json['AmountTotalByOrder'];
    promotion = json['Promotion'];
    staffId = json['StaffId'];
    staffName = json['StaffName'];
    customerId = json['CustomerId'];
    customerName = json['CustomerName'];
    productId = json['ProductId'];
    revenue = json['Revenue'];
    companyName = json['CompanyName'];
    companyId = json['CompanyId'];
    categId = json['CategId'];
    defaultCode = json['DefaultCode'];
    userId = json['UserId'];
    userName = json['UserName'];
    amountTax = json['AmountTax'];
    orderCount = json['OrderCount'];
    refundAmountTax = json['RefundAmountTax'];
    refundOrderId = json['RefundOrderId'];
  }

  String id;
  DateTime date;
  dynamic amountSale;
  double refundSale;
  dynamic capitalSale;
  dynamic capitalRefund;
  dynamic profit;
  dynamic amountProfit;
  dynamic amountProfitNoTax;
  String orderCode;
  double quantitySale;
  double quantityRefund;
  int fastId;
  dynamic pOSId;
  dynamic typeFast;
  dynamic productName;
  String url;
  double amountTotalByOrder;
  dynamic promotion;
  dynamic staffId;
  dynamic staffName;
  dynamic customerId;
  String customerName;
  dynamic productId;
  dynamic revenue;
  dynamic companyName;
  int companyId;
  dynamic categId;
  dynamic defaultCode;
  dynamic userId;
  dynamic userName;
  dynamic amountTax;
  int orderCount;
  dynamic refundAmountTax;
  dynamic refundOrderId;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Date'] = date;
    data['AmountSale'] = amountSale;
    data['RefundSale'] = refundSale;
    data['CapitalSale'] = capitalSale;
    data['CapitalRefund'] = capitalRefund;
    data['Profit'] = profit;
    data['AmountProfit'] = amountProfit;
    data['AmountProfitNoTax'] = amountProfitNoTax;
    data['OrderCode'] = orderCode;
    data['QuantitySale'] = quantitySale;
    data['QuantityRefund'] = quantityRefund;
    data['FastId'] = fastId;
    data['POSId'] = pOSId;
    data['TypeFast'] = typeFast;
    data['ProductName'] = productName;
    data['Url'] = url;
    data['AmountTotalByOrder'] = amountTotalByOrder;
    data['Promotion'] = promotion;
    data['StaffId'] = staffId;
    data['StaffName'] = staffName;
    data['CustomerId'] = customerId;
    data['CustomerName'] = customerName;
    data['ProductId'] = productId;
    data['Revenue'] = revenue;
    data['CompanyName'] = companyName;
    data['CompanyId'] = companyId;
    data['CategId'] = categId;
    data['DefaultCode'] = defaultCode;
    data['UserId'] = userId;
    data['UserName'] = userName;
    data['AmountTax'] = amountTax;
    data['OrderCount'] = orderCount;
    data['RefundAmountTax'] = refundAmountTax;
    data['RefundOrderId'] = refundOrderId;
    return data;
  }
}
