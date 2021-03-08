import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstraction.dart';
import 'package:tpos_api_client/src/model.dart';
import 'package:tpos_api_client/src/service/tpos_api_cache_service.dart';

class CommonApiImpl implements CommonApi {
  CommonApiImpl(
      {TPosApiClient apiClient, TPosApiCacheService tPosApiCacheService}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
    _apiCache = tPosApiCacheService ?? GetIt.instance<TPosApiCacheService>();
  }

  static const getUserConfigPath = '/api/common/userconfigs';
  static const getPartnerStatusPath = '/api/common/getpartnerstatus';
  static const getPartnerStatusReportPath =
      '/api/common/getpartnerstatusreport';
  static const getUploadImagePath = '/api/common/uploadimage';
  // PATH lấy danh sách trạng thái khách hàng kèm màu theo dạng Map.
  static const getPartnerStatusMapPath = "/api/common/getpartnerstatusdicts";
  TPosApiClient _apiClient;
  TPosApiCacheService _apiCache;

  @override
  Future<GetCompanyCurrentResult> getCompanyCurrent() async {
    final json = await _apiClient.httpGet('/api/common/getcompanycurrent');
    return GetCompanyCurrentResult.fromJson(json);
  }

  @override
  Future<WebUserConfig> getUserConfig() async {
    final json = await _apiClient.httpGet(getUserConfigPath);
    if (json is String) {
      throw Exception('Dữ liệu trả về không hợp lệ');
    }
    return WebUserConfig.fromJson(json);
  }

  @override
  Future<List<PartnerStatus>> getPartnerStatus({bool fromCache = false}) async {
    if (fromCache) {
      return await _apiCache.cachePartnerStatus.fetch(() async {
        try {
          return await _getPartnerStatus();
        } catch (e) {
          _apiCache.cachePartnerStatus?.invalidate();
          rethrow;
        }
      });
    } else {
      return await _getPartnerStatus();
    }
  }

  Future<List<PartnerStatus>> _getPartnerStatus() async {
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
    return await _apiClient.httpPost(getUploadImagePath,
        data: <String, dynamic>{'Base64': base64, 'Name': name});
  }

  Future<Map<String, dynamic>> getPartnerStatusMap({bool cache = false}) async {
    if (cache) {
      try {
        return await _apiCache.partnerStatusMapCache.fetch(() async {
          return await _apiClient.httpGet(getPartnerStatusMapPath);
        });
      } catch (e) {
        rethrow;
      }
    } else {
      return await _apiClient.httpGet(getPartnerStatusMapPath);
    }
  }
}
