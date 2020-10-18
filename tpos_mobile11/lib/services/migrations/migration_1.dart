import 'package:get_it/get_it.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';
import 'package:tpos_mobile/services/migrations/migration_base.dart';

class Migration1 implements MigrationBase {
  @override
  String endVersion = '';

  @override
  String startVersion = '1.5.0';

  @override
  Future up() async {
    final configService = GetIt.I<ConfigService>();
    final secureConfigService = GetIt.I<SecureConfigService>();
  }
}
