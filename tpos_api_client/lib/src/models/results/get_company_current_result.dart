class GetCompanyCurrentResult {
  GetCompanyCurrentResult.fromJson(Map<String, dynamic> map)
      : companyId = map["CompanyId"],
        partnerId = map["PartnerId"],
        productId = map["ProductId"],
        companyName = map["CompanyName"],
        quantityDecimal = map["QuantityDecimal"],
        dateServer = map["DateServer"],
        configs = map["Configs"],
        requestLimit = map["RequestLimit"],
        symbolPrice = map["SymbolPrice"],
        roundingPrice = map["RoundingPrice"];
  int companyId;
  int partnerId;
  int productId;
  String companyName;
  int quantityDecimal;
  String dateServer;
  String configs;
  int requestLimit;
  Object symbolPrice;
  double roundingPrice;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CompanyId'] = companyId;
    data['PartnerId'] = partnerId;
    data['ProductId'] = productId;
    data['CompanyName'] = companyName;
    data['QuantityDecimal'] = quantityDecimal;
    data['DateServer'] = dateServer;
    data['Configs'] = configs;
    data['RequestLimit'] = requestLimit;
    data['SymbolPrice'] = symbolPrice;
    data['RoundingPrice'] = roundingPrice;
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
