import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstractions/pos_session_api.dart';
import 'package:tpos_api_client/src/models/entities/pos_session/pos_account_bank.dart';
import 'package:tpos_api_client/src/models/entities/pos_session/pos_accoutn_bank_line.dart';
import 'package:tpos_api_client/src/models/entities/pos_session/pos_session.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

class PosSessionApiImpl implements PosSessionApi {
  PosSessionApiImpl({TPosApiClient apiClient}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
  }
  TPosApi _apiClient;

  @override
  Future<List<PosSession>> getPosSession({int page, int skip, int take}) async {
    List<PosSession> posSessions = <PosSession>[];
    final Map<String, dynamic> mapBody = {
      "page": page,
      "pageSize": take,
      "skip": skip,
      "take": take
    };
    final String body = json.encode(mapBody);
    final response = await _apiClient.httpPost("/POS_Session/List", data: body);
    posSessions = (response["Data"] as List)
        .map((pos) => PosSession.fromJson(pos))
        .toList();
    return posSessions;
  }

  @override
  Future<PosSession> getPosSessionById({int id}) async {
    var response = await _apiClient
        .httpGet("/odata/POS_Session($id)?\$expand=User,Config");
    return PosSession.fromJson(response);
  }

  @override
  Future<List<PosAccountBank>> getAccountBankStatement({int id}) async {
    List<PosAccountBank> _posAccountBanks = [];
    var response = await _apiClient.httpGet(
        "/odata/AccountBankStatement?\$expand=Journal&\$filter=PosSessionId+eq+$id");

    _posAccountBanks = (response["value"] as List)
        .map((e) => PosAccountBank.fromJson(e))
        .toList();

    return _posAccountBanks;
  }

  @override
  Future<List<PosAccountBankLine>> getAccountBankStatementLine({int id}) async {
    List<PosAccountBankLine> _posAccountBankLines = [];
    var response = await _apiClient
        .httpGet("/odata/AccountBankStatementLine?\$filter=StatementId+eq+$id");
    _posAccountBankLines = (response["value"] as List)
        .map((e) => PosAccountBankLine.fromJson(e))
        .toList();

    return _posAccountBankLines;
  }

  @override
  Future<PosAccountBank> getAccountBankStatementDetail({int id}) async {
    var response = await _apiClient
        .httpGet("/odata/AccountBankStatement($id)?\$expand=Journal");
    return PosAccountBank.fromJson(response);
  }

  @override
  Future<void> updatePosSession({PosSession posSession}) async {
    var data = posSession.toJson();

    await _apiClient.httpPut("/odata/POS_Session(${posSession.id})",
        data: data);
  }

  @override
  Future<void> deletePosSession({int id}) async {
    await _apiClient.httpDelete("/odata/POS_Session($id)");
  }

  @override
  Future<void> closeSession({int id}) async {
    final String body = json.encode({"id": id});
    await _apiClient.httpPost(
        "/odata/POS_Session/ODataService.ActionPosSessionClosingControl",
        data: body);
  }
}
