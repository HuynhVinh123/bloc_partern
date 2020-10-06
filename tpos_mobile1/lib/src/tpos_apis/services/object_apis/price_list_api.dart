import 'dart:convert';

import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/sale_online/services/tpos_api_service.dart';

import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_service_base.dart';

class PriceListApi extends ApiServiceBase {
  Future<List<ProductPrice>> getPriceListAvaible(DateTime dateTime) async {
    var response = await apiClient.httpGet(
        path: "/odata/Product_PriceList/ODataService.GetPriceListAvailable",
        param: {
          "\date": dateTime.toIso8601String(),
          "\$format": "json",
          "\$count": "true",
        });
    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      return (jsonMap["value"] as List).map((map) {
        return ProductPrice.fromJson(map);
      }).toList();
    } else {
      throwTposApiException(response);
      return null;
    }
  }

  Future<TPosApiResult<ProductPrice>> getDefaultProductPrice() async {
    var response =
        await apiClient.httpGet(path: "/odata/Product_PriceList", param: {
      "\$format": "json",
      "\$count": "true",
    });

    if (response.statusCode == 200) {
      var firstItem = (jsonDecode(response.body) as List).first;
      return TPosApiResult(
          error: false, result: ProductPrice.fromJson(firstItem));
    } else {
      // Catch odata message
      OdataError error =
          OdataError.fromJson(jsonDecode(response.body)["error"]);
      return TPosApiResult(error: true, result: null, message: error.message);
    }
  }

  Future<List<ProductPrice>> getProductPrices() async {
    var response =
        await apiClient.httpGet(path: "/odata/Product_PriceList", param: {
      "\$format": "json",
      "\$count": "true",
    });
    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      return (jsonMap["value"] as List).map((map) {
        return ProductPrice.fromJson(map);
      }).toList();
    } else {
      throwTposApiException(response);
      return null;
    }
  }
}
