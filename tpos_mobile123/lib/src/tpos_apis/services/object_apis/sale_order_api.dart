import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_service/odata_filter.dart';
import 'package:tpos_mobile/feature_group/sale_online/services/tpos_api_service.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order.dart';

import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_service_base.dart';

class SaleOrderApi extends ApiServiceBase {
  final Logger _logger = new Logger();

  Future<OdataResult<SaleOrder>> getSaleOrderDefault() async {
    var response = await apiClient.httpGet(
      path: "/odata/SaleOrder/ODataService.DefaultGet",
      param: {"\$expand": "Currency,Warehouse,User,PriceList,PaymentJournal"},
    );

    var jsonMap = jsonDecode(response.body);
    return OdataResult.fromJson(jsonMap, parseValue: () {
      return SaleOrder.fromJson(jsonMap);
    });
  }

  Future<OdataResult<SaleOrder>> getSaleOrderWhenChangePartner(
      SaleOrder order) async {
    Map<String, dynamic> model = {"model": order.toJson(removeIfNull: true)};
    String body = jsonEncode(model);
    var response = await apiClient.httpPost(
      path: "/odata/SaleOrder/ODataService.OnChangePartner_PriceList",
      params: {"\$expand": "PartnerInvoice,PartnerShipping,PriceList"},
      body: body,
    );

    var jsonMap = jsonDecode(response.body);
    return OdataResult.fromJson(jsonMap, parseValue: () {
      if (response.statusCode.toString().startsWith("2"))
        return SaleOrder.fromJson(jsonMap);
      else
        return null;
    });
  }

  Future<SaleOrder> insertSaleOrder(SaleOrder order, bool isDraft) async {
    var map = order.toJson();
    String body = jsonEncode(map);
    var response = await apiClient.httpPost(
      path: "/odata/SaleOrder",
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonMap = jsonDecode(response.body);
      return SaleOrder.fromJson(jsonMap);
    } else {
      var jsonMap = jsonDecode(response.body);
      if (jsonMap["error"] != null) {
        OdataError error = OdataError.fromJson(jsonMap["error"]);
        if (error != null) {
          throw new Exception(error.message);
        }
      }

      throw new Exception("${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  Future<void> updateSaleOrder(SaleOrder order) async {
    var map = order.toJson();
    var result = jsonEncode(map);
    var response = await apiClient.httpPut(
      path: "/odata/SaleOrder(${order.id})",
      body: jsonEncode(map),
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      throw new Exception("${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  Future<SaleOrder> getSaleOrderById(int orderId,
      {bool getForEdit = false}) async {
    var response = await apiClient.httpGet(
        path:
            "/odata/SaleOrder($orderId)?\$expand=Partner,PartnerInvoice,PartnerShipping,User,Warehouse,Currency,Company,Project,PriceList,PaymentJournal");
    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      return SaleOrder.fromJson(jsonMap);
    }
    throwTposApiException(response);
    return null;
  }

  /// Lấy danh sách sale order
  Future<SearchResult<List<SaleOrder>>> getSaleOrderList(int take, int skip,
      String keyword, DateTime dateTo, DateTime dateFrom) async {
    Map<String, dynamic> body = {"take": take, "skip": skip};

    if (dateFrom != null ||
        dateTo != null ||
        keyword != null && keyword != "") {
      OdataFilter filter = new OdataFilter();
      filter.logic = "and";
      if (filter.filters == null) {
        filter.filters = new List<FilterBase>();
      }

      if (keyword != null && keyword != "") {
        filter.filters
            .add(new OdataFilter(logic: "or", filters: <OdataFilterItem>[
          OdataFilterItem(
              field: "PartnerDisplayName",
              operator: "contains",
              value: keyword),
          OdataFilterItem(
              field: "PartnerNameNoSign", operator: "contains", value: keyword),
        ]));
      }
      if (dateTo != null && dateFrom != null) {
        filter.filters.add(
          OdataFilterItem(field: "DateOrder", operator: "gte", value: dateFrom),
        );

        filter.filters.add(
          OdataFilterItem(field: "DateOrder", operator: "lte", value: dateTo),
        );
      }
      body["filter"] = filter.toJson();
    }

    var response = await apiClient.httpPost(
      path: "/SaleOrder/List",
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      return new SearchResult(
          keyword: keyword,
          error: false,
          resultCount: jsonMap["Total"],
          result: (jsonMap["Data"] as List)
              .map((f) => SaleOrder.fromJson(f))
              .toList());
    } else {
      return new SearchResult(
          error: true,
          message:
              OdataError.fromJson(jsonDecode(response.body)["error"]).message);
    }
  }
}
