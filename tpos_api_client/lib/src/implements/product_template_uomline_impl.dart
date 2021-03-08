import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstractions/product_template_uomline_api.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

class ProductTemplateUOMLineApiImpl implements ProductTemplateUOMLineApi {
  ProductTemplateUOMLineApiImpl({TPosApiClient apiClient}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
  }

  TPosApiClient _apiClient;

  @override
  Future<OdataListResult<Product>> getProductTemplateUOMLines(
      [OdataGetListQuery getListQuery]) async {
    final Map<String, dynamic> parameters = getListQuery?.toMapOfParam(true);
    final Map<String, dynamic> response = await _apiClient.httpGet(
        '/odata/ProductTemplateUOMLine/ODataService.GetLastVersion',
        parameters: parameters);

    return OdataListResult<Product>.fromJson(response);
  }

  @override
  Future<SaleOnlineOrder> getSaleOnlineOrderById(String id,
      [String expand]) async {
    final json = await _apiClient.httpGet('/odata/SaleOnline_Order($id)',
        parameters: <String, dynamic>{'\$expand': expand}
          ..removeWhere((String key, dynamic value) => value == null));
    return SaleOnlineOrder.fromJson(json);
  }

  @override
  Future<OdataListResult<FastSaleOrder>> getSaleOnlineOrders(
      {int partnerId}) async {
    final response = await _apiClient.httpGet(
        "/odata/SaleOnline_Order/ODataService.GetOrdersByPartnerId",
        parameters: {"PartnerId": partnerId});
    return OdataListResult<FastSaleOrder>.fromJson(response);
  }
}
