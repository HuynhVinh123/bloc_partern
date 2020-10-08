import 'dart:convert';

import 'package:tpos_api_client/tpos_api_client.dart';

import 'package:tpos_mobile/src/tpos_apis/models/company_config.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_service_base.dart';

abstract class ICompanyApi {
  Future<Company> getById(int companyId);
  Future<void> update(Company company);
  Future<void> insert(Company company);
  Future<CompanyConfig> getCompanyConfig();

  /// Lưu cấu hình công ty
  Future<CompanyConfig> saveCompanyConfig(CompanyConfig config);
}

class CompanyService extends ApiServiceBase implements ICompanyApi {
  CompanyService({TposApiClient apiClient}) : super(apiClient: apiClient);
  @override
  Future<Company> getById(int companyId) async {
    var response = await apiClient.httpGet(path: "/odata/Company($companyId)");
    if (response.statusCode == 200)
      return Company.fromJson(jsonDecode(response.body));
    throwTposApiException(response);
    return null;
  }

  @override
  Future<void> update(Company company) async {
    assert(company != null && company.id != null && company.id != 0);
    var response = await apiClient.httpPut(
        path: "/odata/Company(${company.id})",
        body: jsonEncode(company.toJson()));
    if (response.statusCode != 204) throwTposApiException(response);
    return null;
  }

  @override
  Future<void> insert(Company company) async {
    assert(company != null);
    var response = await apiClient.httpPost(
      path: "/odata/Company",
      body: jsonEncode(
        company.toJson(),
      ),
    );
    if (response.statusCode != 201) throwTposApiException(response);
    return null;
  }

  @override
  Future<CompanyConfig> getCompanyConfig() async {
    var response = await apiClient.httpGet(
        path: "/odata/Company_Config/OdataService.GetConfigs");

    if (response.statusCode == 200) {
      return CompanyConfig.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("${response.statusCode}, ${response.reasonPhrase}");
    }
  }

  @override
  Future<CompanyConfig> saveCompanyConfig(CompanyConfig config) async {
    var bodyMap = config.toJson();
    String body = jsonEncode(bodyMap);
    var response =
        await apiClient.httpPost(path: "/odata/Company_Config", body: body);

    if (response.statusCode == 200) {
      return CompanyConfig.fromJson(jsonDecode(response.body));
    } else {
      throwTposApiException(response);
      return null;
    }
  }
}
