import 'package:logger/logger.dart';
import 'package:tpos_mobile/services/migrations/migration_180.dart';

abstract class MigrationBase {
  final Logger _logger = Logger();
  Future<void> up();
  Future<bool> get condition;
  Future<void> runUpgrade() async {
    if (await condition) {
      await up();
    }
  }
}

class MigrationManager {
  final Logger _logger = Logger();
  List<MigrationBase> shopMigrations = [
    Migration180(),
  ];

  List<MigrationBase> appMigrations = [
    Migration180App(),
  ];

  Future<void> startAppMigration() async {
    for (final itm in appMigrations) {
      try {
        await itm.runUpgrade();
      } catch (e, s) {
        _logger.e('', e, s);
        break;
      }
    }
  }

  Future<void> startMigration() async {
    for (final itm in shopMigrations) {
      try {
        await itm.runUpgrade();
      } catch (e, s) {
        _logger.e('', e, s);
        break;
      }
    }
  }
}
