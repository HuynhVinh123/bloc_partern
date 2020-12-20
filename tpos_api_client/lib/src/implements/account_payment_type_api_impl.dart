import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstractions/account_payment_type_api.dart';
import 'package:tpos_api_client/src/models/entities/account_payment_type_base/account_result.dart';

import '../../tpos_api_client.dart';

class AccountPaymentTypeApiImpl implements AccountPaymentTypeApi {
  AccountPaymentTypeApiImpl({TPosApiClient apiClient}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
  }

  TPosApiClient _apiClient;

  @override
  Future<AccountResult> getTypeAccountAccounts(
      {int page, int pageSize, int skip, int take, int companyId}) async {
    List<Account> accounts = [];
    const String path = "/AccountAccount/List";
    final Map<String, dynamic> body = {
      "take": take,
      "skip": skip,
      "page": page,
      "pageSize": pageSize,
      "filter": {
        "logic": "and",
        "filters": [
          {"field": "InternalType", "operator": "eq", "value": "thu"}
        ]
      }
    };

    if (companyId != null) {
      body["filter"]["filters"] = [
        {"field": "InternalType", "operator": "eq", "value": "thu"},
        {"field": "CompanyId", "operator": "eq", "value": companyId}
      ];
    }

    final response = await _apiClient.httpPost(path, data: json.encode(body));
    accounts = (response["Data"] as List)
        .map((value) => Account.fromJson(value))
        .toList();
    final AccountResult accountResult =
        AccountResult(result: accounts, totalItems: response["Total"]);
    return accountResult;

    // if (response.statusCode == 200) {
    //   final map = json.decode(response.body);
    //   if (response.body != "") {
    //     accounts = (map["Data"] as List)
    //         .map((value) => Account.fromJson(value))
    //         .toList();
    //   }
    //   final AccountResult accountResult =
    //   AccountResult(result: accounts, totalItems: map["Total"]);
    //   return accountResult;
    // }
    // throwHttpException(response);
    // return null;
  }

  @override
  Future<bool> deleteTypeAccountAccountSale(int id) async {
    await _apiClient.httpDelete("/odata/Account($id)");
    return true;
  }

  @override
  Future<AccountResult> getTypeAccountAccountSales(
      {int page, int pageSize, int skip, int take, int companyId}) async {
    List<Account> accounts = [];
    const String path = "/AccountAccount/List";
    final Map<String, dynamic> body = {
      "take": take,
      "skip": skip,
      "page": page,
      "pageSize": pageSize,
      "filter": {
        "logic": "and",
        "filters": [
          {"field": "InternalType", "operator": "eq", "value": "chi"}
        ]
      }
    };

    if (companyId != null) {
      body["filter"]["filters"] = [
        {"field": "InternalType", "operator": "eq", "value": "chi"},
        {"field": "CompanyId", "operator": "eq", "value": companyId}
      ];
    }

    final response = await _apiClient.httpPost(path, data: json.encode(body));

    accounts = (response["Data"] as List)
        .map((value) => Account.fromJson(value))
        .toList();

    final AccountResult accountResult =
        AccountResult(result: accounts, totalItems: response["Total"]);

    return accountResult;

    // if (response.statusCode == 200) {
    //   final map = json.decode(response.body);
    //   if (response.body != "") {
    //     accounts = (map["Data"] as List)
    //         .map((value) => Account.fromJson(value))
    //         .toList();
    //   }
    //
    // }
    // throwHttpException(response);
    // return null;
  }

  @override
  Future<Account> getDetailAccountSale(int id) async {
    final response = await _apiClient
        .httpGet("/odata/Account($id)?\$expand=Company,UserType");
    return Account.fromJson(response);
    // if (response.statusCode == 200) {
    //   final map = json.decode(response.body);
    //   return Account.fromJson(map);
    // }
    // throwHttpException(response);
    // return null;
  }

  @override
  Future<bool> updateInfoTypeAccountSale(Account account) async {
    final String body = json.encode(account.toJson());
    await _apiClient.httpPut("/odata/Account(${account.id})", data: body);
    return true;
  }

  @override
  Future<Account> getDefaultAccountSale() async {
    final response = await _apiClient.httpGet(
        "/odata/Account/ODataService.DefaultGetThuChi?\$expand=Company&type=chi");
    return Account.fromJson(response);
  }

  @override
  Future<Account> addInfoTypeAccountSale(Account account) async {
    final String body = json.encode(account.toJson());
    final response = await _apiClient.httpPost("/odata/Account", data: body);
    final Account _account = Account.fromJson(response);
    return _account;
    // if (response.statusCode == 201) {
    //   final map = json.decode(response.body);
    //   final Account account = Account.fromJson(map);
    //   return account;
    // }
    // throwHttpException(response);
    // return null;
  }

  @override
  Future<Account> getDefaultAccount() async {
    final response = await _apiClient.httpGet(
        "/odata/Account/ODataService.DefaultGetThuChi?\$expand=Company&type=thu");
    return Account.fromJson(response);
  }

  @override
  Future<List<Company>> getCompanies(String keySearch) async {
    List<Company> companies = [];
    String path = "/odata/Company?%24format=json&%24count=true";

    if (keySearch != null && keySearch != "") {
      path =
          "/odata/Company?%24format=json&%24filter=contains(tolower(Name)%2C%27$keySearch%27)&%24count=true";
    }

    final response = await _apiClient.httpGet(path);

    companies = (response["value"] as List)
        .map((value) => Company.fromJson(value))
        .toList();
    return companies;
    // if (response.statusCode == 200) {
    //   if (response.body != "") {
    //     final map = json.decode(response.body);
    //     companies = (map["value"] as List)
    //         .map((value) => Company.fromJson(value))
    //         .toList();
    //   }
    //   return companies;
    // }
    // throwHttpException(response);
    // return null;
  }
}
