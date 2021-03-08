import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstractions/tpage_api/product_tpage_api.dart';

import '../../../tpos_api_client.dart';

class ProductTPageApiImpl implements ProductTPageApi {
  ProductTPageApiImpl({TPosApiClient apiClient}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
  }
  TPosApiClient _apiClient;

  @override
  Future<List<Product>> getProductTPage(
      {int skip, int top, String keyWord}) async {
    List<Product> products = [];
    final Map<String, dynamic> mapBody = {
      "\$skip": skip,
      "\$top": top,
      "\$orderby": "Name",
      "\$count": "true",
      "\$filter": keyWord == null || keyWord == ""
          ? null
          : "(contains(DefaultCode,'$keyWord') or contains(Name,'$keyWord'))",
    }..removeWhere((key, value) => value == null);

    final response =
        await _apiClient.httpGet("/odata/Product", parameters: mapBody);
    products =
        (response["value"] as List).map((e) => Product.fromJson(e)).toList();
    return products;
  }

  @override
  Future<List<Product>> getProductIsAvailable(
      {bool isFilter = true, int skip, int top}) async {
    List<Product> products = [];
    final Map<String, dynamic> mapBody = {
      "\$filter": "IsAvailableOnTPage eq $isFilter",
      "\$count": "true",
      "\$skip": skip,
      "\$top": top,
      "\$orderby": "Name",
    };

    final response =
        await _apiClient.httpGet("/odata/Product", parameters: mapBody);
    products =
        (response["value"] as List).map((e) => Product.fromJson(e)).toList();
    return products;
  }

  @override
  Future<void> updateStatusProductTPage(String productId) async {
    await _apiClient
        .httpPost("/odata/Product($productId)/ODataService.UpdateStatus");
  }

  Future<void> deleteMailTemplateTPage(int mailId) async {
    await _apiClient.httpDelete("/odata/MailTemplate($mailId)");
  }
}
