import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstractions/product_attribute_value_api.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

class ProductAttributeValueApiImpl implements ProductAttributeValueApi {
  ProductAttributeValueApiImpl({TPosApiClient apiClient}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
  }

  TPosApi _apiClient;

  @override
  Future<OdataListResult<ProductAttributeValue>> getList({GetProductAttributeForSearchQuery query}) async {
    final Map<String, dynamic> response =
        await _apiClient.httpGet("/odata/ProductAttributeValue", parameters: query?.toJson(true));
    return OdataListResult<ProductAttributeValue>.fromJson(response);
  }

  @override
  Future<ProductAttributeValue> insert(ProductAttributeValue productAttribute) async {
    assert(productAttribute != null);
    final Map<String, dynamic> response =
        await _apiClient.httpPost("/odata/ProductAttributeValue", data: productAttribute.toJson(true));

    return ProductAttributeValue.fromJson(response);
  }

  @override
  Future<void> update(ProductAttributeValue productAttribute) async {
    assert(productAttribute != null);
    await _apiClient.httpPut("/odata/ProductAttributeValue(${productAttribute.id})", data: productAttribute.toJson(true));
  }

  @override
  Future<void> delete(int id) async {
    await _apiClient.httpDelete(
      "/odata/ProductAttributeValue($id)",
    );
  }

  @override
  Future<ProductAttributeValue> getById(int id, {String expand = 'Attribute'}) async {
    final Map<String, dynamic> response = await _apiClient.httpGet("/odata/ProductAttributeValue($id)",
        parameters: <String, dynamic>{'\$expand': expand}..removeWhere((String key, dynamic value) => value == null));
    return ProductAttributeValue.fromJson(response);
  }
}
