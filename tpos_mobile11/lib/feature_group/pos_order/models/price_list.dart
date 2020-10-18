class PriceList {
  PriceList(
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

  PriceList.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    currencyId = json['CurrencyId'];
    currencyName = json['CurrencyName'];
    if (json['Active'] == true) {
      active = 1;
    } else {
      active = 0;
    }
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
  int active;
  int companyId;
  String partnerCateName;
  int sequence;
  String dateStart;
  String dateEnd;
  bool activeApi;

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['CurrencyId'] = currencyId;
    data['CurrencyName'] = currencyName;
    if (activeApi != null) {
      data['Active'] = activeApi;
    } else {
      data['Active'] = active;
    }
    data['CompanyId'] = companyId;
    data['PartnerCateName'] = partnerCateName;
    data['Sequence'] = sequence;
    data['DateStart'] = dateStart;
    data['DateEnd'] = dateEnd;

    return data;
  }
}
