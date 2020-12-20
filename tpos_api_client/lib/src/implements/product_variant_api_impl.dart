import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstractions/product_variant_api.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

class ProductVariantApiImpl implements ProductVariantApi {
  ProductVariantApiImpl({TPosApiClient apiClient}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
  }

  TPosApi _apiClient;

  @override
  Future<Product> getById(int id, {String expand}) async {
    final Map<String, dynamic> response = await _apiClient.httpGet("/odata/Product($id)",
        parameters: <String, dynamic>{'\$expand': expand}..removeWhere((String key, dynamic value) => value == null));
    return Product.fromJson(response);
  }

  @override
  Future<void> update(Product product) async {
    await _apiClient.httpPut("/odata/Product(${product.id})", data: product.toJson(removeIfNull: true));
  }

  @override
  Future<Product> insert(Product product) async {
    final Map<String, dynamic> response =
        await _apiClient.httpPost("/odata/Product", data: product.toJson(removeIfNull: true));
    return Product.fromJson(response);
  }

  @override
  Future<void> delete(int id) async {
    await _apiClient.httpDelete("/odata/Product($id)");
  }

  @override
  Future<void> setActive(bool active, List<int> ids) async {
    final Map<String, dynamic> body = {
      'model': {"Ids": ids, 'Active': active}
    };

    await _apiClient.httpPost("/odata/Product/ODataService.SetActive", data: body);
  }
}
