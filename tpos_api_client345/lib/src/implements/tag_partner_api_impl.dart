import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstraction.dart';
import 'package:tpos_api_client/src/abstractions/tag_partner_api.dart';
import 'package:tpos_api_client/src/models/entities/tag.dart';
import 'package:tpos_api_client/src/models/requests/assign_tag_partner_model.dart';
import 'package:tpos_api_client/src/models/results/odata_list_result.dart';

class TagPartnerApiImpl implements TagPartnerApi {
  TagPartnerApiImpl({TPosApi apiClient}) {
    _apiClient = apiClient ?? GetIt.I<TPosApi>();
  }

  static const String assignTagPartnerPath =
      '/odata/TagPartner/ODataService.AssignTagPartner';
  TPosApi _apiClient;
  @override
  Future<AssignTagPartnerModel> assignTag(AssignTagPartnerModel model) async {
    final json = await _apiClient.httpPost(assignTagPartnerPath,
        data: model.toJson(true));
    return AssignTagPartnerModel.fromJson(json);
  }

  @override
  Future<OdataListResult<Tag>> getTagsByType(String type) async {
    final Map<String, dynamic> param = {'type': type};
    final json = await _apiClient.httpGet('/odata/Tag/ODataService.GetByType',
        parameters: param);
    return OdataListResult<Tag>.fromJson(json);
  }
}
