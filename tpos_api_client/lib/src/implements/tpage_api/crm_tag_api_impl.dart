import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstractions/tpage_api/crm_tag_api.dart';
import 'package:tpos_api_client/src/abstractions/tpage_api/product_tpage_api.dart';
import 'package:tpos_api_client/src/models/entities/tpage/crm_tag.dart';

import '../../../tpos_api_client.dart';

class CRMTagApiImpl implements CRMTagApi {
  CRMTagApiImpl({TPosApiClient apiClient}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
  }
  TPosApiClient _apiClient;

  @override
  Future<List<CRMTag>> getCRMTag() async {
    List<CRMTag> tags = [];
    final response = await _apiClient.httpGet("/odata/CRMTag");
    tags = (response["value"] as List).map((e) => CRMTag.fromJson(e)).toList();
    return tags;
  }

  @override
  Future<CRMTag> insertCRMTagTPage(CRMTag tagTPage) async {
    final Map<String, dynamic> mapBody = tagTPage.toJson(true);
    final String body = json.encode(mapBody);
    final response = await _apiClient.httpPost("/odata/CRMTag", data: body);
    return CRMTag.fromJson(response);
  }

  @override
  Future<void> deleteCRMTagTPage(String tagId) async {
    await _apiClient.httpDelete("/odata/CRMTag($tagId)");
  }

  @override
  Future<void> updateCRMTagTPage(CRMTag tagTPage) async {
    final Map<String, dynamic> mapBody = tagTPage.toJson(true);
    final String body = json.encode(mapBody);
    await _apiClient.httpPut("/odata/CRMTag(${tagTPage.id})", data: body);
  }

  @override
  Future<void> updateStatusCRMTagTPage(String tagId) async {
    await _apiClient
        .httpPost("/odata/CRMTag($tagId)/ODataService.UpdateStatus");
  }
}
