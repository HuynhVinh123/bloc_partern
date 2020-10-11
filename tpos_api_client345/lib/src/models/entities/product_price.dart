class ProductPrice {
  int id;
  String name;
  int currencyId;
  String currencyName;
  bool active;
  int companyId;
  String partnerCateName;
  int sequence;
  DateTime dateStart;
  DateTime dateEnd;

  ProductPrice(
      {this.id,
      this.name,
      this.currencyId,
      this.currencyName,
      this.active,
      this.companyId,
      this.partnerCateName,
      this.sequence,
      this.dateStart,
      this.dateEnd});

  ProductPrice.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap["Id"];
    name = jsonMap["Name"];
    currencyId = jsonMap["CurrencyId"];
    currencyName = jsonMap["CurrencyName"];
    active = jsonMap["Active"];
    companyId = jsonMap["CompanyId"];
    partnerCateName = jsonMap["PartnerCateName"];
    sequence = jsonMap["Sequence"];
  }

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    var data = {
      "Id": id,
      "Name": name,
      "CurrencyId": currencyId,
      "CurrencyName": currencyName,
      "Active": active,
      "CompanyId": companyId,
      "PartnerCateName": partnerCateName,
      "Sequence": sequence,
      "DateStart": dateStart,
      "DateEnd": dateEnd,
    };

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }

    return data;
  }
}
