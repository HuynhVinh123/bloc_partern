import 'package:tpos_api_client/src/abstractions/sale_online_order_api.dart';
import 'package:tpos_api_client/src/abstractions/tpos_api_client.dart';
import 'package:tpos_api_client/src/models/entities/sale_online_order.dart';
import 'package:tpos_api_client/src/models/requests/get_sale_online_order_view_query.dart';
import 'package:tpos_api_client/src/models/results/odata_list_result.dart';

class SaleOnlineOrderApiImpl implements SaleOnlineOrderApi {
  SaleOnlineOrderApiImpl({TPosApiClient apiClient}) {
    _apiClient = apiClient;
  }
  TPosApiClient _apiClient;
  @override
  Future<OdataListResult<SaleOnlineOrder>> getView(
      {GetSaleOnlineOrderViewQuery query}) async {
    final json = await _apiClient.httpGet(
      '/odata/SaleOnline_Order/ODataService.GetView',
      parameters: query.toJson(true),
    );

    return OdataListResult<SaleOnlineOrder>.fromJson(json);
  }
}
