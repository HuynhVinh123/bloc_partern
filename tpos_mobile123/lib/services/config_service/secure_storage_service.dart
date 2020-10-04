import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';

class SecureStorageService implements SecureConfigService {
  String _shopToken;
  String _refreshToken;
  final storage = FlutterSecureStorage();
  @override
  Future<void> setShopToken(String value) async {
    await storage.write(key: 'shopToken', value: value);
  }

  @override
  Future<String> get shopToken async =>
      _shopToken ?? await storage.read(key: 'shopToken');

  @override
  Future<String> get refreshToken async =>
      _refreshToken ?? await storage.read(key: 'refreshToken');

  @override
  Future<void> setRefreshToken(String value) async {
    await storage.write(key: 'refreshToken', value: value);
  }
}
