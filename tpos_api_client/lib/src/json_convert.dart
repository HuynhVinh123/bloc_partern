import 'package:tmt_flutter_untils/sources/json_convert/JsonConvert.dart';
import 'package:tpos_api_client/src/model.dart';
import 'package:tpos_api_client/src/models/entities/product/product_uom_category.dart';
import 'package:tpos_api_client/src/models/entities/sale_online_order.dart';

/// Global jsonConvertObject
final JsonConvert tPosJsonConvert = JsonConvert(configs: {
  SaleOnlineOrder: (json) => SaleOnlineOrder.fromJson(json),
  CRMTeam: (json) => CRMTeam.fromJson(json),
  Partner: (json) => Partner.fromJson(json),
  Tag: (json) => Tag.fromJson(json),
  ProductPrice: (json) => ProductPrice.fromJson(json),
  ApplicationUser: (json) => ApplicationUser.fromJson(json),
  CRMTag: (json) => CRMTag.fromJson(json),
  StockMove: (json) => StockMove.fromJson(json),
  PartnerExt: (json) => PartnerExt.fromJson(json),
  OriginCountry: (json) => OriginCountry.fromJson(json),
  ProductAttributeValue: (json) => ProductAttributeValue.fromJson(json),
  ProductAttribute: (json) => ProductAttribute.fromJson(json),
  InventoryProduct: (json) => InventoryProduct.fromJson(json),
  ProductCategory: (json) => ProductCategory.fromJson(json),
  ProductUomCategory: (json) => ProductUomCategory.fromJson(json),
  ProductUOM: (json) => ProductUOM.fromJson(json),
  Product: (json) => Product.fromJson(json),
  PartnerCategory: (json) => PartnerCategory.fromJson(json),
  FastSaleOrder: (json) => FastSaleOrder.fromJson(json),
  ProductUOMLine: (json) => ProductUOMLine.fromJson(json),
  StockProductionLot: (json) => StockProductionLot.fromJson(json),
  TposFacebookWinner: (json) => TposFacebookWinner.fromJson(json),
});
