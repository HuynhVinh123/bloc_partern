import 'package:tpos_api_client/src/models/entities/alert.dart';
import 'package:tpos_api_client/src/models/entities/report_dashboard/order_financial.dart';
import 'package:tpos_api_client/src/models/entities/report_dashboard/stock_warehouse_product.dart';

import '../../tpos_api_client.dart';

abstract class AlertApi {
  Future<Alert> getAlert();

  Future<void> readWarning(String alertId);

  Future<List<StockWarehouseProduct>> reportInventoryMin();

  Future<List<StockWarehouseProduct>> reportInventoryMax();

  Future<List<OrderFinancial>> getOrderFinancial(
      {int limit, int skip, String overViewValue});

  Future<List<OrderFinancial>> getOrderFinancialRefund(
      {int limit, int skip, String overViewValue});
}
