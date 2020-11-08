import 'package:tmt_flutter_untils/sources/json_convert/JsonConvert.dart';
import 'package:tpos_api_client/src/model.dart';
import 'package:tpos_api_client/src/models/entities/sale_online_order.dart';

/// Global jsonConvertObject
final JsonConvert tPosJsonConvert = JsonConvert(configs: {
  SaleOnlineOrder: (json) => SaleOnlineOrder.fromJson(json),
  CRMTeam: (json) => CRMTeam.fromJson(json),
  Partner: (json) => Partner.fromJson(json),
  Tag: (json) => Tag.fromJson(json),
  ProductPrice: (json) => ProductPrice.fromJson(json),
});
