import 'package:get_it/get_it.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';
import 'package:tpos_api_client/src/models/entities/mobile_config_result.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

class ConfigApiImpl implements MobileConfigApi {
  ConfigApiImpl({TPosApiClient apiClient}) {
    _apiClient = apiClient ?? GetIt.instance<TPosApi>();
  }

  TPosApiClient _apiClient;

  @override
  Future<MobileConfigResult> createUpdate(MobileConfig config) async {
    assert(config.deviceId.isNotNullOrEmpty(), 'DeviceId là bắt buộc');
    assert(config.userId.isNotNullOrEmpty(),
        "Phải có userId để lưu cấu hình cho user này");

    final Map<String, dynamic> response = await _apiClient.httpPost(
      '/api/mobileConfigs/createUpdate',
      data: config?.toJson(true),
    );

    return MobileConfigResult.fromJson(response);
  }

  @override
  Future<List<MobileConfig>> getAllConfigs() async {
    final response = await _apiClient.httpGet('/api/mobileConfigs/getAll');
    List<MobileConfig> configurations = [];
    configurations = response
        .map<MobileConfig>((item) => MobileConfig.fromJson(item))
        .toList();
    return configurations;
  }

  @override
  Future<MobileConfig> getConfigsByDeviceId(
      {String deviceId, String userId, String host}) async {
    final Map<String, dynamic> response = await _apiClient.httpGet(
        '/api/mobileConfigs/getByDeviceId',
        parameters: <String, dynamic>{
          'deviceId': deviceId,
          'userId': userId,
          'host': host
        }..removeWhere((key, value) => value == null));

    return MobileConfig.fromJson(response);
  }

  @override
  Future<Map<String, dynamic>> getAllConfigJson() {
    // TODO: implement getAllConfigJson
    throw UnimplementedError();
  }
}
