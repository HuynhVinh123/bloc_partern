import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/sale_online/services/service.dart';
import 'package:tpos_mobile/feature_group/sale_online/services/tpos_api_service.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/analytics_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/create_quick_fast_sale_order_model.dart';
import 'package:tpos_mobile/src/tpos_apis/result_models/create_quick_fast_sale_order_result.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_result.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_service_base.dart';
import 'dart:developer' as dev;

class FastSaleOrderApi extends ApiServiceBase {
  final AnalyticsService _analyticsService = GetIt.I<AnalyticsService>();
  final ISettingService _settingService = locator<ISettingService>();

  /// Lấy danh sách hóa đơn giao hàng
  Future<TPosApiListResult<FastSaleOrder>> getDeliveryInvoices(
      {take, skip, page, pageSize, sort, filter}) async {
    var body;
    Map temp = {
      "take": take,
      "skip": skip,
      "page": page,
      "pageSize": pageSize,
      "sort": sort,
      "filter": filter,
    }..removeWhere((key, value) => value == null);
    body = jsonEncode(temp);
    var response = await apiClient.httpPost(
      path: "/FastSaleOrder/DeliveryInvoiceList",
      body: body,
    );

    var json = jsonDecode(response.body);
    if (response.statusCode == 200)
      return TPosApiListResult<FastSaleOrder>(
        count: json["Total"],
        data: (json["Data"] as List)
            .map((f) => FastSaleOrder.fromJson(f))
            .toList(),
      );

    throwTposApiException(response);
    return null;
  }

  /// Lấy danh sách hóa đơn bán hàng
  Future<TPosApiListResult<FastSaleOrder>> getInvoices(
      {take, skip, page, pageSize, sort, filter}) async {
    var body;
    Map temp = {
      "take": take,
      "skip": skip,
      "page": page,
      "pageSize": pageSize,
      "sort": sort,
      "filter": filter,
    }..removeWhere((key, value) => value == null);
    body = jsonEncode(temp);
    var response = await apiClient.httpPost(
      path: "/FastSaleOrder/List",
      body: body,
    );

    var json = jsonDecode(response.body);
    if (response.statusCode == 200)
      return TPosApiListResult<FastSaleOrder>(
        count: json["Total"],
        data: (json["Data"] as List)
            .map((f) => FastSaleOrder.fromJson(f))
            .toList(),
      );

    throwTposApiException(response);
    return null;
  }

  /// Lấy theo id
  Future<FastSaleOrder> getById(int orderId, {bool getForEdit = false}) async {
    var response = await apiClient.httpGet(
        path:
            "/odata/FastSaleOrder($orderId)?\$expand=Partner,User,Warehouse,Company,PriceList,RefundOrder,Account,Journal,PaymentJournal,Carrier,Tax,SaleOrder,OrderLines(\$expand%3DProduct,ProductUOM,Account,SaleLine)");
    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      return FastSaleOrder.fromJson(jsonMap);
    }

    throwTposApiException(response);
    return null;
  }

  /// Lấy theo id copy hóa đơn
  Future<FastSaleOrder> getByIdCopy(int orderId,
      {bool getForEdit = false}) async {
    var response = await apiClient.httpGet(
        path:
            "/odata/FastSaleOrder($orderId)?\$expand=Partner,User,Warehouse,Company,PriceList,RefundOrder,Account,Journal,PaymentJournal,Carrier,Tax,SaleOrder,OrderLines(\$expand%3DProduct,ProductUOM,Account,SaleLine,User),Ship_ServiceExtras,OutstandingInfo(\$expand%3DContent)");
    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      return FastSaleOrder.fromJson(jsonMap);
    }

    throwTposApiException(response);
    return null;
  }

  /// Lấy thông tin hóa đơn khi thay đổi khách hàng
  /// Cập nhật lại bảng giá, Cấu hình giao hàng
  /// Dùng cho chức năng tạo hóa đơn bán hàng nhanh
  Future<OdataResult<FastSaleOrder>> getFastSaleOrderWhenChangePartner(
      FastSaleOrder order) async {
    Map<String, dynamic> model = {"model": order.toJson(removeIfNull: true)};
    String body = jsonEncode(model);

    var response = await apiClient.httpPost(
      path: "/odata/FastSaleOrder/ODataService.OnChangePartner_PriceList",
      params: {"\$expand": "PartnerShipping,PriceList,Account"},
      body: body,
    );

    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      return OdataResult.fromJson(jsonMap, parseValue: () {
        if (response.statusCode.toString().startsWith("2"))
          return FastSaleOrder.fromJson(jsonMap);
        else
          return null;
      });
    }
    throwTposApiException(response);
    return null;
  }

  /// Lấy giá trị mặc định để tạo hóa đơn bán hàng nhanh
  /// Mở rộng các giá trị Warehouse, User, PriceList, Company, Journal, PaymentJournal, Carrier, Tax
  Future<OdataResult<FastSaleOrder>> getFastSaleOrderDefault(
      {List<int> saleOrderIds = const <int>[], String type = "invoice"}) async {
    var model = {
      "model": {"Type": type, "SaleOrderIds": saleOrderIds ?? []}
    };

    String body = jsonEncode(model);

    var response = await apiClient.httpPost(
      path: "/odata/FastSaleOrder/ODataService.DefaultGet",
      params: {
        "\$expand":
            "Warehouse,User,PriceList,Company,Journal,PaymentJournal,Partner,Carrier,Tax"
      },
      body: body,
    );

    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      return OdataResult.fromJson(jsonMap, parseValue: () {
        return FastSaleOrder.fromJson(jsonMap);
      });
    }
    throwTposApiException(response);
    return null;
  }

  /// Lấy đường link pdf in ship qua okieal
  Future<String> printOkielaShip(int fastSaleOrderId) async {
    var response = await apiClient.httpPost(
      path: "/odata/FastSaleOrder/ODataService.PrintShip",
      body: jsonEncode({
        "ids": [
          fastSaleOrderId,
        ]
      }),
    );

    if (response.statusCode == 200) {
      var map = jsonDecode(response.body);
      if (map["data"] != null && map["data"]["orderUrl"] != null) {
        return map["data"]["orderUrl"];
      }
    }
    throwTposApiException(response);
    return null;
  }

  /// Lấy thông tin hóa đơn pdf
  Future<FastSaleOrder> getFastSaleOrderForPDF(int id) async {
    var response =
        await apiClient.httpGet(path: "/odata/FastSaleOrder($id)", param: {
      "\$expand":
          "Partner,User,Warehouse,Company,PriceList,RefundOrder,Account,Journal,PaymentJournal,Carrier,Tax,SaleOrder,OrderLines(\$expand=Product,ProductUOM,Account)",
    });
    if (response.statusCode == 200)
      return FastSaleOrder.fromJson(jsonDecode(response.body));
    throwTposApiException(response);
    return null;
  }

  /// Thêm hóa đơn mới
  Future<FastSaleOrder> insertFastSaleOrder(
      FastSaleOrder order, bool isDraft) async {
    var map = order.toJson(removeIfNull: true);
    String body = jsonEncode(map);
    var response = await apiClient.httpPost(
      path: "/odata/FastSaleOrder",
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonMap = jsonDecode(response.body);
      return FastSaleOrder.fromJson(jsonMap);
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

  /// UPdate fastsale oder
  Future<void> updateFastSaleOrder(FastSaleOrder order) async {
    final map = order.toJson(removeIfNull: true);
    final response = await apiClient.httpPut(
      path: "/odata/FastSaleOrder(${order.id})",
      body: jsonEncode(map),
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      throwTposApiException(response);
    }
  }

  /// Lấy giá trị mặc định tạo hóa đơn bán hàng nhanh từ đơn hàng sale online mà không cần chọn sản phẩm
  Future<CreateQuickFastSaleOrderModel> getQuickCreateFastSaleOrderDefault(
      List<String> saleOnlineIds) async {
    Map<String, dynamic> bodyMap = {"ids": saleOnlineIds.toList()};
    var response = await apiClient.httpPost(
      path: "/odata/SaleOnline_Order/GetDefaultOrderIds",
      params: {
        "\$expand": "Lines(\$expand=Partner),Carrier",
      },
      body: jsonEncode(bodyMap),
    );

    if (response.statusCode == 200) {
      return CreateQuickFastSaleOrderModel.fromJson(jsonDecode(response.body));
    }

    throwTposApiException(response);
    return null;
  }

  ///  Tạo hóa đơn giao hàng nhanh từ đơn hàng sale online với sản phẩm mặc định
  Future<InsertOrderProductDefaultResult> createQuickFastSaleOrder(
      CreateQuickFastSaleOrderModel model) async {
    Map<String, dynamic> bodyMap = {"model": model.toJson(true)};
    var body = jsonEncode(bodyMap);
    var response = await apiClient.httpPost(
        path: "/odata/FastSaleOrder/InsertOrderProductDefault", body: body);

    if (response.statusCode == 200) {
      var result =
          InsertOrderProductDefaultResult.fromJson(jsonDecode(response.body));
      if (result.success == true) {
        model.lines.forEach((f) {
          _analyticsService.logCreateFastSaleOrderFromDefaultProduct(
            carrierType: model.carrier?.deliveryType,
            shopUrl: _settingService.shopUrl,
          );
        });
      }
      return result;
    }
    throwTposApiException(response);
    return null;
  }
}
