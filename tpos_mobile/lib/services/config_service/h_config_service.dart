import 'dart:collection';
import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';
import 'package:tpos_mobile/application/menu_v2/model.dart';
import 'package:tpos_mobile/resources/menus.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';
import 'package:tpos_mobile/services/config_service/h_adapters/h_printer_config.dart';
import 'package:tpos_mobile/services/config_service/h_adapters/h_sale_online_config.dart';
import 'package:tpos_mobile/services/config_service/h_adapters/old_lucky_wheel_game_config.dart';
import 'package:tpos_mobile/services/config_service/shop_config_service.dart';

import 'config_model/home_menu_config.dart';
import 'h_adapters/new_lucky_wheel_game_config.dart';

class HShopConfigService extends ShopConfigService {
  HShopConfigService({SecureConfigService secureConfigService}) {
    _secureConfig = secureConfigService ?? GetIt.I<SecureConfigService>();

    assert(_secureConfig != null, 'SecureConfigService');
    if (_secureConfig == null) {
      throw Exception("can't get SecureConfig");
    }
  }
  SecureConfigService _secureConfig;
  Box hive;
  NewLuckyWheelGameConfig _luckyWheelConfig;
  OldLuckyWheelGameConfig _oldLuckyWheelConfig;
  HSaleOnlineConfig _hSaleOnlineConfig;
  HPrinterConfig _printerConfig;
  HomeMenuV2FavoriteModel _favoriteMenu;
  String _shopUrl;
  String _shopUsername;
  String _companyName;
  String _currencyFormat;
  String _dateTimeFormat;
  String _locale;
  String _homePageStyle;

  /// Lưu danh sách menu người dùng
  List<HomeMenuConfig> _userMenus;

  String get companyName =>
      _companyName ??
      (_companyName = hive.get('companyName', defaultValue: ''));
  @override
  String get currencyFormat =>
      _currencyFormat ??
      (_currencyFormat =
          hive.get('currencyFormat', defaultValue: '###,###,###,###,###'));

  String get dateTimeFormat =>
      _dateTimeFormat ??
      (_dateTimeFormat =
          hive.get('dateTimeFormat', defaultValue: "dd/MM/yyyy HH:mm:ss"));

  @override
  HomeMenuV2FavoriteModel get favoriteMenu {
    if (_favoriteMenu != null) {
      return _favoriteMenu;
    }
    try {
      final hastMap = hive.get(
        '${_secureConfig.shopUsername}_favoriteMenu',
        defaultValue: getFavoriteMenu().toJson(),
      );
      print(hastMap);
      _favoriteMenu = HomeMenuV2FavoriteModel.fromJson(HashMap.from(hastMap));
    } catch (e, s) {
      _favoriteMenu = getFavoriteMenu();
      print(e);
      print(s);
    }

    return _favoriteMenu;
  }

  String get homePageStyle =>
      _homePageStyle ??
      (_homePageStyle = hive.get('homePageStyle', defaultValue: "style1"));

  String get locale => _locale ??= hive.get('locale', defaultValue: 'vi_VN');

  /// Cấu hình game 'New Lucky wheel'. Chỉ gọi sau khi hàm init được khởi tạo.
  NewLuckyWheelGameConfig get luckyWheelConfig =>
      _luckyWheelConfig ?? (_luckyWheelConfig = NewLuckyWheelGameConfig(hive));

  /// Cấu hình game 'Old Lucky wheel". Chỉ gọi sau khi hàm init được khởi tạo.
  OldLuckyWheelGameConfig get oldLuckyWheelConfig =>
      _oldLuckyWheelConfig ??
      (_oldLuckyWheelConfig = OldLuckyWheelGameConfig(hive));

  HPrinterConfig get printerConfig => _printerConfig ??= HPrinterConfig(hive);

  HSaleOnlineConfig get saleFacebookConfig =>
      _hSaleOnlineConfig ??= HSaleOnlineConfig(hive);

  String get shopUrl => _shopUrl ??= hive.get('shopUrl');

  String get shopUsername => _shopUsername ?? hive.get('shopUsername');

  List<HomeMenuConfig> get userMenus {
    if (_userMenus != null) {
      return _userMenus;
    }

    final String json = hive.get('userMenus');
    final userMenusStringList = json == null ? null : jsonDecode(json)["items"];
    if (userMenusStringList != null) {
      _userMenus = userMenusStringList.map((e) {
        return HomeMenuConfig.fromJson(e);
      }).toList();
    } else {
      _userMenus = <HomeMenuConfig>[];
    }
    return _userMenus;
  }

  @override
  void fromJson(Map<String, dynamic> json) {
    setShopUrl(json['shopUrl']);
    setShopUsername(json['shopUsername']);
    setCompanyName(json['companyName']);

    setCurrencyFormat(json['currencyFormat']);
    setDateTimeFormat(json['dateTimeFormat']);
  }

  HomeMenuConfig getUserDefaultMenu() {
    if (userMenus == null || userMenus.isEmpty) {
      return null;
    }
    final menu = userMenus.firstWhere(
        (element) =>
            element.shopUrl == _secureConfig.shopUrl &&
            element.username == _secureConfig.shopUsername,
        orElse: () => null);

    return menu;
  }

  @override
  HomeMenuConfig getUserMenu({String shopUrl, String username}) {
    if (userMenus == null || userMenus.isEmpty) {
      return null;
    }
    final menu = userMenus.firstWhere(
        (element) => element.shopUrl == shopUrl && element.username == username,
        orElse: () => null);

    return menu;
  }

  /// Setup and open shopConfig box
  /// ex: tmt25.tpos.vn_shopConfig
  /// Must init first after application loggined
  Future<void> init() async {
    hive = await Hive.openBox(
        '${_secureConfig.shopUrl.replaceAll(':', '').replaceAll('/', '')}_shopConfig');
  }

  @override
  Future<void> resetDefault() async {
    _currencyFormat = '###,###,###,###,###';
  }

  void setCompanyName(String value) {
    _companyName = value;
    hive.put('companyName', value);
  }

  @override
  void setCurrencyFormat(String value) {
    _currencyFormat = value ?? currencyFormat;
    hive.put('currencyFormat', value);
  }

  @override
  void setDateTimeFormat(String value) {
    _dateTimeFormat = value ?? dateTimeFormat;
    hive.put('dateTimeFormat', value);
  }

  @override
  void setFavoriteMenu(HomeMenuV2FavoriteModel value) {
    _favoriteMenu = value;
    hive.put('${_secureConfig.shopUsername}_favoriteMenu', value.toJson());
  }

  void setHomePageStyle(String value) {
    _homePageStyle = value ?? homePageStyle;
    hive.put('homePageStyle', value);
  }

  void setLocale(String value) {
    _locale = value;
    hive.put('locale', value);
  }

  void setShopUrl(String value) {
    _shopUrl = value ?? shopUrl;
    hive.put('shopUrl', value);
  }

  void setShopUsername(String value) {
    _shopUsername = value ?? shopUsername;
    hive.put('shopUsername', value);
  }

  void setUserMenu(HomeMenuConfig config) {
    final existsMenu = userMenus.firstWhere(
        (element) =>
            element.shopUrl == _secureConfig.shopUrl &&
            element.username == _secureConfig.shopUsername,
        orElse: () => null);

    config.shopUrl = _secureConfig.shopUrl;
    config.username = _secureConfig.shopUsername;
    config.name = 'Menu của ${_secureConfig.shopUrl}}';
    if (existsMenu == null) {
      userMenus.add(config);
    } else {
      userMenus.replace(config, userMenus.indexOf(existsMenu));
    }

    setUserMenus(userMenus);
  }

  void setUserMenus(List<HomeMenuConfig> items) {
    _userMenus = items;
    final String jsonText = jsonEncode({
      "items": items
          .map(
            (e) => e.toJson(),
          )
          .toList(),
    });
    hive.put(
      'userMenus',
      jsonText,
    );
  }

  void throwIfHiveIsNotInitial() {
    if (hive == null) {
      throw Exception('Hive is not initialize first');
    }
  }

  /// Convert
  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['shopUrl'] = shopUrl;
    data["shopUsername"] = shopUsername;
    data['companyName'] = companyName;

    data['currencyFormat'] = currencyFormat;
    data['dateTimeFormat'] = dateTimeFormat;
    data['homePageStyle'] = homePageStyle;
    data['userMenus'] =
        jsonEncode({'items': userMenus.map((e) => e.toJson()).toList()});

    //data['getUserDefaultMenu'] = getUserDefaultMenu;
    // Favorite menu

    data.addAll(_luckyWheelConfig.toJson());
    data.addAll(_oldLuckyWheelConfig.toJson());

    if (removeIfNull) {
      {
        data.removeWhere((key, value) => value == null);
      }
    }
    return data;
  }
}
