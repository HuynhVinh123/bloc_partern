import 'dart:convert';

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
    final Map<String, dynamic> param = <String, dynamic>{};

    if (type != null) {
      param['type'] = type;
    }

    final json = await _apiClient.httpGet('/odata/Tag/ODataService.GetByType',
        parameters: param);
    return OdataListResult<Tag>.fromJson(json);
  }

  @override
  Future<void> deleteTag(int tagId) async {
    await _apiClient.httpDelete("/odata/Tag($tagId)");
  }

  @override
  Future<Tag> getTagById(int tagId) async {
    final response = await _apiClient.httpGet("/odata/Tag($tagId)");
    return Tag.fromJson(response);
  }

  @override
  Future<void> updateTag(Tag tag) async {
    final String body = json.encode(tag.toJson());
    await _apiClient.httpPut("/odata/Tag(${tag.id})", data: body);
  }

  @override
  Future<Tag> insertTag(Tag tag) async {
    final String body = json.encode(tag.toJson(true));
    final response = await _apiClient.httpPost("/odata/Tag", data: body);
    return Tag.fromJson(response);
  }

  @override
  Future<OdataListResult<Tag>> getTags(
      {int top, int skip, String keyWord, List<String> typeTags}) async {
    Map<String, dynamic> mapBody = {
      "\$format": "json",
      "\$count": true,
      "\$top": top,
      "\$skip": skip
    };

    if (keyWord != null && keyWord != "") {
      mapBody["\$filter"] =
          "(contains(Name,'$keyWord') or contains(NameNosign,'$keyWord'))";
    }
    if (typeTags != null && typeTags.isNotEmpty) {
      if (keyWord != "") {
        mapBody["\$filter"] += " and ";
      }
      // ignore: avoid_function_literals_in_foreach_calls
      String filterType = "";
      for (int i = 0; i < typeTags.length; i++) {
        if (i == 0)
          filterType += "Type eq '${typeTags[i]}'";
        else
          filterType += "or Type eq '${typeTags[i]}'";
      }

      mapBody["\$filter"] != null
          ? mapBody["\$filter"] += "($filterType)"
          : mapBody["\$filter"] = "($filterType)";
    }

    mapBody = mapBody..removeWhere((key, value) => value == null);

    final response =
        await _apiClient.httpGet("/odata/Tag", parameters: mapBody);
    return OdataListResult<Tag>.fromJson(response);
  }
}
