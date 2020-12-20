import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/models/stock_location.dart';

class StockChangeProductQuantity {
  //String odataContext;

  StockChangeProductQuantity.fromJson(Map<String, dynamic> json) {
    //odataContext = json['@odata.context'];
    id = json['Id'];
    productId = json['ProductId'];
    productTmplId = json['ProductTmplId'];
    lotId = json['LotId'];
    newQuantity = json['NewQuantity']?.toDouble();
    locationId = json['LocationId'];
    productVariantCount = json['ProductVariantCount'];
    productTmpl = json['ProductTmpl'] != null ? ProductTemplate.fromJson(json['ProductTmpl']) : null;
    product = json['Product'] != null ? Product.fromJson(json['Product']) : null;
    location = json['Location'] != null ? StockLocation.fromJson(json['Location']) : null;

    productionLot = json['StockProductionLot'] != null ? StockProductionLot.fromJson(json['StockProductionLot']) : null;
  }

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
  StockProductionLot productionLot;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['@odata.context'] = this.odataContext;
    data['Id'] = id;
    data['ProductId'] = productId;
    data['ProductTmplId'] = productTmplId;
    data['LotId'] = lotId;
    data['NewQuantity'] = newQuantity;
    data['LocationId'] = locationId;
    data['ProductVariantCount'] = productVariantCount;
    if (productTmpl != null) {
      data['ProductTmpl'] = productTmpl.toJson(removeIfNull: removeIfNull);
    }
    if (product != null) {
      data['Product'] = product.toJson(removeIfNull: removeIfNull);
    }
    if (location != null) {
      data['Location'] = location.toJson(removeIfNull);
    }

    if (productionLot != null) {
      data['StockProductionLot'] = productionLot.toJson(removeIfNull: removeIfNull);
    }

    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
