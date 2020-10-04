class AccountTaxFPO {
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['TypeTaxUse'] = this.typeTaxUse;
    data['AmountType'] = this.amountType;
    data['Active'] = this.active;
    data['Sequence'] = this.sequence;
    data['Amount'] = this.amount;
    data['AccountId'] = this.accountId;
    data['RefundAccountId'] = this.refundAccountId;
    data['PriceInclude'] = this.priceInclude;
    data['Description'] = this.description;
    data['CompanyId'] = this.companyId;
    data['CompanyName'] = this.companyName;
    return data;
  }
}
