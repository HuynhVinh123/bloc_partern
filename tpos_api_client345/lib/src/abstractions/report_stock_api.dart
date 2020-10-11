import 'package:tpos_api_client/src/model.dart';
import 'package:tpos_api_client/src/models/entities/report_stock_overview/report_stock.dart';
import 'package:tpos_api_client/src/models/entities/report_stock_overview/report_stock_product_category.dart';

import '../models/entities/report_stock_overview/ware_house_stock.dart';

abstract class ReportStockApi {
  Future<ReportStock> getReportStock(
      {DateTime fromDate,
      DateTime toDate,
      bool isIncludeCanceled = false,
      bool isIncludeReturned = false,
      int wareHouseId,
      int productCategoryId,
      int limit,
      int skip,
      int page});
  Future<List<ReportStockProductCategory>> getProductCategoryReportStock();

  Future<ReportStock> getReportStockExt(
      {DateTime fromDate,
      DateTime toDate,
      bool isIncludeCanceled = false,
      bool isIncludeReturned = false,
      int wareHouseId,
      int productCategoryId,
      int limit,
      int skip,
      int page});

  Future<List<StockWarehouseProduct>> reportInventoryMinStock(
      {String categId, String id, int limit, int skip});

  Future<List<StockWarehouseProduct>> reportInventoryMaxStock(
      {String categId, String id, int limit, int skip});
  Future<List<WareHouseStock>> getWarehouseStock();
}
