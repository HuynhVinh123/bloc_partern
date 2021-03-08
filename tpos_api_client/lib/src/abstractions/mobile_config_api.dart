import 'package:tpos_api_client/src/models/entities/mobile_config_result.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

abstract class MobileConfigApi {
  Future<List<MobileConfig>> getAllConfigs();
  Future<Map<String, dynamic>> getAllConfigJson();

  Future<MobileConfig> getConfigsByDeviceId(
      {String deviceId, String userId, String host});

  Future<MobileConfigResult> createUpdate(MobileConfig configuration);
}
