class GetInventoryProductResult {
  GetInventoryProductResult({this.odataContext, this.odataCount, this.value});
  GetInventoryProductResult.fromJson(Map<String, dynamic> json) {
    odataContext = json['@odata.context'];
    odataCount = json['@odata.count'];
    if (json['value'] != null) {
      value = <ResInventoryModel>[];
      json['value'].forEach((v) {
        value.add(ResInventoryModel.fromJson(v));
      });
    }
  }
  String odataContext;
  int odataCount;
  List<ResInventoryModel> value;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['@odata.context'] = odataContext;
    data['@odata.count'] = odataCount;
    if (value != null) {
      data['value'] = value.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResInventoryModel {
  ResInventoryModel(
      {this.id, this.productTmplId, this.name, this.nameGet, this.quantity});
  ResInventoryModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    productTmplId = json['ProductTmplId'];
    name = json['Name'];
    nameGet = json['NameGet'];
    quantity = json['Quantity']?.toDouble();
  }

  int id;
  int productTmplId;
  String name;
  dynamic nameGet;
  double quantity;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['ProductTmplId'] = productTmplId;
    data['Name'] = name;
    data['NameGet'] = nameGet;
    data['Quantity'] = quantity;
    return data;
  }
}
