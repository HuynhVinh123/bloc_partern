class SaleQuotation {
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Partner'] = this.partner;
    data['DateQuotation'] = this.dateQuotation;
    data['State'] = this.state;
    data['InvoiceStatus'] = this.invoiceStatus;
    data['ShowInvoiceStatus'] = this.showInvoiceStatus;
    data['ShowState'] = this.showState;
    data['AmountTotal'] = this.amountTotal;
    data['Name'] = this.name;
    data['User'] = this.user;
    data['PartnerNameNoSign'] = this.partnerNameNoSign;
    return data;
  }
}
