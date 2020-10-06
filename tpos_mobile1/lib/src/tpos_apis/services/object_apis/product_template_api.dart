import 'dart:convert';


import 'package:tpos_mobile/feature_group/sale_online/models/tpos_service/odata_filter.dart';
import 'package:tpos_mobile/feature_group/sale_online/services/tpos_api_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/ProductTemplate.dart';
import 'package:tpos_mobile/src/tpos_apis/models/get_product_template_result.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_service_base.dart';

class ProductTemplateApi extends ApiServiceBase {
  @override
  Future<GetProductTemplateResult> gets(
      {int page,
      int pageSize = 1000,
      int skip = 0,
      int take = 1000,
      OdataFilter filter,
      int priceListId,
      List<OdataSortItem> sorts}) async {
    var response = await apiClient.httpPost(
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

  @override
  Future<void> delete(int id) async {
    assert(id != null);
    var response =
        await apiClient.httpDelete(path: "/odata/ProductTemplate($id)");
    if (!response.statusCode.toString().startsWith("2")) {
      throwTposApiException(response);
    }
    return null;
  }

  /// Tìm kiếm productTemplate
  Future<ProductSearchResult<List<ProductTemplate>>> productTemplateSearch(
      String keyword,
      {ProductSearchType type = ProductSearchType.ALL,
      int top,
      int skip,
      bool isSearchStartWith = false,
      OdataSortItem sortBy,
      FilterBase filterItem}) async {
    OdataFilter filter = new OdataFilter();
    filter.logic = "and";
    if (filter.filters == null) {
      filter.filters = new List<FilterBase>();
    }

    Map<String, dynamic> body = {
      "sort": [sortBy],
    };

    if (keyword != null && keyword.isNotEmpty) {
      filter.filters
          .add(new OdataFilter(logic: "or", filters: <OdataFilterItem>[
        OdataFilterItem(
            field: "NameNoSign", operator: "contains", value: keyword),
        OdataFilterItem(field: "Barcode", operator: "eq", value: keyword),
        OdataFilterItem(
            field: "DefaultCode", operator: "contains", value: keyword),
        OdataFilterItem(field: "Name", operator: "contains", value: keyword),
      ]));

      body["filter"] = filter.toJson();
    }

    var response = await apiClient.httpPost(
      path: "/ProductTemplate/List",
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      return new ProductSearchResult(
          error: false,
          resultCount: jsonMap["Total"],
          result: (jsonMap["Data"] as List)
              .map((f) => ProductTemplate.fromJson(f))
              .toList());
    } else {
      throwTposApiException(response);
      return null;
    }
  }

  /// Thêm sản phẩm template
  Future<ProductTemplate> quickInsertProductTemplate(newProduct) async {
    Map jsonMap = newProduct.toJson();
    jsonMap.removeWhere((key, value) {
      return value == null;
    });

    String body = jsonEncode(jsonMap);
    var response = await apiClient.httpPost(
      path: "/odata/ProductTemplate",
      body: body,
    );

    if (response.statusCode == 201) {
      Map resultJsonMap = jsonDecode(response.body);
      return ProductTemplate.fromJson(resultJsonMap);
    }
    throwTposApiException(response);
    return null;
  }

  /// Lấy thông tin product template theo Id
  Future<ProductTemplate> loadProductTemplate(id) async {
    var response = await apiClient.httpGet(
      path: "/odata/ProductTemplate($id)",
      param: {
        "\$expand":
            "UOM,UOMCateg,Categ,UOMPO,POSCateg,Taxes,SupplierTaxes,Product_Teams,Images"
      },
    );
    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      return ProductTemplate.fromJson(jsonMap);
    }
    throwTposApiException(response);
    return null;
  }

  // Thêm một product Teplate
  Future<TPosApiResult<bool>> editProductTemplate(productTemplate) async {
    Map jsonMap = productTemplate.toJson();
    jsonMap.removeWhere((key, value) {
      return value == null;
    });
    String body = jsonEncode(jsonMap);
    var response = await apiClient.httpPut(
      path: "/odata/ProductTemplate(${productTemplate.id})",
      body: body,
    );
    if (response.statusCode.toString().startsWith("2")) {
      return new TPosApiResult(error: false, result: true);
    } else {
      throwTposApiException(response);
      return null;
    }
  }
}
