import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/locator_2.dart';
import 'package:tpos_mobile/services/cache_service/cache_service.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';
import 'package:tpos_mobile/services/dialog_service/new_dialog_service.dart';
import 'package:tpos_mobile/services/remote_config_service.dart';

void main() {
  test('Các dịch vụ phải khả dụng khi gọi setUpNewLocator()', () {
    setupNewLocator();

    assert(GetIt.I<ConfigService>() != null);
    assert(GetIt.I<RemoteConfigService>() != null);
    assert(GetIt.I<SecureConfigService>() != null);
    assert(GetIt.I<CacheService>() != null);
    assert(GetIt.I<NewDialogService>() != null);

    assert(GetIt.I<TPosApi>() != null);

    // ConfigService phải được khởi tạo sau kh
    // RemoteConfig phải được khởi tạo
  });
}
