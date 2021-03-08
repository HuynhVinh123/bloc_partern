import 'package:tpos_api_client/src/models/entities/sale_online_order.dart';
import 'package:tpos_api_client/src/models/results/odata_list_result.dart';

abstract class SaleOnlineOrderApi {
  Future<OdataListResult<SaleOnlineOrder>> getView();
  Future<SaleOnlineOrder> insertFromApp(SaleOnlineOrder order,
      {int timeoutSecond});
}
