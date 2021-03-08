import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstractions/stock_production_lot_api.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

class StockProductionLotApiImpl implements StockProductionLotApi {
  StockProductionLotApiImpl({TPosApiClient apiClient}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
  }

  TPosApi _apiClient;

  @override
  Future<OdataListResult<StockProductionLot>> getStockProductionLots({OdataListQuery query}) async {
    final Map<String, dynamic> response = await _apiClient.httpGet(
        "/odata/StockProductionLot",
        parameters: query?.toJson(true));
    return OdataListResult<StockProductionLot>.fromJson(response);
  }
}
