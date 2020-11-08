import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/sale_online/models/tpos_service/odata_filter.dart';
import 'package:tpos_mobile/feature_group/sale_online/services/tpos_api_service.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_service_base.dart';

import '../../tpos_api.dart';
import '../tpos_api_client.dart';

class PartnerCategoryApi extends ApiServiceBase {
  final Logger _logger = Logger();

  Future<TPosApiResult<bool>> editPartnerCategory(partnerCategory) async {
    Map jsonMap = partnerCategory.toJson();
    jsonMap.removeWhere((key, value) {
      return value == null;
    });
    String body = jsonEncode(jsonMap);
    var response = await apiClient.httpPut(
      path: "/odata/PartnerCategory(${partnerCategory.id})",
      body: body,
    );
    if (response.statusCode.toString().startsWith("2")) {
      return new TPosApiResult(error: false, result: true);
    } else {
      String message = jsonDecode(response.body)["errors"]["model.Phone"];
      return new TPosApiResult(error: true, result: false, message: message);
    }
  }

  Future<List<PartnerCategory>> getPartnerCategorys() async {
    List<PartnerCategory> _partnerCategorys = [];
    var response = await apiClient.httpGet(
        path:
            "/odata/PartnerCategory?\$orderby=ParentLeft&%24format=json&%24filter=Active+eq+true&%24count=true");

    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      _partnerCategorys = (map["value"] as List)
          .map((val) => PartnerCategory.fromJson(val))
          .toList();
      return _partnerCategorys;
    }
    throwHttpException(response);
    return null;
  }

  Future<ProductSearchResult<List<PartnerCategory>>> partnerCategorySearch(
      String keyword,
      {int top,
      int skip,
      bool isSearchStartWith = false,
      OdataSortItem sortBy,
      FilterBase filterItem}) async {
    OdataFilter filter = OdataFilter();
    filter.logic = "and";
    filter.filters ??= <FilterBase>[];

    Map<String, dynamic> body = {};

    if (keyword != null && keyword.isNotEmpty) {
      filter.filters.add(OdataFilter(logic: "or", filters: <OdataFilterItem>[
        OdataFilterItem(
            field: "CompleteName", operator: "contains", value: keyword),
      ]));

      body["filter"] = filter.toJson();
    }

    var response = await apiClient.httpPost(
      path: "/PartnerCategory/List",
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      return ProductSearchResult(
          error: false,
          resultCount: jsonMap["Total"],
          result: (jsonMap["Data"] as List)
              .map((f) => PartnerCategory.fromJson(f))
              .toList());
    } else {
      throwTposApiException(response);
    }
    return null;
  }

  Future<OdataResult<PartnerCategory>> getPartnerCategory(int id) async {
    var response =
        await apiClient.httpGet(path: "/odata/PartnerCategory($id)", param: {
      "\$expand": "Parent",
    });
    return OdataResult.fromJson(jsonDecode(response.body), parseValue: () {
      return PartnerCategory.fromJson(jsonDecode(response.body));
    });
  }

  Future<PartnerCategory> insertPartnerCategory(partnerCategory) async {
    Map jsonMap = partnerCategory.toJson();
    jsonMap.removeWhere((key, value) {
      return value == null;
    });

    String body = jsonEncode(jsonMap);
    var response = await apiClient.httpPost(
      path: "/odata/PartnerCategory",
      body: body,
    );

    if (response.statusCode == 201) {
      Map resultJsonMap = jsonDecode(response.body);
      return PartnerCategory.fromJson(resultJsonMap);
    }
    throwTposApiException(response);
    return null;
  }

  Future<List<PartnerCategory>> getPartnerCategories() async {
    var response = await apiClient.httpGet(
      path:
          "/odata/PartnerCategory?\$orderby=ParentLeft&%24format=json&%24count=true",
    );
    if (response.statusCode == 200) {
      var jsonMap = jsonDecode(response.body);
      return (jsonMap["value"] as List).map((map) {
        return PartnerCategory.fromJson(map);
      }).toList();
    }
    throwTposApiException(response);
    return null;
  }
}
