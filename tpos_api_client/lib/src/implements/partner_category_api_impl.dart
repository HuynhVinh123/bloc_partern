import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstraction.dart';
import 'package:tpos_api_client/src/abstractions/partner_category_api.dart';
import 'package:tpos_api_client/src/models/entities/partner_category.dart';
import 'package:tpos_api_client/src/models/requests/odata_list_query.dart';
import 'package:tpos_api_client/src/models/requests/odata_query.dart';

class PartnerCategoryApiImpl implements PartnerCategoryApi {
  PartnerCategoryApiImpl({TPosApi tPosApi}) {
    _apiClient = tPosApi ?? GetIt.instance<TPosApi>();
  }

  TPosApi _apiClient;

  @override
  Future<List<PartnerCategory>> getList({OdataListQuery odataListQuery}) async {
    final Map<String, dynamic> response = await _apiClient.httpPost(
        "/PartnerCategory/List",
        parameters: odataListQuery?.toJson(true));
    final json = response['Data'];
    final data = <PartnerCategory>[];
    if (json != null) {
      json.forEach((v) {
        data.add(PartnerCategory.fromJson(v));
      });
    }
    return data;
  }

  @override
  Future<PartnerCategory> getById(int id, {OdataObjectQuery query}) async {
    final Map<String, dynamic> response = await _apiClient.httpGet(
        '/odata/PartnerCategory($id)',
        parameters: query?.toJson(true));
    return PartnerCategory.fromJson(response);
  }

  @override
  Future<void> delete(int categoryId) async {
    await _apiClient.httpDelete('/odata/PartnerCategory($categoryId)');
  }

  @override
  Future<PartnerCategory> insert(PartnerCategory partnerCategory) async {
    assert(partnerCategory != null);
    final Map<String, dynamic> response = await _apiClient
        .httpPost('/odata/PartnerCategory', data: partnerCategory.toJson(true));
    return PartnerCategory.fromJson(response);
  }

  @override
  Future<void> update(PartnerCategory partnerCategory) async {
    assert(partnerCategory != null);
    await _apiClient.httpPut('/odata/PartnerCategory(${partnerCategory.id})',
        data: partnerCategory.toJson(true));
  }
}
