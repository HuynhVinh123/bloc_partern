import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/models/layout_category.dart';


class OrderLines {
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
        json['Product'] != null ? new Product.fromJson(json['Product']) : null;
    if (product != null) {
      nameGet = product.nameGet;
    }
    productUOM = json['ProductUOM'] != null
        ? new ProductUOM.fromJson(json['ProductUOM'])
        : null;
    if (productUOM != null) {
      productUOMName = productUOM.name;
    }
    layoutCategory = json['LayoutCategory'] != null
        ? LayoutCategory.fromJson(json['LayoutCategory'])
        : null;
  }

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['ProductUOMId'] = this.productUOMId;
    data['Sequence'] = this.sequence;
    data['PriceUnit'] = this.priceUnit;
    data['ProductUOMQty'] = this.productUOMQty;
    data['Name'] = this.name;
    data['Discount'] = this.discount;
    data['ProductId'] = this.productId;
    data['PriceSubTotal'] = this.priceSubTotal;
    data['PriceTotal'] = this.priceTotal;
    data['ProductName'] = this.productName;
    data['Description'] = this.description;
    data['LayoutCategoryId'] = this.layoutCategoryId;
    data['LayoutCategoryName'] = this.layoutCategoryName;
    if (this.product != null) {
      data['Product'] = this.product.toJson();
    }
    if (this.productUOM != null) {
      data['ProductUOM'] = this.productUOM.toJson();
    }
    if (this.layoutCategory != null) {
      data['LayoutCategory'] = this.layoutCategory.toJson();
    }

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
