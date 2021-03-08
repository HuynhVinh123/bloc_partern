import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstractions/product_attribute_api.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

class ProductAttributeApiImpl implements ProductAttributeApi {
  ProductAttributeApiImpl({TPosApiClient apiClient}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
  }

  TPosApi _apiClient;

  @override
  Future<OdataListResult< ProductAttribute>> getList({OdataListQuery query}) async {
    final Map<String, dynamic> response =
        await _apiClient.httpGet("/odata/ProductAttribute", parameters: query?.toJson(true));
    return OdataListResult< ProductAttribute>.fromJson(response);
  }

  @override
  Future<ProductAttribute> getById(int id, {String expand = 'Attribute'}) async {
    final Map<String, dynamic> response = await _apiClient.httpGet("/odata/ProductAttributeValue($id)",
        parameters: <String, dynamic>{'\$expand': expand}..removeWhere((String key, dynamic value) => value == null));
    return ProductAttribute.fromJson(response);
  }

  @override
  Future<void> update(ProductAttribute productAttributeLine) async {
    await _apiClient.httpPut("/odata/ProductAttribute(${productAttributeLine.id})",
        data: productAttributeLine.toJson(true));
  }

  @override
  Future<ProductAttribute> insert(ProductAttribute productAttributeLine) async {
    final Map<String, dynamic> response =
        await _apiClient.httpPost("/odata/ProductAttribute", data: productAttributeLine.toJson(true));
    return ProductAttribute.fromJson(response);
  }

  @override
  Future<void> delete(int id) async {
    await _apiClient.httpDelete("/odata/ProductAttribute($id)");
  }

  @override
  Future<OdataListResult< ProductAttribute>> getProductAttributeLineList(int id, [String expand]) async {
    final Map<String, dynamic> response = await _apiClient.httpGet("/odata/ProductTemplate($id)/AttributeLines",
        parameters: <String, dynamic>{'\$expand': expand}..removeWhere((String key, dynamic value) => value == null));
    return OdataListResult< ProductAttribute>.fromJson(response);
  }
}
