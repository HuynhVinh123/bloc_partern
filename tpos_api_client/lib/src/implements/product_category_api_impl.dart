import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstractions/product_category_api.dart';
import 'package:tpos_api_client/src/models/requests/odata_list_query.dart';
import 'package:tpos_api_client/src/models/requests/odata_query.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

class ProductCategoryApiImpl implements ProductCategoryApi {
  ProductCategoryApiImpl({TPosApiClient apiClient}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
  }

  TPosApi _apiClient;

  @override
  Future<OdataListResult<ProductCategory>> gets({OdataListQuery odataListQuery}) async {
    final Map<String, dynamic> response = await _apiClient.httpGet('/odata/ProductCategory/ODataService.GetAll',
        parameters: odataListQuery?.toJson(true));

    return OdataListResult<ProductCategory>.fromJson(response);
  }

  @override
  Future<ProductCategory> getById(int id, {OdataObjectQuery query}) async {
    final Map<String, dynamic> response =
        await _apiClient.httpGet('/odata/ProductCategory($id)', parameters: query?.toJson(true));
    return ProductCategory.fromJson(response);
  }

  @override
  Future<void> delete(int id) async {
    await _apiClient.httpDelete('/odata/ProductCategory($id)');
  }

  @override
  Future<ProductCategory> insert(ProductCategory productCategory) async {
    final Map<String, dynamic> response =
        await _apiClient.httpPost('/odata/ProductCategory', data: productCategory.toJson(true));
    return ProductCategory.fromJson(response);
  }

  @override
  Future<void> update(ProductCategory productCategory) async {
    await _apiClient.httpPut('/odata/ProductCategory(${productCategory.id})', data: productCategory.toJson(true));
  }

  @override
  Future<ProductCategory> getDefault() async {
    final Map<String, dynamic> response = await _apiClient.httpGet('/odata/ProductCategory/ODataService.DefaultGet');

    return ProductCategory.fromJson(response);
  }


  @override
  Future<void> setDelete(List<int> ids, bool isDelete) async {
    await _apiClient.httpPost('/odata/ProductCategory/ODataService.SetIsDelete',
        data: <String, dynamic>{'ids': ids, 'isDelete': isDelete});
  }

}
