import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstraction.dart';
import 'package:tpos_api_client/src/model.dart';
import 'package:tpos_api_client/src/models/entities/company.dart';

class CommonApiImpl implements CommonApi {
  static const getUserConfigPath = '/api/common/userconfigs';
  static const getPartnerStatusPath = '/api/common/getpartnerstatus';
  static const getPartnerStatusReportPath =
      '/api/common/getpartnerstatusreport';
  TPosApiClient _apiClient;

  CommonApiImpl({TPosApiClient apiClient}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
  }
  @override
  Future<GetCompanyCurrentResult> getCompanyCurrent() async {
    final json = await _apiClient.httpGet('/api/common/getcompanycurrent');
    return GetCompanyCurrentResult.fromJson(json);
  }

  @override
  Future<WebUserConfig> getUserConfig() async {
    final json = await _apiClient.httpGet(getUserConfigPath);
    return WebUserConfig.fromJson(json);
  }

  @override
  Future<List<PartnerStatus>> getPartnerStatus() async {
    final json = await _apiClient.httpGet(getPartnerStatusPath);
    return (json as List).map((e) => PartnerStatus.fromJson(e)).toList();
  }

  @override
  Future<PartnerStatusReport> getPartnerStatusReport() async {
    final json = await _apiClient.httpGet(getPartnerStatusReportPath);
    return PartnerStatusReport.fromJson(json);
  }
}
