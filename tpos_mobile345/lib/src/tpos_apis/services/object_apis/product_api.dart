import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_service/odata_filter.dart';
import 'package:tpos_mobile/feature_group/sale_online/services/tpos_api_service.dart';

import 'package:tpos_mobile/src/tpos_apis/models/product.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_service_base.dart';

class ProductApi extends ApiServiceBase {
  /// Lấy sản phẩm theo Template Id
  Future<List<Product>> getByTemplateId(int productTemplateId) async {
    var response = await apiClient.httpGet(
      path: "/odata/Product",
      param: {
        "\$format": "json",
        "\$filter": "ProductTmplId eq $productTemplateId",
        "\$count": true,
      },
    );

    if (response.statusCode == 200) {
      return (jsonDecode(response.body)["value"] as List)
          .map((f) => Product.fromJson(f))
          .toList();
    }
    throwTposApiException(response);
    return null;
  }

  Future<Product> loadProduct(id) async {
    var response = await apiClient.httpGet(
      path: "/odata/Product($id)",
      param: {"\$expand": "UOM,Categ,UOMPO,POSCateg,AttributeValues"},
    );
    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      return Product.fromJson(jsonMap);
    }
    throwTposApiException(response);
    return null;
  }

  Future<TPosApiResult<bool>> editProduct(product) async {
    Map jsonMap = product.toJson();
    jsonMap.removeWhere((key, value) {
      return value == null;
    });
    String body = jsonEncode(jsonMap);
    var response = await apiClient.httpPut(
      path: "/odata/Product(${product.id})",
      body: body,
    );
    if (response.statusCode.toString().startsWith("2")) {
      return new TPosApiResult(error: false, result: true);
    } else {
      String message = (jsonDecode(response.body))["message"];
      return new TPosApiResult(error: true, result: false, message: message);
    }
  }

  Future<Product> quickInsertProduct(newProduct) async {
    Map jsonMap = newProduct.toJson();
    jsonMap.removeWhere((key, value) {
      return value == null;
    });

    String body = jsonEncode(jsonMap);
    var response = await apiClient.httpPost(
      path: "/odata/Product",
      body: body,
    );

    if (response.statusCode == 200) {
      Map resultJsonMap = jsonDecode(response.body);
      return Product.fromJson(resultJsonMap);
    }
    throwTposApiException(response);
    return null;
  }

  Future<List<Product>> getProductsFPO() async {
    Map<String, dynamic> body = {
      "take": 200,
      "skip": 0,
      "page": 1,
      "pageSize": 200,
      "sort": [
        {"field": "Name", "dir": "asc"}
      ]
    };
//    debugPrint(JsonEncoder.withIndent('   ').convert(body));

    var response = await apiClient.httpPost(
        path: "/ProductTemplate/List", body: jsonEncode(body));

    if (response.statusCode == 200) {
      return (jsonDecode(response.body)['Data'] as List)
          .map((f) => Product.fromJson(f))
          .toList();
    } else {
      throw new Exception((jsonDecode(response.body)["message"]) ??
          "${response.statusCode}, ${response.reasonPhrase} ${response.body}");
    }
  }

  Future<List<Product>> actionSearchProduct(String text) async {
    Map<String, dynamic> body = {
      "take": 20,
      "skip": 0,
      "page": 1,
      "pageSize": 20,
      "sort": [
        {"field": "Name", "dir": "asc"}
      ],
      "filter": {
        "logic": "and",
        "filters": [
          {
            "logic": "or",
            "filters": [
              {"field": "Name", "operator": "contains", "value": "$text"},
              {"field": "NameNoSign", "operator": "contains", "value": "$text"},
              {
                "field": "CompanyName",
                "operator": "contains",
                "value": "$text"
              },
              {
                "field": "CompanyNameNoSign",
                "operator": "contains",
                "value": "$text"
              },
            ]
          }
        ]
      }
    };

    var response = await apiClient.httpPost(
        path: "/ProductTemplate/List", body: jsonEncode(body));

    if (response.statusCode == 200) {
      return (jsonDecode(response.body)['Data'] as List)
          .map((f) => Product.fromJson(f))
          .toList();
    } else {
      throw new Exception((jsonDecode(response.body)["message"]) ??
          "${response.statusCode}, ${response.reasonPhrase} ${response.body}");
    }
  }

  Future<List<Product>> getProducts() async {
    var response = await apiClient.httpGet(
        path: "/odata/ProductTemplateUOMLine/ODataService.GetLastVersion",
        param: {"Version": -1});
    if (response.statusCode == 200) {
      return await compute(_getProductsFromJson, response.body);
    }
    throwTposApiException(response);
    return null;
  }

  static List<Product> _getProductsFromJson(String json) {
    var jsonMap = jsonDecode(json);
    return (jsonMap["value"] as List).map((map) {
      return Product.fromJson(map);
    }).toList();
  }

  /// Lấy sản phẩm tìm kiếm theo Id
  /// param ProductId, return Product object
  Future<OdataResult<Product>> getProductSearchById(int productId) async {
    assert(productId != null);
    var response = await apiClient.httpGet(
        path: "/odata/ProductTemplateUOMLine/ODataService.GetLastVersion",
        param: {"Version": -1, "\$filter": "Id eq $productId"});

    var map = jsonDecode(response.body);
    return OdataResult.fromJson(map, parseValue: () {
      final values = (map["value"] as List);
      if (values != null) {
        var firstProduct = values.isNotEmpty ? values.first : null;
        if (firstProduct != null) {
          return Product.fromJson(firstProduct);
        } else {
          return null;
        }
      } else {
        return null;
      }
    });
  }

  /// Lây sản phẩm phân trang
  Future<List<Product>> getProductsPagination(int top, int skip) async {
    var response = await apiClient.httpGet(
        path: "/odata/ProductTemplateUOMLine",
        param: {"\$top": top, "\$skip": skip});
    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      return (jsonMap["value"] as List).map((map) {
        return Product.fromJson(map);
      }).toList();
    }
    throwTposApiException(response);
    return null;
  }

  /// Tìm kiếm sản phẩm
  Future<ProductSearchResult<List<Product>>> productSearch(String keyword,
      {ProductSearchType type = ProductSearchType.ALL,
      int top,
      int skip,
      bool isSearchStartWith = false,
      OdataSortItem sortBy,
      int groupId}) async {
    Map<String, dynamic> param = {"Version": -1};
    String groupParam = "";
    if (groupId != null) {
      groupParam = " and categId eq $groupId";
    }

    if (keyword != null && keyword != "") {
      switch (type) {
        case ProductSearchType.CODE:
          param["\$filter"] = "DefaultCode eq '$keyword'$groupParam";
          break;
        case ProductSearchType.BARCODE:
          param["\$filter"] = "Barcode eq '$keyword'$groupParam";
          break;
        case ProductSearchType.NAME:
          param["\$filter"] = isSearchStartWith == false
              ? "contains(NameNoSign,'$keyword')$groupParam"
              : "startwith(NameNoSign,'$keyword')$groupParam";
          break;
        case ProductSearchType.ALL:
          if (isSearchStartWith) {
            param["\$filter"] =
                "startwith(DefaultCode,'$keyword') or startwith(NameNoSign,'$keyword') or startwith(Barcode,'$keyword')$groupParam";
          } else {
            param["\$filter"] =
                "contains(DefaultCode, '$keyword') or contains(NameNoSign,'$keyword') or contains(Barcode,'$keyword')$groupParam";
          }
          break;
      }
    }

    if (sortBy != null) {
      param["\$orderby"] = sortBy.tourlEncode();
    }

    if (top != null) {
      param["\$top"] = top;
    }
    if (skip != null) {
      param["\$skip"] = skip;
    }

    param["\$count"] = true;
    var response = await apiClient.httpGet(
      path: "/odata/ProductTemplateUOMLine/ODataService.GetLastVersion",
      param: param,
    );

    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      return new ProductSearchResult(
          keyword: keyword,
          error: false,
          resultCount: jsonMap["@odata.count"],
          result: (jsonMap["value"] as List)
              .map((f) => Product.fromJson(f))
              .toList());
    } else {
      throwTposApiException(response);
      return null;
    }
  }

  Future<List<Product>> getLastProductsVersion2(int version) async {
    var response = await apiClient.httpGet(
        path: "/odata/ProductTemplateUOMLine/ODataService.GetLastVersionV2",
        param: {"\$expand": "Datas", "countIndexDB": 68, "Version": version});

    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      return (jsonMap["value"] as List).map((map) {
        return Product.fromJson(map);
      }).toList();
    }
    throwTposApiException(response);
    return null;
  }
}
