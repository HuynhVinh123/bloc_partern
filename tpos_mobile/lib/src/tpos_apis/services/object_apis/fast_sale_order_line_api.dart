import 'dart:convert';

import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_service_base.dart';

class FastSaleOrderLineApi extends ApiServiceBase {
  /// Lấy Fast sale order line theo Id
  Future<List<FastSaleOrderLine>> getFastSaleOrderLineById(int orderId) async {
    final response = await apiClient.httpGet(
        path:
            "/odata/FastSaleOrder($orderId)/OrderLines?\$expand=Product,ProductUOM,Account,SaleLine");
    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      final orderMap = jsonMap["value"] as List;
      return orderMap.map((map) {
        return FastSaleOrderLine.fromJson(map);
      }).toList();
    }
    throwTposApiException(response);
    return null;
  }
}
