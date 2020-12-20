import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstractions/report_stock_api.dart';
import 'package:tpos_api_client/src/models/entities/report_stock_overview/report_stock.dart';
import 'package:tpos_api_client/src/models/entities/report_stock_overview/report_stock_product_category.dart';

import '../../tpos_api_client.dart';
import '../models/entities/report_stock_overview/ware_house_stock.dart';

class ReportStockApiImpl implements ReportStockApi {
  ReportStockApiImpl({TPosApiClient apiClient}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
  }
  TPosApiClient _apiClient;

  @override
  Future<ReportStock> getReportStock(
      {DateTime fromDate,
      DateTime toDate,
      bool isIncludeCanceled = false,
      bool isIncludeReturned = false,
      int wareHouseId,
      int productCategoryId,
      int limit,
      int skip,
      int page,
      String keyWord}) async {
    final Map<String, dynamic> mapBody = {
      "FromDate": fromDate?.toIso8601String(),
      "ToDate": toDate?.toIso8601String(),
      "IncludeCancelled": isIncludeCanceled,
      "IncludeReturned": isIncludeReturned,
      "take": limit,
      "skip": skip,
      "page": page,
      "pageSize": limit,
      "WarehouseId": wareHouseId,
      "ProductCategoryId": productCategoryId,
      "q": keyWord,
      "aggregate": [
        {"field": "Begin", "aggregate": "sum"},
        {"field": "Import", "aggregate": "sum"},
        {"field": "Export", "aggregate": "sum"},
        {"field": "End", "aggregate": "sum"}
      ]
    }..removeWhere((key, value) => value == null);

    final String body = json.encode(mapBody);
    final response =
        await _apiClient.httpPost("/StockReport/XuatNhapTon", data: body);
    return ReportStock.fromJson(response);
  }

  @override
  Future<List<ReportStockProductCategory>>
      getProductCategoryReportStock() async {
    List<ReportStockProductCategory> categories = [];
    final response =
        await _apiClient.httpGet("/StockReport/GetProductCategory");
    categories = (response as List)
        .map((f) => ReportStockProductCategory.fromJson(f))
        .toList();
    return categories;
  }

  @override
  Future<ReportStock> getReportStockExt(
      {DateTime fromDate,
      DateTime toDate,
      bool isIncludeCanceled = false,
      bool isIncludeReturned = false,
      int wareHouseId,
      int productCategoryId,
      int limit,
      int skip,
      int page,
      String keyWord}) async {
    final Map<String, dynamic> mapBody = {
      "FromDate": fromDate?.toIso8601String(),
      "ToDate": toDate?.toIso8601String(),
      "IncludeCancelled": isIncludeCanceled,
      "IncludeReturned": isIncludeReturned,
      "take": limit,
      "skip": skip,
      "page": page,
      "pageSize": limit,
      "WarehouseId": wareHouseId,
      "ProductCategoryId": productCategoryId,
      "TypeSearch": "all",
      "q": keyWord,
      "aggregate": [
        {"field": "Begin", "aggregate": "sum"},
        {"field": "Import", "aggregate": "sum"},
        {"field": "Export", "aggregate": "sum"},
        {"field": "End", "aggregate": "sum"}
      ]
    }..removeWhere((key, value) => value == null);

    final String body = json.encode(mapBody);
    final response =
        await _apiClient.httpPost("/StockReport/XuatNhapTonExt", data: body);
    return ReportStock.fromJson(response);
  }

  @override
  Future<List<StockWarehouseProduct>> reportInventoryMaxStock(
      {int categId, int id, int limit, int skip}) async {
    final Map<String, dynamic> mapParameters = {
      "\$format": "json",
      "\$count": "true",
      "\$top": limit,
      "\$skip": skip,
      "categId": categId ?? "undefined",
      "id": id ?? "undefined",
    };

    final response = await _apiClient.httpGet(
        "/odata/StockWarehouse_Product/ODataService.ReportInventoryMax",
        parameters: mapParameters);
    List<StockWarehouseProduct> products = [];
    products = (response["value"] as List)
        .map((e) => StockWarehouseProduct.fromJson(e))
        .toList();
    return products;
  }

  @override
  Future<List<StockWarehouseProduct>> reportInventoryMinStock(
      {int categId, int id, int limit, int skip}) async {
    final Map<String, dynamic> mapParameters = {
      "\$format": "json",
      "\$count": "true",
      "\$top": limit,
      "\$skip": skip,
      "categId": categId ?? "undefined",
      "id": id ?? "undefined",
    };

    final response = await _apiClient.httpGet(
        "/odata/StockWarehouse_Product/ODataService.ReportInventoryMin",
        parameters: mapParameters);
    List<StockWarehouseProduct> products = [];
    products = (response["value"] as List)
        .map((e) => StockWarehouseProduct.fromJson(e))
        .toList();
    return products;
  }

  @override
  Future<List<WareHouseStock>> getWarehouseStock({String keyWord}) async {
    List<WareHouseStock> wareHouseStocks = [];
    final Map<String, dynamic> mapBody = {
      "\$format": "json",
      "\$count": "true",
      "\$filter": keyWord != null && keyWord != ""
          ? "contains(tolower(Name),'$keyWord')"
          : null,
    }..removeWhere((key, value) => value == null);
    final response =
        await _apiClient.httpGet("/odata/StockWarehouse", parameters: mapBody);
    wareHouseStocks = (response["value"] as List)
        .map((e) => WareHouseStock.fromJson(e))
        .toList();
    return wareHouseStocks;
  }

  @override
  Future<StockMoveProduct> getStockMoveProduct(
      {DateTime fromDate,
      DateTime toDate,
      bool isIncludeCanceled = false,
      bool isIncludeReturned = false,
      int wareHouseId,
      int productCategoryId,
      int limit,
      int skip,
      int productTmplId,
      String keyWord}) async {
    final List<StockMoveProduct> products = [];

    final Map<String, dynamic> mapBody = {
      "ProductTmplId": productTmplId,
      "FromDate": fromDate?.toIso8601String(),
      "ToDate": toDate?.toIso8601String(),
      "IncludeCancelled": isIncludeCanceled,
      "IncludeReturned": isIncludeReturned,
      "\$format": "json",
      "\$top": limit,
      "\$skip": skip,
      "\$orderby": "Date desc",
      "\$filter": "ProductTmplId eq $productTmplId",
      "WarehouseId": wareHouseId ?? "",
      "ProductCategoryId": productCategoryId ?? "",
      "\$count": "true",
      "q": keyWord ?? ""
    };

    final response = await _apiClient.httpGet(
        "/odata/StockMove/ODataService.GetStockMove_Product",
        parameters: mapBody);

    return StockMoveProduct.fromJson(response);
  }
}
