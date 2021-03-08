import 'dart:convert';

import 'package:tpos_api_client/tpos_api_client.dart' as tpos_client;
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_service/odata_filter.dart';
import 'package:tpos_mobile/feature_group/sale_online/services/tpos_api_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/get_product_template_result.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_service_base.dart';

@Deprecated(
    'Product template api is obsolete and will be replace by tpos_api_client.ProductTemplateApi.')
class ProductTemplateApi extends ApiServiceBase {
  @Deprecated('')
  @override
  Future<GetProductTemplateResult> gets(
      {int page,
      int pageSize = 1000,
      int skip = 0,
      int take = 1000,
      OldOdataFilter filter,
      int priceListId,
      List<OldOdataSortItem> sorts}) async {
    final response = await apiClient.httpPost(
      path: "/ProductTemplate/List",
      params: {"priceId": priceListId}
        ..removeWhere((key, value) => value == null),
      body: jsonEncode({
        "page": page,
        "pageSize": pageSize,
        "skip": skip,
        "take": take,
        "filter": filter?.toJson(),
        "sort": sorts.map((f) => f.toJson()).toList()
      }..removeWhere((key, value) => value == null)),
    );

    if (response.statusCode == 200)
      return GetProductTemplateResult.fromJson(jsonDecode(response.body));
    throwTposApiException(response);
    return null;
  }

  @Deprecated('')
  @override
  Future<void> delete(int id) async {
    assert(id != null);
    final response =
        await apiClient.httpDelete(path: "/odata/ProductTemplate($id)");
    if (!response.statusCode.toString().startsWith("2")) {
      throwTposApiException(response);
    }
    return;
  }

  @Deprecated('')

  /// Tìm kiếm productTemplate
  Future<ProductSearchResult<List<tpos_client.ProductTemplate>>>
      productTemplateSearch(String keyword,
          {ProductSearchType type = ProductSearchType.ALL,
          int top,
          int skip,
          bool isSearchStartWith = false,
          OldOdataSortItem sortBy,
          OldFilterBase filterItem}) async {
    final OldOdataFilter filter = OldOdataFilter();
    filter.logic = "and";
    filter.filters ??= <OldFilterBase>[];

    final Map<String, dynamic> body = {
      "sort": [sortBy],
    };

    if (keyword != null && keyword.isNotEmpty) {
      filter.filters
          .add(OldOdataFilter(logic: "or", filters: <OldOdataFilterItem>[
        OldOdataFilterItem(
            field: "NameNoSign", operator: "contains", value: keyword),
        OldOdataFilterItem(field: "Barcode", operator: "eq", value: keyword),
        OldOdataFilterItem(
            field: "DefaultCode", operator: "contains", value: keyword),
        OldOdataFilterItem(field: "Name", operator: "contains", value: keyword),
      ]));

      body["filter"] = filter.toJson();
    }

    final response = await apiClient.httpPost(
      path: "/ProductTemplate/List",
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      return ProductSearchResult(
          error: false,
          resultCount: jsonMap["Total"],
          result: (jsonMap["Data"] as List)
              .map((f) => tpos_client.ProductTemplate.fromJson(f))
              .toList());
    } else {
      throwTposApiException(response);
      return null;
    }
  }

  @Deprecated('')

  /// Thêm sản phẩm template
  Future<tpos_client.ProductTemplate> quickInsertProductTemplate(
      newProduct) async {
    final Map jsonMap = newProduct.toJson();
    jsonMap.removeWhere((key, value) {
      return value == null;
    });

    final String body = jsonEncode(jsonMap);
    final response = await apiClient.httpPost(
      path: "/odata/ProductTemplate",
      body: body,
    );

    if (response.statusCode == 201) {
      final Map resultJsonMap = jsonDecode(response.body);
      return tpos_client.ProductTemplate.fromJson(resultJsonMap);
    }
    throwTposApiException(response);
    return null;
  }

  @Deprecated('')

  /// Lấy thông tin product template theo Id
  Future<tpos_client.ProductTemplate> loadProductTemplate(id) async {
    final response = await apiClient.httpGet(
      path: "/odata/ProductTemplate($id)",
      param: {
        "\$expand":
            "UOM,UOMCateg,Categ,UOMPO,POSCateg,Taxes,SupplierTaxes,Product_Teams,Images"
      },
    );
    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      return tpos_client.ProductTemplate.fromJson(jsonMap);
    }
    throwTposApiException(response);
    return null;
  }

  @Deprecated('')
  // Thêm một product Teplate
  Future<TPosApiResult<bool>> editProductTemplate(productTemplate) async {
    final Map jsonMap = productTemplate.toJson();
    jsonMap.removeWhere((key, value) {
      return value == null;
    });
    final String body = jsonEncode(jsonMap);
    final response = await apiClient.httpPut(
      path: "/odata/ProductTemplate(${productTemplate.id})",
      body: body,
    );
    if (response.statusCode.toString().startsWith("2")) {
      return TPosApiResult(error: false, result: true);
    } else {
      throwTposApiException(response);
      return null;
    }
  }
}
