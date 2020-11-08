class Invoice {
  Invoice(
      {this.id,
      this.amountTotal,
      this.pOSReference,
      this.dateOrder,
      this.userName,
      this.partnerName,
      this.name});

  Invoice.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    amountTotal = json['AmountTotal'];
    pOSReference = json['POSReference'];
    dateOrder = json['DateOrder'];
    userName = json['UserName'];
    partnerName = json['PartnerName'];
    name = json['Name'];
  }

  int id;
  double amountTotal;
  String pOSReference;
  String dateOrder;
  String userName;
  String partnerName;
  String name;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['AmountTotal'] = amountTotal;
    data['POSReference'] = pOSReference;
    data['DateOrder'] = dateOrder;
    data['UserName'] = userName;
    data['PartnerName'] = partnerName;
    data['Name'] = name;
    return data;
  }
}
