import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/models/layout_category.dart';

class OrderLines {
  OrderLines(
      {this.id,
      this.productUOMId,
      this.sequence,
      this.priceUnit,
      this.productUOMQty,
      this.name,
      this.nameGet,
      this.discount,
      this.productId,
      this.priceSubTotal,
      this.priceTotal,
      this.productName,
      this.description,
      this.layoutCategoryId,
      this.layoutCategoryName,
      this.product,
      this.productUOM,
      this.layoutCategory,
      this.imageUrl,
      this.productUOMName});

  OrderLines.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    productUOMId = json['ProductUOMId'];
    sequence = json['Sequence'];
    priceUnit = json['PriceUnit'];
    productUOMQty = json['ProductUOMQty'];
    name = json['Name'];
    discount = json['Discount'];
    productId = json['ProductId'];
    priceSubTotal = json['PriceSubTotal'];
    priceTotal = json['PriceTotal'];
    productName = json['ProductName'];
    description = json['Description'];
    layoutCategoryId = json['LayoutCategoryId'];
    layoutCategoryName = json['LayoutCategoryName'];
    product =
        json['Product'] != null ? Product.fromJson(json['Product']) : null;
    if (product != null) {
      nameGet = product.nameGet;
    }
    productUOM = json['ProductUOM'] != null
        ? ProductUOM.fromJson(json['ProductUOM'])
        : null;
    if (productUOM != null) {
      productUOMName = productUOM.name;
    }
    layoutCategory = json['LayoutCategory'] != null
        ? LayoutCategory.fromJson(json['LayoutCategory'])
        : null;
  }
  int id;
  int productUOMId;
  int sequence;
  double priceUnit;
  double productUOMQty;
  String name;
  String nameGet;
  double discount;
  int productId;
  double priceSubTotal;
  double priceTotal;
  String productName;
  String description;
  int layoutCategoryId;
  String layoutCategoryName;
  Product product;
  ProductUOM productUOM;
  String productUOMName;
  String imageUrl;
  LayoutCategory layoutCategory;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['ProductUOMId'] = productUOMId;
    data['Sequence'] = sequence;
    data['PriceUnit'] = priceUnit;
    data['ProductUOMQty'] = productUOMQty;
    data['Name'] = name;
    data['Discount'] = discount;
    data['ProductId'] = productId;
    data['PriceSubTotal'] = priceSubTotal;
    data['PriceTotal'] = priceTotal;
    data['ProductName'] = productName;
    data['Description'] = description;
    data['LayoutCategoryId'] = layoutCategoryId;
    data['LayoutCategoryName'] = layoutCategoryName;
    if (product != null) {
      data['Product'] = product.toJson();
    }
    if (productUOM != null) {
      data['ProductUOM'] = productUOM.toJson();
    }
    if (layoutCategory != null) {
      data['LayoutCategory'] = layoutCategory.toJson();
    }

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
