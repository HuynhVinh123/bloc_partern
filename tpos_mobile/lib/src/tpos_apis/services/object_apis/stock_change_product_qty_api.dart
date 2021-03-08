import 'dart:convert';

import 'package:tpos_mobile/src/tpos_apis/models/stock_change_product_quantity.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_service_base.dart';

/// Các api điều chỉnh tồn kho sản phẩm
abstract class IStockChangeProductQtyApi {
  /// Lấy mặc định sửa
  Future<StockChangeProductQuantity> defaultGet(productTemplateId);

  Future<StockChangeProductQuantity> insert(StockChangeProductQuantity item);

  /// Áp dụng thay đổi tồn kho
  Future<void> changeProductQuantity(int stockChangeProductQtyId);

  Future<StockChangeProductQuantity> getOnChangedProduct(
      StockChangeProductQuantity item,
      {String expand = "ProductTmpl,Product,Location"});
}

class StockChangeProductQtyApi extends ApiServiceBase
    implements IStockChangeProductQtyApi {
  @override
  Future<StockChangeProductQuantity> defaultGet(productTemplateId) async {
    final response = await apiClient.httpPost(
      path: "/odata/StockChangeProductQty/ODataService.DefaultGet",
      params: {"\$expand": "ProductTmpl,Product,Location"},
      body: jsonEncode(
        {
          "model": {
            "ProductTmplId": productTemplateId,
          }
        },
      ),
    );

    if (response.statusCode == 200)
      return StockChangeProductQuantity.fromJson(jsonDecode(response.body));
    throwTposApiException(response);
    return null;
  }

  @override
  Future<StockChangeProductQuantity> insert(
      StockChangeProductQuantity item) async {
    final response = await apiClient.httpPost(
      path: "/odata/StockChangeProductQty",
      body: jsonEncode(
        item.toJson(true),
      ),
    );

    if (response.statusCode == 201)
      return StockChangeProductQuantity.fromJson(jsonDecode(response.body));
    throwTposApiException(response);
    return null;
  }

  @override
  Future<void> changeProductQuantity(int stockChangeProductQtyId) async {
    final response = await apiClient.httpPost(
      path: "/odata/StockChangeProductQty/ODataService.ChangeProductQty",
      body: jsonEncode(
        {"id": stockChangeProductQtyId},
      ),
    );

    if (response.statusCode != 204) throwTposApiException(response);
    return null;
  }

  @override
  Future<StockChangeProductQuantity> getOnChangedProduct(
      StockChangeProductQuantity item,
      {String expand = "ProductTmpl,Product,Location"}) async {
    final response = await apiClient.httpPost(
      path: "/odata/StockChangeProductQty/ODataService.OnChangeProduct",
      params: {"\$expand": expand},
      body: jsonEncode(
        {
          "model": item.toJson(true),
        },
      ),
    );

    if (response.statusCode == 200)
      return StockChangeProductQuantity.fromJson(jsonDecode(response.body));
    throwTposApiException(response);
    return null;
  }
}
