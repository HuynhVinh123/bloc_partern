
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/models/stock_location.dart';

class StockChangeProductQuantity {
  //String odataContext;
  int id;
  int productId;
  int productTmplId;
  int lotId;
  double newQuantity;
  int locationId;
  int productVariantCount;
  ProductTemplate productTmpl;
  Product product;
  StockLocation location;

  StockChangeProductQuantity(
      { //this.odataContext,
      this.id,
      this.productId,
      this.productTmplId,
      this.lotId,
      this.newQuantity,
      this.locationId,
      this.productVariantCount,
      this.productTmpl,
      this.product,
      this.location});

  StockChangeProductQuantity.fromJson(Map<String, dynamic> json) {
    //odataContext = json['@odata.context'];
    id = json['Id'];
    productId = json['ProductId'];
    productTmplId = json['ProductTmplId'];
    lotId = json['LotId'];
    newQuantity = json['NewQuantity']?.toDouble();
    locationId = json['LocationId'];
    productVariantCount = json['ProductVariantCount'];
    productTmpl = json['ProductTmpl'] != null
        ? new ProductTemplate.fromJson(json['ProductTmpl'])
        : null;
    product =
        json['Product'] != null ? new Product.fromJson(json['Product']) : null;
    location = json['Location'] != null
        ? new StockLocation.fromJson(json['Location'])
        : null;
  }

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['@odata.context'] = this.odataContext;
    data['Id'] = this.id;
    data['ProductId'] = this.productId;
    data['ProductTmplId'] = this.productTmplId;
    data['LotId'] = this.lotId;
    data['NewQuantity'] = this.newQuantity;
    data['LocationId'] = this.locationId;
    data['ProductVariantCount'] = this.productVariantCount;
    if (this.productTmpl != null) {
      data['ProductTmpl'] = this.productTmpl.toJson(removeIfNull: removeIfNull);
    }
    if (this.product != null) {
      data['Product'] = this.product.toJson(removeIfNull: removeIfNull);
    }
    if (this.location != null) {
      data['Location'] = this.location.toJson(removeIfNull);
    }

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
