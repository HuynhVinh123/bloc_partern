class ProductCategoryForStockWareHouseReport {
  String text;
  String value;
  String nameNoSign;

  ProductCategoryForStockWareHouseReport(
      {this.text, this.value, this.nameNoSign});

  ProductCategoryForStockWareHouseReport.fromJson(Map<String, dynamic> json) {
    text = json['Text'];
    value = json['Value'];
    nameNoSign = json['NameNoSign'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Text'] = this.text;
    data['Value'] = this.value;
    data['NameNoSign'] = this.nameNoSign;
    return data;
  }
}
