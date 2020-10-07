import 'package:tpos_api_client/src/models/entities/sale_online_facebook_post_config.dart';

abstract class SaleOnlineFacebookPostApi {
  /// Post /odata/SaleOnline_Facebook_Post/ODataService.UpdateConfigs
  Future<SaleOnlineFacebookPostConfig> updateConfig(
      SaleOnlineFacebookPostConfig config);
}
