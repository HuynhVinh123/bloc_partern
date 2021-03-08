import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstraction.dart';
import 'package:tpos_api_client/src/abstractions/product_uom_api.dart';
import 'package:tpos_api_client/src/model.dart';
import 'package:tpos_api_client/src/models/requests/odata_list_query.dart';
import 'package:tpos_api_client/src/models/results/odata_list_result.dart';

class ProductUomApiImpl implements ProductUomApi {
  ProductUomApiImpl({TPosApi tPosApi}) {
    _apiClient = tPosApi ?? GetIt.instance<TPosApi>();
  }

  TPosApi _apiClient;

  @override
  Future<OdataListResult<ProductUOM>> getList({OdataListQuery query}) async {
    final Map<String, dynamic> response =
        await _apiClient.httpGet("/odata/ProductUOM", parameters: query?.toJson(true));
    return OdataListResult<ProductUOM>.fromJson(response);
  }

  @override
  Future<ProductUOM> getById(int id, {OdataObjectQuery query}) async {
    final Map<String, dynamic> response =
        await _apiClient.httpGet('/odata/ProductUOM($id)', parameters: query?.toJson(true));
    return ProductUOM.fromJson(response);
  }

  @override
  Future<void> delete(int id) async {
    await _apiClient.httpDelete('/odata/ProductUOM($id)');
  }

  @override
  Future<ProductUOM> insert(ProductUOM productCategory) async {
    final Map<String, dynamic> response =
        await _apiClient.httpPost('/odata/ProductUOM', data: productCategory.toJson(true));
    return ProductUOM.fromJson(response);
  }

  @override
  Future<void> update(ProductUOM productCategory) async {
    await _apiClient.httpPut('/odata/ProductUOM(${productCategory.id})', data: productCategory.toJson(true));
  }

  @override
  Future<ProductUOM> getDefault() async {
    final Map<String, dynamic> response = await _apiClient.httpGet('/odata/ProductUOM/ODataService.DefaultGet');

    return ProductUOM.fromJson(response);
  }
}
