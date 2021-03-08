import 'dart:convert';

import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_service/odata_filter.dart';
import 'package:tpos_mobile/feature_group/sale_online/services/tpos_api_service.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_service_base.dart';

class SaleOrderApi extends ApiServiceBase {
  Future<OdataResult<SaleOrder>> getSaleOrderDefault() async {
    final response = await apiClient.httpGet(
      path: "/odata/SaleOrder/ODataService.DefaultGet",
      param: {"\$expand": "Currency,Warehouse,User,PriceList,PaymentJournal"},
    );

    final jsonMap = jsonDecode(response.body);
    return OdataResult.fromJson(jsonMap, parseValue: () {
      return SaleOrder.fromJson(jsonMap);
    });
  }

  Future<OdataResult<SaleOrder>> getSaleOrderWhenChangePartner(
      SaleOrder order) async {
    final Map<String, dynamic> model = {
      "model": order.toJson(removeIfNull: true)
    };
    final String body = jsonEncode(model);
    final response = await apiClient.httpPost(
      path: "/odata/SaleOrder/ODataService.OnChangePartner_PriceList",
      params: {"\$expand": "PartnerInvoice,PartnerShipping,PriceList"},
      body: body,
    );

    final jsonMap = jsonDecode(response.body);
    return OdataResult.fromJson(jsonMap, parseValue: () {
      if (response.statusCode.toString().startsWith("2"))
        return SaleOrder.fromJson(jsonMap);
      else
        return null;
    });
  }

  Future<SaleOrder> insertSaleOrder(SaleOrder order, bool isDraft) async {
    final map = order.toJson();
    final String body = jsonEncode(map);
    final response = await apiClient.httpPost(
      path: "/odata/SaleOrder",
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonMap = jsonDecode(response.body);
      return SaleOrder.fromJson(jsonMap);
    } else {
      final jsonMap = jsonDecode(response.body);
      if (jsonMap["error"] != null) {
        final OdataError error = OdataError.fromJson(jsonMap["error"]);
        if (error != null) {
          throw Exception(error.message);
        }
      }

      throw Exception("${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  Future<void> updateSaleOrder(SaleOrder order) async {
    final map = order.toJson();
    final response = await apiClient.httpPut(
      path: "/odata/SaleOrder(${order.id})",
      body: jsonEncode(map),
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception("${response.statusCode}: ${response.reasonPhrase}");
    }
  }

  Future<SaleOrder> getSaleOrderById(int orderId,
      {bool getForEdit = false}) async {
    final response = await apiClient.httpGet(
        path:
            "/odata/SaleOrder($orderId)?\$expand=Partner,PartnerInvoice,PartnerShipping,User,Warehouse,Currency,Company,Project,PriceList,PaymentJournal");
    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      return SaleOrder.fromJson(jsonMap);
    }
    throwTposApiException(response);
    return null;
  }

  /// Lấy danh sách sale order
  Future<SearchResult<List<SaleOrder>>> getSaleOrderList(int take, int skip,
      String keyword, DateTime dateTo, DateTime dateFrom) async {
    final Map<String, dynamic> body = {"take": take, "skip": skip};

    if (dateFrom != null ||
        dateTo != null ||
        keyword != null && keyword != "") {
      final OldOdataFilter filter = OldOdataFilter();
      filter.logic = "and";
      filter.filters ??= <OldFilterBase>[];

      if (keyword != null && keyword != "") {
        filter.filters
            .add(OldOdataFilter(logic: "or", filters: <OldOdataFilterItem>[
          OldOdataFilterItem(
              field: "PartnerDisplayName",
              operator: "contains",
              value: keyword),
          OldOdataFilterItem(
              field: "PartnerNameNoSign", operator: "contains", value: keyword),
        ]));
      }
      if (dateTo != null && dateFrom != null) {
        filter.filters.add(
          OldOdataFilterItem(
              field: "DateOrder", operator: "gte", value: dateFrom),
        );

        filter.filters.add(
          OldOdataFilterItem(
              field: "DateOrder", operator: "lte", value: dateTo),
        );
      }
      body["filter"] = filter.toJson();
    }

    final response = await apiClient.httpPost(
      path: "/SaleOrder/List",
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      return SearchResult(
          keyword: keyword,
          error: false,
          resultCount: jsonMap["Total"],
          result: (jsonMap["Data"] as List)
              .map((f) => SaleOrder.fromJson(f))
              .toList());
    } else {
      return SearchResult(
          error: true,
          message:
              OdataError.fromJson(jsonDecode(response.body)["error"]).message);
    }
  }
}
