import 'package:tpos_api_client/tpos_api_client.dart';

abstract class StockProductionLotApi {
  Future<OdataListResult<StockProductionLot>> getStockProductionLots({OdataListQuery query});
}
