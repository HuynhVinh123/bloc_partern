class AccountTaxFPO {
  AccountTaxFPO(
      {this.id,
      this.name,
      this.typeTaxUse,
      this.amountType,
      this.active,
      this.sequence,
      this.amount,
      this.accountId,
      this.refundAccountId,
      this.priceInclude,
      this.description,
      this.companyId,
      this.companyName});

  AccountTaxFPO.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    typeTaxUse = json['TypeTaxUse'];
    amountType = json['AmountType'];
    active = json['Active'];
    sequence = json['Sequence'];
    amount = json['Amount'];
    accountId = json['AccountId'];
    refundAccountId = json['RefundAccountId'];
    priceInclude = json['PriceInclude'];
    description = json['Description'];
    companyId = json['CompanyId'];
    companyName = json['CompanyName'];
  }
  int id;
  String name;
  String typeTaxUse;
  String amountType;
  bool active;
  int sequence;
  double amount;
  int accountId;
  int refundAccountId;
  bool priceInclude;
  dynamic description;
  int companyId;
  String companyName;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['TypeTaxUse'] = typeTaxUse;
    data['AmountType'] = amountType;
    data['Active'] = active;
    data['Sequence'] = sequence;
    data['Amount'] = amount;
    data['AccountId'] = accountId;
    data['RefundAccountId'] = refundAccountId;
    data['PriceInclude'] = priceInclude;
    data['Description'] = description;
    data['CompanyId'] = companyId;
    data['CompanyName'] = companyName;
    return data;
  }
}
