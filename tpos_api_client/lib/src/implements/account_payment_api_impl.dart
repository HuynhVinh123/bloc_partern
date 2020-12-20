import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstractions/account_payment_api.dart';
import 'package:tpos_api_client/src/models/entities/account_payment.dart';
import 'package:tpos_api_client/src/models/entities/partner_contact.dart';

import '../../tpos_api_client.dart';

class AccountPaymentApiImpl implements AccountPaymentApi {
  AccountPaymentApiImpl({TPosApiClient apiClient}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
  }

  TPosApiClient _apiClient;

  @override
  Future<AccountPaymentBaseModel> getAccountPayments(
      {String keySearch = "",
      List<String> filterStatus,
      String fromDate,
      String toDate,
      int accountId,
      int take,
      int skip}) async {
    List<AccountPayment> accountPayments = [];

    const String path = "/odata/AccountPayment";

    final Map<String, dynamic> body = {
      "\$format": "json",
      "\$top": take,
      "\$skip": skip,
      "\$orderby": "PaymentDate desc,Name desc",
      "\$count": "true",
    };

    if (filterStatus.isEmpty &&
        (keySearch == "" || keySearch == null) &&
        (fromDate == "" && toDate == "") &&
        accountId == null) {
    } else {
      body["\$filter"] =
          "(${keySearch != null && keySearch != "" ? "(contains(SenderReceiver,'$keySearch') or contains(Name,'$keySearch') or contains(AccountName,'$keySearch') or contains(Communication,'$keySearch')) and " : ""}(AccountId ne null and PaymentType eq 'inbound' ${accountId != null ? "and AccountId eq $accountId" : ""}) ${fromDate != "" && toDate != "" ? "and (PaymentDate ge $fromDate and PaymentDate le $toDate)" : ""})";

      if (filterStatus.isNotEmpty) {
        if (filterStatus.length == 1) {
          body["\$filter"] =
              "(${keySearch != null && keySearch != "" ? "(contains(SenderReceiver,'$keySearch') or contains(Name,'$keySearch') or contains(AccountName,'$keySearch') or contains(Communication,'$keySearch')) and" : ""}(AccountId ne null and PaymentType eq 'inbound' ${accountId != null ? "and AccountId eq $accountId" : ""}) and (State eq '${filterStatus[0]}') ${fromDate != "" && toDate != "" ? "and (PaymentDate ge $fromDate and PaymentDate le $toDate)" : ""})";
        } else {
          body["\$filter"] =
              "(${keySearch != null && keySearch != "" ? "(contains(SenderReceiver,'$keySearch') or contains(Name,'$keySearch') or contains(AccountName,'$keySearch') or contains(Communication,'$keySearch')) and" : ""}(AccountId ne null and PaymentType eq 'inbound' ${accountId != null ? "and AccountId eq $accountId" : ""}) and (State eq '${filterStatus[0]}' or State eq '${filterStatus[1]}') ${fromDate != "" && toDate != "" ? "and (PaymentDate ge $fromDate and PaymentDate le $toDate)" : ""})";
        }
      }
    }

    final response = await _apiClient.httpGet(path, parameters: body);
    accountPayments = (response['value'] as List)
        .map((value) => AccountPayment.fromJson(value))
        .toList();
    final AccountPaymentBaseModel baseModel = AccountPaymentBaseModel(
        result: accountPayments, totalItems: response['@odata.count']);
    return baseModel;
  }

  @override
  Future<void> deleteAccountPayment(int id) async {
    await _apiClient.httpDelete("/odata/AccountPayment($id)");
  }

  @override
  Future<AccountPayment> getInfoAccountPayment(int id) async {
    final response = await _apiClient.httpGet(
        "/odata/AccountPayment($id)?\$expand=Partner,Journal,Account,Currency,Contact");

    return AccountPayment.fromJson(response);
  }

  @override
  Future<void> confirmAccountPayment(int id) async {
    final String body = "{\"id\":$id}";
    await _apiClient.httpPost("/odata/AccountPayment/ODataService.ActionPost",
        data: body);
  }

  @override
  Future<void> cancelAccountPayment(int id) async {
    final String body = "{\"id\":$id}";
    await _apiClient.httpPost("/odata/AccountPayment/ODataService.ActionCancel",
        data: body);
  }

  @override
  Future<List<AccountJournal>> getAccountJournalWithAccountPayments() async {
    List<AccountJournal> accountJournals = [];
    const String path =
        "/odata/AccountJournal/ODataService.GetWithCompany?%24format=json&%24filter=(Type+eq+%27bank%27+or+Type+eq+%27cash%27)&%24count=true";

    final response = await _apiClient.httpGet(path);
    accountJournals = (response["value"] as List)
        .map((value) => AccountJournal.fromJson(value))
        .toList();
    return accountJournals;
  }

  @override
  Future<AccountPayment> getDefaultAccountPayment() async {
    const String body = "{\"model\":{\"PaymentType\":\"inbound\"}}";

    final response = await _apiClient.httpPost(
        "/odata/AccountPayment/ODataService.DefaultGetCreate?\$expand=Currency,Journal",
        data: body);
    return AccountPayment.fromJson(response);
  }

  @override
  Future<void> updateAccountPayment(AccountPayment accountPayment) async {
    final String body = json.encode(accountPayment.toJson());
    await _apiClient.httpPut("/odata/AccountPayment(${accountPayment.id})",
        data: body);
  }

  @override
  Future<AccountPayment> addAccountPayment(
      AccountPayment accountPayment) async {
    final String body = json.encode(accountPayment.toJson());
    final response =
        await _apiClient.httpPost("/odata/AccountPayment", data: body);
    return AccountPayment.fromJson(response);
  }

  @override
  Future<AccountPaymentBaseModel> getAccountPaymentSales(
      {String keySearch,
      List<String> filterStatus,
      String fromDate,
      String toDate,
      int accountId,
      int take,
      int skip}) async {
    List<AccountPayment> accountPayments = [];
    const String path = "/odata/AccountPayment/ODataService.GetChi";

    final Map<String, dynamic> body = {
      "\$format": "json",
      "\$top": take,
      "\$skip": skip,
      "\$orderby": "PaymentDate desc,Name desc",
      "\$count": "true",
    };

    if (filterStatus.isEmpty &&
        (keySearch == "" || keySearch == null) &&
        (fromDate == "" && toDate == "") &&
        accountId == null) {
    } else {
      body["\$filter"] =
          "(${keySearch != null && keySearch != "" ? "(contains(SenderReceiver,'$keySearch') or contains(Name,'$keySearch') or contains(AccountName,'$keySearch') or contains(Communication,'$keySearch')) and " : ""}(AccountId ne null and PaymentType eq 'outbound' ${accountId != null ? "and AccountId eq $accountId" : ""}) ${fromDate != "" && toDate != "" ? "and (PaymentDate ge $fromDate and PaymentDate le $toDate)" : ""})";

      if (filterStatus.isNotEmpty) {
        if (filterStatus.length == 1) {
          body["\$filter"] =
              "(${keySearch != null && keySearch != "" ? "(contains(SenderReceiver,'$keySearch') or contains(Name,'$keySearch') or contains(AccountName,'$keySearch') or contains(Communication,'$keySearch')) and" : ""}(AccountId ne null and PaymentType eq 'outbound' ${accountId != null ? "and AccountId eq $accountId" : ""}) and (State eq '${filterStatus[0]}') ${fromDate != "" && toDate != "" ? "and (PaymentDate ge $fromDate and PaymentDate le $toDate)" : ""})";
        } else {
          body["\$filter"] =
              "(${keySearch != null && keySearch != "" ? "(contains(SenderReceiver,'$keySearch') or contains(Name,'$keySearch') or contains(AccountName,'$keySearch') or contains(Communication,'$keySearch')) and" : ""}(AccountId ne null and PaymentType eq 'outbound' ${accountId != null ? "and AccountId eq $accountId" : ""}) and (State eq '${filterStatus[0]}' or State eq '${filterStatus[1]}') ${fromDate != "" && toDate != "" ? "and (PaymentDate ge $fromDate and PaymentDate le $toDate)" : ""})";
        }
      }
    }
    final response = await _apiClient.httpGet(path, parameters: body);
    accountPayments = (response['value'] as List)
        .map((value) => AccountPayment.fromJson(value))
        .toList();
    final AccountPaymentBaseModel baseModel = AccountPaymentBaseModel(
        result: accountPayments, totalItems: response['@odata.count']);
    return baseModel;
  }

  @override
  Future<AccountPayment> getDefaultAccountPaymentSale() async {
    const String body = "{\"model\":{\"PaymentType\":\"outbound\"}}";

    final response = await _apiClient.httpPost(
        "/odata/AccountPayment/ODataService.DefaultGetCreate?\$expand=Currency,Journal",
        data: body);
    return AccountPayment.fromJson(response);
  }

  @override
  Future<List<Account>> getAccounts({String keySearch}) async {
    List<Account> accounts = [];
    String path =
        "/odata/Account?\$filter=InternalType%20eq%20%27thu%27&\$orderby=Name&%24format=json&%24count=true";

    if (keySearch != null && keySearch != "") {
      path =
          "/odata/Account?\$filter=InternalType%20eq%20%27thu%27&\$orderby=Name&%24format=json&%24filter=contains(tolower(Name)%2C%27$keySearch%27)&%24count=true";
    }

    final response = await _apiClient.httpGet(path);
    accounts = (response["value"] as List)
        .map((value) => Account.fromJson(value))
        .toList();
    return accounts;
  }

  @override
  Future<List<Account>> getAccountSales({String keySearch}) async {
    List<Account> accounts = [];
    String path =
        "/odata/Account?\$filter=InternalType%20eq%20%27chi%27%20and%20Code%20ne%20%27CHANGE%27&\$orderby=Name&%24format=json&%24count=true";

    if (keySearch != null && keySearch != "") {
      path =
          "/odata/Account?\$filter=InternalType%20eq%20%27chi%27%20and%20Code%20ne%20%27CHANGE%27&\$orderby=Name&%24format=json&%24filter=contains(tolower(Name)%2C%27$keySearch%27)&%24count=true";
    }

    final response = await _apiClient.httpGet(path);
    accounts = (response["value"] as List)
        .map((value) => Account.fromJson(value))
        .toList();
    return accounts;
  }

  @override
  Future<List<Account>> getTypeAccounts({String keySearch}) async {
    List<Account> accounts = [];
    String path =
        "/odata/Account/ODataService.GetWithCompany?%24format=json&%24top=10&%24filter=InternalType+eq+%27thu%27&%24count=true";

    if (keySearch != null && keySearch != "") {
      path =
          "/odata/Account/ODataService.GetWithCompany?%24format=json&%24top=10&%24filter=(contains(tolower(NameGet)%2C%27$keySearch%27)+and+InternalType+eq+%27thu%27)&%24count=true";
    }

    final response = await _apiClient.httpGet(path);
    accounts = (response["value"] as List)
        .map((value) => Account.fromJson(value))
        .toList();
    return accounts;
  }

  @override
  Future<List<Account>> getTypeAccountSales({String keySearch}) async {
    List<Account> accounts = [];
    String path =
        "/odata/Account/ODataService.GetWithCompany?%24format=json&%24top=10&%24filter=InternalType+eq+%27chi%27&%24count=true";

    if (keySearch != null && keySearch != "") {
      path =
          "/odata/Account/ODataService.GetWithCompany?%24format=json&%24top=10&%24filter=(contains(tolower(NameGet)%2C%27$keySearch%27)+and+InternalType+eq+%27chi%27)&%24count=true";
    }

    final response = await _apiClient.httpGet(path);
    accounts = (response["value"] as List)
        .map((value) => Account.fromJson(value))
        .toList();
    return accounts;
  }

  @override
  Future<List<Partner>> getContactPartners(String keySearch) async {
    List<Partner> partners = [];
    String path =
        "/odata/Partner/ODataService.GetContact?%24format=json&%24count=true";

    if (keySearch != null && keySearch != "") {
      path =
          "/odata/Partner/ODataService.GetContact?%24format=json&%24filter=(contains(NameNoSign%2C%27$keySearch%27)+or+contains(DisplayName%2C%27$keySearch%27)+or+contains(Phone%2C%27$keySearch%27))&%24count=true";
    }

    final response = await _apiClient.httpGet(path);
    partners = (response["value"] as List)
        .map((value) => Partner.fromJson(value))
        .toList();
    return partners;
  }

  @override
  Future<PartnerContact> getContactDefault() async {
    final response = await _apiClient.httpPost(
        "/odata/Partner/ODataService.DefaultGet?\$expand=AccountPayable,AccountReceivable,StockCustomer,StockSupplier");
    return PartnerContact.fromJson(response);
  }

  @override
  Future<PartnerContact> addContactPartner(PartnerContact partner) async {
    final String body = json.encode(partner.toJson());
    final response = await _apiClient.httpPost("/odata/Partner", data: body);
    return PartnerContact.fromJson(response);
  }
}
