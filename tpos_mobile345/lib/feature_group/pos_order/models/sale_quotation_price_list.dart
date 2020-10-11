class SaleQuotationPriceList {
  SaleQuotationPriceList(
      {this.id,
      this.name,
      this.currencyId,
      this.currencyName,
      this.active,
      this.companyId,
      this.partnerCateName,
      this.sequence,
      this.dateStart,
      this.dateEnd,
      this.activeApi});

  SaleQuotationPriceList.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    currencyId = json['CurrencyId'];
    currencyName = json['CurrencyName'];
    active = json['Active'];
    companyId = json['CompanyId'];
    partnerCateName = json['PartnerCateName'];
    sequence = json['Sequence'];
    dateStart = json['DateStart'];
    dateEnd = json['DateEnd'];
  }

  int id;
  String name;
  int currencyId;
  String currencyName;
  bool active;
  int companyId;
  String partnerCateName;
  int sequence;
  String dateStart;
  String dateEnd;
  bool activeApi;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['CurrencyId'] = currencyId;
    data['CurrencyName'] = currencyName;
    data['Active'] = active;
    data['CompanyId'] = companyId;
    data['PartnerCateName'] = partnerCateName;
    data['Sequence'] = sequence;
    data['DateStart'] = dateStart;
    data['DateEnd'] = dateEnd;

    return data;
  }
}
