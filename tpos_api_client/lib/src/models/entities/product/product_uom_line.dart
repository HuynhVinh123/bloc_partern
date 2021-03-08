import 'productUOM.dart';

class ProductUOMLine {
  ProductUOMLine(
      {this.id,
      this.productTmplId,
      this.productTmplListPrice,
      this.uOMId,
      this.templateUOMFactor,
      this.listPrice,
      this.barcode,
      this.price,
      this.productId,
      this.uOMName,
      this.nameGet,
      this.factor,
      this.uOM});

  ProductUOMLine.fromJson(Map<String, dynamic> jsonMap) {
    id = jsonMap["Id"];
    productTmplId = jsonMap["ProductTmplId"];
    productTmplListPrice = jsonMap["ProductTmplListPrice"];
    uOMId = jsonMap["UOMId"];
    templateUOMFactor = jsonMap["TemplateUOMFactor"];
    listPrice = jsonMap["ListPrice"];
    barcode = jsonMap["Barcode"];
    price = jsonMap["Price"];
    productId = jsonMap["ProductId"];
    uOMName = jsonMap["UOMName"];
    nameGet = jsonMap["NameGet"];
    factor = (jsonMap["Factor"] ?? 0).toDouble();
    uOM = jsonMap["UOM"] != null ? ProductUOM.fromJson(jsonMap["UOM"]) : null;
  }

  int id;
  int productTmplId;
  double productTmplListPrice;
  int uOMId;
  double templateUOMFactor;
  double listPrice;
  String barcode;
  double price;
  int productId;
  String uOMName;
  String nameGet;
  double factor;
  ProductUOM uOM;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final data = {
      "Id": id,
      "ProductTmplId": productTmplId,
      "ProductTmplListPrice": productTmplListPrice,
      "UOMId": uOMId,
      "TemplateUOMFactor": templateUOMFactor,
      "ListPrice": listPrice,
      "Barcode": barcode,
      "Price": price,
      "ProductId": productId,
      "UOMName": uOMName,
      "NameGet": nameGet,
      "Factor": factor,
      "UOM": uOM != null ? uOM.toJson(removeIfNull) : null,
    };

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
