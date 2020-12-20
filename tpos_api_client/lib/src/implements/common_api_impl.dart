import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstraction.dart';
import 'package:tpos_api_client/src/model.dart';

class CommonApiImpl implements CommonApi {
  CommonApiImpl({TPosApiClient apiClient}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
  }

  static const getUserConfigPath = '/api/common/userconfigs';
  static const getPartnerStatusPath = '/api/common/getpartnerstatus';
  static const getPartnerStatusReportPath = '/api/common/getpartnerstatusreport';
  static const getUploadImagePath = '/api/common/uploadimage';
  TPosApiClient _apiClient;

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

  @override
  Future<String> uploadImage(String base64, String name) async {
    return await _apiClient.httpPost(getUploadImagePath, data: <String, dynamic>{'Base64': base64, 'Name': name});
  }
}
