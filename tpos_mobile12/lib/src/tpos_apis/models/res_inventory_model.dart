class GetInventoryProductResult {
  String odataContext;
  int odataCount;
  List<ResInventoryModel> value;

  GetInventoryProductResult({this.odataContext, this.odataCount, this.value});

  GetInventoryProductResult.fromJson(Map<String, dynamic> json) {
    odataContext = json['@odata.context'];
    odataCount = json['@odata.count'];
    if (json['value'] != null) {
      value = new List<ResInventoryModel>();
      json['value'].forEach((v) {
        value.add(new ResInventoryModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['@odata.context'] = this.odataContext;
    data['@odata.count'] = this.odataCount;
    if (this.value != null) {
      data['value'] = this.value.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResInventoryModel {
  int id;
  int productTmplId;
  String name;
  Null nameGet;
  double quantity;

  ResInventoryModel(
      {this.id, this.productTmplId, this.name, this.nameGet, this.quantity});

  ResInventoryModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    productTmplId = json['ProductTmplId'];
    name = json['Name'];
    nameGet = json['NameGet'];
    quantity = json['Quantity']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['ProductTmplId'] = this.productTmplId;
    data['Name'] = this.name;
    data['NameGet'] = this.nameGet;
    data['Quantity'] = this.quantity;
    return data;
  }
}
