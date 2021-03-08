import 'dart:convert';

import 'package:tpos_mobile/src/tpos_apis/models/stock_location.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_service_base.dart';

class StockLocationApi extends ApiServiceBase {
  /// Get all stock location
  Future<List<StockLocation>> getAll() async {
    final response =
        await apiClient.httpGet(path: "/odata/StockLocation", param: {
      "\$orderby": "ParentLeft",
      "\$format": "json",
      "\$filter": "Usage eq 'internal'",
      "\$count": true,
    });

    if (response.statusCode == 200) {
      return (jsonDecode(response.body)["value"] as List)
          .map((f) => StockLocation.fromJson(f))
          .toList();
    }
    throwTposApiException(response);
    return null;
  }
}
