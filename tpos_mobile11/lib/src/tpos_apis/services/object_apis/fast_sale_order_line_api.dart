import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_service_base.dart';

class FastSaleOrderLineApi extends ApiServiceBase {
  final _logger = new Logger();

  /// Lấy Fast sale order line theo Id
  Future<List<FastSaleOrderLine>> getFastSaleOrderLineById(int orderId) async {
    var response = await apiClient.httpGet(
        path:
            "/odata/FastSaleOrder($orderId)/OrderLines?\$expand=Product,ProductUOM,Account,SaleLine");
    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      var orderMap = jsonMap["value"] as List;
      return orderMap.map((map) {
        return FastSaleOrderLine.fromJson(map);
      }).toList();
    }
    throwTposApiException(response);
    return null;
  }
}
