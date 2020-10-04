import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstractions/crmteam_api.dart';
import 'package:tpos_api_client/src/abstractions/tpos_api_client.dart';
import 'package:tpos_api_client/src/models/entities/crm_team.dart';
import 'package:tpos_api_client/src/models/results/odata_list_result.dart';
import 'package:tpos_api_client/src/models/results/odata_result.dart';

class CrmTeamApiImpl implements CrmTeamApi {
  TPosApiClient _apiClient;
  CrmTeamApiImpl({TPosApi apiClient}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
  }

  @override
  Future<OdataListResult<CRMTeam>> getAllFacebook(
      {String expand = 'Childs'}) async {
    final json = await _apiClient.httpGet(
      '/odata/CRMTeam/OdataService.GetAllFacebook',
      parameters: {'\$expand': expand}
        ..removeWhere((key, value) => value == null),
    );

    return OdataListResult<CRMTeam>.fromJson(json);
  }

  @override
  Future<bool> checkFacebookAccount(
      {String facebookId,
      String facebookName,
      String facebookAvatar,
      String token}) async {
    final data = {
      "FacebookId": facebookId,
      "FacebookName": facebookName,
      "FacebookAvatar": facebookAvatar,
      "Token": token,
    };
    final json = await _apiClient.httpPost('/api/facebook/verify', data: data);
    return json['IsAddRequired'];
  }

  @override
  Future<CRMTeam> insert(CRMTeam data) async {
    final json =
        await _apiClient.httpPost('/odata/CRMTeam', data: data.toJson(true));

    return CRMTeam.fromJson(json);
  }

  @override
  Future<void> patch(CRMTeam crmTeam) async {
    assert(crmTeam.id != null);
    await _apiClient.httpPatch("/odata/CRMTeam(${crmTeam.id})",
        data: crmTeam.toJson(true));
  }

  @override
  Future<void> deleteCRMTeam(int id) async {
    assert(id != null);
    await _apiClient.httpDelete('/odata/CRMTeam($id)');
  }

  @override
  Future<OdataListResult<CRMTeam>> getAllChannel() async {
    final json = await _apiClient.httpGet('/odata/CRMTeam');
    return OdataListResult.fromJson(json);
  }
}
