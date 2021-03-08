import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/src/abstraction.dart';
import 'package:tpos_api_client/src/abstractions/sale_online_facebook_post_api.dart';
import 'package:tpos_api_client/src/models/entities/sale_online_facebook_post_config.dart';

class SaleOnlineFacebookPostApiImpl implements SaleOnlineFacebookPostApi {
  SaleOnlineFacebookPostApiImpl({TPosApi tPosApi}) {
    _tPosApi = tPosApi ?? GetIt.instance<TPosApi>();
  }
  static const _updateConfigPath =
      '/odata/SaleOnlineFacebookPost/ODataService.UpdateConfigs';
  TPosApi _tPosApi;
  @override
  Future<SaleOnlineFacebookPostConfig> updateConfig(
      SaleOnlineFacebookPostConfig config) async {
    final result =
        await _tPosApi.httpPost(_updateConfigPath, data: config.toJson());
    return SaleOnlineFacebookPostConfig.fromJson(result);
  }
}
