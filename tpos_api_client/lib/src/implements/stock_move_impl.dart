import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstractions/stock_move_api.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

class StockMoveApiImpl implements StockMoveApi {
  StockMoveApiImpl({TPosApiClient apiClient}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
  }

  TPosApi _apiClient;

  @override
  Future<OdataListResult<StockMove>> getProductTemplateStockMoves(
      {GetProductTemplateStockMoveQuery query}) async {
    final Map<String, dynamic> response = await _apiClient.httpGet("/odata/StockMove/ODataService.GetStockMove_Product",
        parameters: query?.toJson(true));
    return OdataListResult<StockMove>.fromJson(response);
  }
}
