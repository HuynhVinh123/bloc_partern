import 'package:tpos_api_client/src/models/entities/alert.dart';
import 'package:tpos_api_client/src/models/entities/report_dashboard/stock_warehouse_product.dart';

abstract class AlertApi {
  Future<Alert> getAlert();

  Future<void> readWarning(String alertId);

  Future<List<StockWarehouseProduct>> reportInventoryMin();

  Future<List<StockWarehouseProduct>> reportInventoryMax();
}
