import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstraction.dart';
import 'package:tpos_api_client/src/models/entities/product/product_uom_category.dart';
import 'package:tpos_api_client/src/models/requests/odata_list_query.dart';
import 'package:tpos_api_client/src/models/requests/odata_query.dart';
import 'package:tpos_api_client/src/models/results/odata_list_result.dart';

class ProductUomCategoryApiImpl implements ProductUomCategoryApi {
  ProductUomCategoryApiImpl({TPosApi tPosApi}) {
    _apiClient = tPosApi ?? GetIt.instance<TPosApi>();
  }

  TPosApi _apiClient;

  @override
  Future<OdataListResult<ProductUomCategory>> getList({OdataListQuery query}) async {
    final Map<String, dynamic> response =
        await _apiClient.httpGet("/odata/ProductUOMCateg", parameters: query?.toJson(true));
    return OdataListResult<ProductUomCategory>.fromJson(response);
  }

  @override
  Future<ProductUomCategory> getById(int id, {OdataObjectQuery query}) async {
    final Map<String, dynamic> response =
        await _apiClient.httpGet('/odata/ProductUOMCateg($id)', parameters: query?.toJson(true));
    return ProductUomCategory.fromJson(response);
  }

  @override
  Future<void> delete(int id) async {
    await _apiClient.httpDelete('/odata/ProductUOMCateg($id)');
  }

  @override
  Future<ProductUomCategory> insert(ProductUomCategory productUomCategory) async {
    final Map<String, dynamic> response =
        await _apiClient.httpPost('/odata/ProductUOMCateg', data: productUomCategory.toJson(true));
    return ProductUomCategory.fromJson(response);
  }

  @override
  Future<void> update(ProductUomCategory productUomCategory) async {
    await _apiClient.httpPut('/odata/ProductUOMCateg(${productUomCategory.id})',
        data: productUomCategory.toJson(true));
  }
}
