import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstractions/live_campaign_api.dart';
import 'package:tpos_api_client/src/abstractions/tpos_api_client.dart';
import 'package:tpos_api_client/src/models/entities/live_campaign.dart';

class LiveCampaignApiImpl implements LiveCampaignApi {
  LiveCampaignApiImpl({TPosApi apiClient}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
  }

  TPosApiClient _apiClient;

  @override
  Future<List<LiveCampaign>> getAvaibleLiveCampaigns(
      {String keyWord, int top = 10, int skip = 0}) async {
    final Map<String, dynamic> params = {
      '\$top': top,
      '\$skip': skip,
      '\$orderby': 'DateCreated desc',
      '\$count': true,
    };

    if (keyWord != null && keyWord != '') {
      params['\$filter'] =
          "(contains(Name,\'$keyWord\') or contains(Facebook_UserName,\'$keyWord\') or contains(Facebook_LiveId,\'$keyWord\'))";
    }

    final response = await _apiClient.httpGet(
        '/odata/SaleOnline_LiveCampaign/ODataService.GetAvailables',
        parameters: params);
    return (response["value"] as List)
        .map((status) => LiveCampaign.fromJson(status))
        .toList();
  }

  @override
  Future<List<LiveCampaign>> getLiveCampaigns(
      {String keyWord, int top, int skip}) async {
    final Map<String, dynamic> params = {
      '\$top': top,
      '\$skip': skip,
      '\$orderby': 'DateCreated desc',
      '\$count': true,
    };

    if (keyWord != null && keyWord != '') {
      params['\$filter'] =
          "(contains(Name,\'$keyWord\') or contains(Facebook_UserName,\'$keyWord\') or contains(Facebook_LiveId,\'$keyWord\'))";
    }

    final response = await _apiClient.httpGet("/odata/SaleOnline_LiveCampaign",
        parameters: params);
    return (response["value"] as List)
        .map((status) => LiveCampaign.fromJson(status))
        .toList();
  }

  @override
  Future<String> exportExcelLiveCampaign(
      String campaignId, String campaignName) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCampaign(String id) async {
    await _apiClient.httpDelete('/odata/SaleOnline_LiveCampaign($id)');
  }

  @override
  Future<LiveCampaign> getDetailLiveCampaigns(String liveCampaignId) async {
    final response = await _apiClient.httpGet(
      "/odata/SaleOnline_LiveCampaign($liveCampaignId)",
      parameters: {
        "\$expand": "Details",
      },
    );
    return LiveCampaign.fromJson(response);
  }

  @override
  Future<void> addLiveCampaign({LiveCampaign newLiveCampaign}) async {
    final jsonMap = newLiveCampaign.toJson();
    jsonMap.removeWhere((key, value) {
      return value == null;
    });
    await _apiClient.httpPost(
      "/odata/SaleOnline_LiveCampaign",
      data: jsonEncode(
        jsonMap,
      ),
    );
  }

  @override
  Future<void> editLiveCampaign(LiveCampaign editLiveCampaign) async {
    final jsonMap = editLiveCampaign.toJson();
    await _apiClient.httpPut(
      "/odata/SaleOnline_LiveCampaign(${editLiveCampaign.id})",
      data: jsonEncode(jsonMap),
    );
  }

  @override
  Future<bool> changeLiveCampaignStatus(String liveCampaignId) async {
    final response = await _apiClient
        .httpPost("/SaleOnline_LiveCampaign/Approve?id=$liveCampaignId");

    return response["success"];
  }
}
