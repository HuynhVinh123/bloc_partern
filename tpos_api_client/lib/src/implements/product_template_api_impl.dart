import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstractions/product_template_api.dart';
import 'package:tpos_api_client/src/models/requests/get_product_template_query.dart';
import 'package:tpos_api_client/src/models/results/get_product_template_result.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

class ProductTemplateApiImpl implements ProductTemplateApi {
  ProductTemplateApiImpl({TPosApiClient apiClient}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
  }

  TPosApi _apiClient;

  @override
  Future<void> delete(int id) async {
    await _apiClient.httpDelete("/odata/ProductTemplate($id)");
  }

  @override
  Future<ProductTemplate> getById(int id, [String expand]) async {
    final Map<String, dynamic> response = await _apiClient.httpGet("/odata/ProductTemplate($id)",
        parameters: <String, dynamic>{'\$expand': expand}..removeWhere((String key, dynamic value) => value == null));

    return ProductTemplate.fromJson(response);
  }

  @override
  Future<GetProductTemplateResult> getList({int priceId, String tagIds, GetProductTemplateQuery query}) async {
    final Map<String, dynamic> body = query.toJson(true);

    final Map<String, dynamic> response = await _apiClient.httpPost("/ProductTemplate/List",
        data: body,
        parameters: <String, dynamic>{'TagIds': tagIds, 'priceId': priceId}
          ..removeWhere((String key, dynamic value) => value == null));

    return GetProductTemplateResult.fromJson(response);
  }

  @override
  Future<ProductTemplate> insert(ProductTemplate data) async {
    final Map<String, dynamic> response =
        await _apiClient.httpPost("/odata/ProductTemplate", data: data.toJson(removeIfNull: true));
    return ProductTemplate.fromJson(response);
  }

  @override
  Future<void> update(ProductTemplate data) async {
    await _apiClient.httpPut("/odata/ProductTemplate(${data.id})", data: data.toJson(removeIfNull: true));
  }

  @override
  Future<void> deletes(List<int> ids) async {
    final Map<String, dynamic> body = {"ids": ids};

    await _apiClient.httpPost("/odata/ProductTemplate/ODataService.RemoveIds", data: body);
  }

  @override
  Future<ProductTemplate> getDefault([String expand]) async {
    final Map<String, dynamic> response = await _apiClient.httpGet("/odata/ProductTemplate/ODataService.DefaultGet",
        parameters: <String, dynamic>{'\$expand': expand}..removeWhere((String key, dynamic value) => value == null));

    return ProductTemplate.fromJson(response);
  }

  /// TODO Check lại hàm lấy chi tiết sảm phẩm ở đây. Không có barcode
  ///Dùng để lấy chi tiết sản phẩm
  @override
  Future<ProductTemplate> getByDetails(int id, [String expand]) async {
    final Map<String, dynamic> response = await _apiClient.httpGet(
        "/odata/ProductTemplate($id)/ODataService.GetDetailView",
        parameters: <String, dynamic>{'\$expand': expand}..removeWhere((String key, dynamic value) => value == null));
    return ProductTemplate.fromJson(response);
  }

  @override
  Future<OdataListResult<InventoryProduct>> getInventoryProducts([GetProductTemplateInventoryQuery query]) async {
    final Map<String, dynamic> response = await _apiClient.httpGet(
        "/odata/ProductTemplate/ODataService.GetInventoryProduct",
        parameters: query.toJson(true)..removeWhere((String key, dynamic value) => value == null));

    return OdataListResult<InventoryProduct>.fromJson(response);
  }

  @override
  Future<void> setActive(bool active, List<int> ids) async {
    final Map<String, dynamic> body = {
      'model': {"Ids": ids, 'Active': active}
    };

    await _apiClient.httpPost("/odata/ProductTemplate/ODataService.SetActive", data: body);
  }

  @override
  Future<OdataListResult<ProductAttributeValue>> getAttributeValues(int id, [OdataGetListQuery getListQuery]) async {
    final Map<String, dynamic> parameters = getListQuery?.toMapOfParam(true);
    final Map<String, dynamic> response =
        await _apiClient.httpGet("/odata/ProductTemplate($id)/ODataService.GetAttributeValues", parameters: parameters);

    return OdataListResult<ProductAttributeValue>.fromJson(response);
  }

  @override
  Future<ProductAttributeValue> getVariantPrice({int id, int attributeValueId, String expand}) async {
    final Map<String, dynamic> response = await _apiClient.httpGet(
        "/odata/ProductTemplate($id)/ODataService.GetVariantPrice",
        parameters: {'value_id': attributeValueId, '\$expand': expand});

    return ProductAttributeValue.fromJson(response);
  }

  @override
  Future<void> updateVariantPrice({int id, ProductAttributeValue productAttributeValue}) async {
    await _apiClient.httpPost("/odata/ProductTemplate($id)/ODataService.UpdateVariantPrice",
        data: productAttributeValue?.toJson(true));
  }

  @override
  Future<ProductAttributeValue> insertVariantPrice({int id, ProductAttributeValue productAttributeValue}) async {
    final Map<String, dynamic> response = await _apiClient.httpPost(
        "/odata/ProductTemplate($id)/ODataService.AddVariantPrice",
        data: productAttributeValue?.toJson(true));
    return ProductAttributeValue.fromJson(response);
  }

  @override
  Future<OdataListResult<Product>> getVariants({int id, OdataGetListQuery getListQuery}) async {
    final Map<String, dynamic> parameters = getListQuery?.toMapOfParam(true);
    final Map<String, dynamic> response =
        await _apiClient.httpGet("/odata/ProductTemplate($id)/ODataService.GetVariants", parameters: parameters);

    return OdataListResult<Product>.fromJson(response);
  }

  @override
  Future<Product> getVariant({int variantId, String expand = 'AttributeValues'}) async {
    final Map<String, dynamic> response = await _apiClient.httpGet("/odata/ProductTemplate/ODataService.GetVariant",
        parameters: <String, dynamic>{'\$expand': expand, 'variant_id': variantId});

    return Product.fromJson(response);
  }

  @override
  Future<void> updateVariant({int id, Product product}) async {
    await _apiClient.httpPost("/odata/ProductTemplate($id)/ODataService.UpdateVariant",
        data: product?.toJson(removeIfNull: true));
  }

  @override
  Future<ProductTemplate> onChangeUOM({@required ProductTemplate productTemplate, String expand = 'UOMPO'}) async {
    final Map<String, dynamic> response = await _apiClient.httpPost("/odata/ProductTemplate/ODataService.OnChangeUOM",
        data: <String, dynamic>{'model': productTemplate?.toJson(removeIfNull: true)},
        parameters: <String, dynamic>{'\$expand': expand});
    return ProductTemplate.fromJson(response);
  }

  @override
  Future<OdataListResult<ProductUOMLine>> getProductUOMLines(
      {@required int productTemplateId, String expand = 'UOM'}) async {
    final Map<String, dynamic> response = await _apiClient.httpGet(
        "/odata/ProductTemplate($productTemplateId)/UOMLines",
        parameters: <String, dynamic>{'\$expand': expand});
    return OdataListResult<ProductUOMLine>.fromJson(response);
  }
}
