import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstraction.dart';
import 'package:tpos_api_client/src/abstractions/application_user_api.dart';
import 'package:tpos_api_client/src/models/entities/application_user.dart';
import 'package:tpos_api_client/src/models/results/change_current_company_get_result.dart';

class ApplicationUserApiImpl implements ApplicationUserApi {
  ApplicationUserApiImpl({TPosApi apiClient}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
  }
  static const String changeCurrentCompanyGetPath =
      '/odata/ApplicationUser/OdataService.ChangeCurrentCompanyGet';
  static const String getCurrentUserInfoPath = '/rest/v1.0/user/info';
  static const String switchCompanyPath =
      '/odata/ApplicationUser/ODataService.SwitchCompany';
  TPosApi _apiClient;

  @override
  Future<ChangeCurrentCompanyGetResult> changeCurrentCompanyGet() async {
    final result = await _apiClient.httpGet(changeCurrentCompanyGetPath);
    return ChangeCurrentCompanyGetResult.fromJson(result);
  }

  @override
  Future<ApplicationUser> getCurrentUser() async {
    final result = await _apiClient.httpGet(getCurrentUserInfoPath);
    return ApplicationUser.fromJson(result);
  }

  @override
  Future<void> switchCompany(int companyId) async {
    await _apiClient.httpPost(switchCompanyPath, data: {
      'companyId': companyId,
    });
  }
}
