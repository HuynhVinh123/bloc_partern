import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstractions/sale_online_order_api.dart';
import 'package:tpos_api_client/src/abstractions/tpos_api_client.dart';
import 'package:tpos_api_client/src/models/entities/sale_online_order.dart';
import 'package:tpos_api_client/src/models/requests/get_sale_online_order_view_query.dart';
import 'package:tpos_api_client/src/models/results/odata_list_result.dart';

class SaleOnlineOrderApiImpl implements SaleOnlineOrderApi {
  SaleOnlineOrderApiImpl({TPosApi apiClient}) {
    _apiClient = apiClient ?? GetIt.I<TPosApi>();
  }
  TPosApi _apiClient;
  @override
  Future<OdataListResult<SaleOnlineOrder>> getView(
      {GetSaleOnlineOrderViewQuery query}) async {
    final json = await _apiClient.httpGet(
      '/odata/SaleOnline_Order/ODataService.GetView',
      parameters: query.toJson(true),
    );

    return OdataListResult<SaleOnlineOrder>.fromJson(json);
  }

  @override
  Future<SaleOnlineOrder> insertFromApp(SaleOnlineOrder order,
      {int timeoutSecond}) async {
    assert(order.crmTeamId != null);
    assert(order.facebookAsuid != null);
    assert(order.facebookCommentId != null);
    assert(order.facebookPostId != null);
    assert(order.note != null);
    assert(order.facebookUserName != null);

    final Map temp = <String, dynamic>{"model": order.toJson(true)};
    final response = await _apiClient.httpPost(
      '/odata/SaleOnline_Order/ODataService.InsertFromApp',
      parameters: {
        'IsIncrease': true,
      },
      data: temp,
      options: Options(
        sendTimeout: 300,
      ),
    );

    return SaleOnlineOrder.fromJson(response);
  }
}
