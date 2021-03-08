class SaleQuotation {
  SaleQuotation(
      {this.id,
      this.partner,
      this.dateQuotation,
      this.state,
      this.invoiceStatus,
      this.showInvoiceStatus,
      this.showState,
      this.amountTotal,
      this.name,
      this.user,
      this.partnerNameNoSign,
      this.isSelect});

  SaleQuotation.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    partner = json['Partner'];
    dateQuotation = json['DateQuotation'];
    state = json['State'];
    invoiceStatus = json['InvoiceStatus'];
    showInvoiceStatus = json['ShowInvoiceStatus'];
    showState = json['ShowState'];
    amountTotal = json['AmountTotal'];
    name = json['Name'];
    user = json['User'];
    partnerNameNoSign = json['PartnerNameNoSign'];
  }
  int id;
  String partner;
  String dateQuotation;
  String state;
  String invoiceStatus;
  String showInvoiceStatus;
  String showState;
  double amountTotal;
  String name;
  String user;
  String partnerNameNoSign;
  bool isSelect = false;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Partner'] = partner;
    data['DateQuotation'] = dateQuotation;
    data['State'] = state;
    data['InvoiceStatus'] = invoiceStatus;
    data['ShowInvoiceStatus'] = showInvoiceStatus;
    data['ShowState'] = showState;
    data['AmountTotal'] = amountTotal;
    data['Name'] = name;
    data['User'] = user;
    data['PartnerNameNoSign'] = partnerNameNoSign;
    return data;
  }
}
