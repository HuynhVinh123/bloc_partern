import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstractions/partner_api.dart';
import 'package:tpos_api_client/src/abstractions/alert_api.dart';
import 'package:tpos_api_client/src/models/entities/credit_debit_customer_detail.dart';
import 'package:tpos_api_client/src/models/entities/partner.dart';
import 'package:tpos_api_client/src/models/entities/alert.dart';
import 'package:tpos_api_client/src/models/entities/report_dashboard/stock_warehouse_product.dart';
import 'package:tpos_api_client/src/models/requests/get_partner_by_id_query.dart';
import 'package:tpos_api_client/src/models/requests/get_partner_for_search_query.dart';
import 'package:tpos_api_client/src/models/requests/get_view_partner_query.dart';
import 'package:tpos_api_client/src/models/results/get_partner_revenue_result.dart';
import 'package:tpos_api_client/src/models/results/odata_list_result.dart';

import '../abstraction.dart';

class AlertApiImpl implements AlertApi {
  AlertApiImpl({TPosApiClient apiClient}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
  }
  TPosApiClient _apiClient;

  @override
  Future<Alert> getAlert() async {
    final response = await _apiClient.httpGet("/api/systemalert/getalert");
    return Alert.fromJson(response);
  }

  @override
  Future<void> readWarning(String alertId) async {
    await _apiClient.httpGet("/api/systemalert/read?Id=$alertId");
  }

  @override
  Future<List<StockWarehouseProduct>> reportInventoryMin() async {
    final response = await _apiClient.httpGet(
        "/odata/StockWarehouse_Product/ODataService.ReportInventoryMin?id=undefined&categId=undefined");
    List<StockWarehouseProduct> products = [];
    products = (response["value"] as List)
        .map((e) => StockWarehouseProduct.fromJson(e))
        .toList();
    return products;
  }

  @override
  Future<List<StockWarehouseProduct>> reportInventoryMax() async {
    final response = await _apiClient.httpGet(
        "/odata/StockWarehouse_Product/ODataService.ReportInventoryMax?id=undefined&categId=undefined");
    List<StockWarehouseProduct> products = [];
    products = (response["value"] as List)
        .map((e) => StockWarehouseProduct.fromJson(e))
        .toList();
    return products;
  }
}
