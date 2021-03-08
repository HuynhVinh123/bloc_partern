import 'package:hive/hive.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';

class SecureStorageService implements SecureConfigService {
  SecureStorageService() {
    init();
  }
  String _shopToken;
  String _refreshToken;
  String _shopUsername;
  String _shopUrl;
  Box _box;
  int _loginCount;

  /// Whether the secure storage service is initialized.
  bool _isInitialized = false;

  /// Must init first on app start.
  Future<void> init() async {
    if (_isInitialized) {
      return;
    }
    _box = await Hive.openBox(
      "secureStorage",
    );
    _isInitialized = true;
  }

  @override
  Future<void> setShopToken(String value) async {
    await _box.put('shopToken', value);
  }

  @override
  String get shopToken => _shopToken ?? _box.get('shopToken');

  @override
  String get refreshToken => _refreshToken ?? _box.get('refreshToken');

  @override
  Future<void> setRefreshToken(String value) async {
    await _box.put('refreshToken', value);
  }

  String get shopUsername => _shopUsername ??= _box.get('shopUsername');
  String get shopUrl => _shopUrl ??=
      _box.get('shopUrl', defaultValue: 'https://yourShop.tpos.vn');
  int get loginCount => _loginCount ??= _box.get('loginCount', defaultValue: 0);

  void setShopUsername(String value) {
    _shopUsername = value;
    _box.put('shopUsername', value);
  }

  void setShopUrl(String value) {
    _shopUrl = value;
    _box.put('shopUrl', value);
  }

  void setLoginCount(int value) {
    _loginCount = value;
    _box.put('loginCount', value);
  }
}
