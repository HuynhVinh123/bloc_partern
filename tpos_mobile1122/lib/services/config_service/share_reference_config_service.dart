import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tpos_mobile/application/menu/menu_type.dart';
import 'package:tpos_mobile/resources/app_route.dart';
import 'package:tpos_mobile/resources/menus.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';
import 'config_model/home_menu_config.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';

class SharedPreferencesConfigService implements ConfigService {
  String _shopUrl;
  String _shopUsername;
  SharedPreferences _sp;
  int _loginCount;
  HomeMenuConfig _homeMenu;

  /// Lưu danh sách menu người dùng
  List<HomeMenuConfig> _userMenus;

  bool _showAllMenuOnStart;
  String _languageCode;
  String _countryCode;
  String _currencyFormat;
  String _dateFormat;
  String _dateTimeFormat;
  String _companyName;
  String _previousVersion;
  List<String> _historyVersions;

  /// Hàm khởi tạo dịch vụ.
  /// Phải gọi khi khởi tạo ứng dụng
  Future<void> init() async {
    _sp = await SharedPreferences.getInstance();
  }

  @override
  void setShopUrl(String value) {
    _shopUrl = value;
    _sp.setString('shopUrl', value);
  }

  @override
  String get shopUrl =>
      _shopUrl ??
      (_shopUrl = _sp.getString('shopUrl')) ??
      'https://tenshop.tpos.vn';

  @override
  bool get showAllMenuOnStart =>
      _showAllMenuOnStart ??
      (_showAllMenuOnStart = _sp.getBool('showAllMenuOnStart')) ??
      false;

  @override
  String get previousVersion =>
      _previousVersion ??
      {_previousVersion = _sp.getString('previousVersion')} ??
      '';
  List<String> get historyVersions =>
      _historyVersions ??
      (_historyVersions = _sp.getStringList('historyVersions')) ??
      <String>[];

  @override
  void setShopUsername(String value) {
    _shopUsername = value;
    _sp.setString('shopUsername', value);
  }

  @override
  String get shopUsername =>
      _shopUsername ?? (_shopUsername = _sp.getString('shopUsername'));

  @override
  int get loginCount =>
      _loginCount ?? (_loginCount = _sp.getInt('loginCount')) ?? 0;

  String get companyName =>
      _companyName ?? (_companyName = _sp.getString('companyName')) ?? '';

  @override
  void setLoginCount(int value) {
    _loginCount = value;
    _sp.setInt('loginCount', value);
  }

  @override
  void setShowAllMenuOnStart(bool value) {
    _showAllMenuOnStart = value;
    _sp.setBool('showAllMenuOnStart', value);
  }

  void setCompanyName(String value) {
    _companyName = value;
    _sp.setString('companyName', value);
  }

  HomeMenuConfig _getHomeCustomMenuDefault() =>
      HomeMenuConfig(name: 'Tất cả menu', version: '1.0', mainMenus: [
        AppRoute.addFastSaleOrder,
        AppRoute.addProductTemplate,
        AppRoute.reportMenu,
        AppRoute.setting,
      ], menuGroups: [
        HomeMenuConfigGroup(
            name: 'Bán hàng',
            color: MenuGroupType.saleOnline.backgroundColor.value,
            children: [
              AppRoute.facebookSaleChannel,
              if (kDebugMode) //TODO(namnv): Bỏ If này sau khi tính năng chốt đơn hoàn thành
                AppRoute.facebookSessions,
              AppRoute.saleOnlineOrders,
              AppRoute.facebookLiveCampaign,
              AppRoute.addFastSaleOrder,
              AppRoute.fastSaleOrders,
              AppRoute.deliveryOrder,
              AppRoute.posSale,
              AppRoute.saleOrders,
              AppRoute.saleQuotations,
            ]),
        HomeMenuConfigGroup(
            name: 'Kho hàng',
            color: MenuGroupType.inventory.backgroundColor.value,
            children: [
              AppRoute.productTemplates,
              AppRoute.fastPurchaseOrders,
              AppRoute.refundFastPurchseOrder,
            ]),
        HomeMenuConfigGroup(
            name: 'Danh mục + Cài đặt',
            color: MenuGroupType.setting.backgroundColor.value,
            children: [
              AppRoute.customers,
              AppRoute.suppliers,
              AppRoute.deliveryCarriers,
              AppRoute.accountPayment,
              AppRoute.accountSalePayment,
              AppRoute.setting,
            ]),
      ]);

  HomeMenuConfig get homeMenuDefault => _getHomeCustomMenuDefault();

  List<HomeMenuConfig> get userMenus {
    if (_userMenus != null) {
      return _userMenus;
    }

    final List<String> userMenusStringList = _sp.getStringList('userMenus');
    if (userMenusStringList != null) {
      _userMenus = userMenusStringList.map((e) {
        final decode = jsonDecode(e);
        return HomeMenuConfig.fromJson(decode);
      }).toList();
    } else {
      _userMenus = <HomeMenuConfig>[];
    }
    return _userMenus;
  }

  @override
  String get languageCode =>
      _languageCode ?? (_languageCode = _sp.getString('languageCode')) ?? 'vi';

  @override
  String get countryCode =>
      _countryCode ?? (_sp.getString('countryCode')) ?? 'VN';

  @override
  void setCountryCode(String value) {
    _countryCode = value;
    _sp.setString('countryCode', value);
  }

  @override
  void setLanguageCode(String value) {
    _languageCode = value;
    _sp.setString('languageCode', value);
  }

  void setUserMenus(List<HomeMenuConfig> items) {
    _userMenus = items;
    _sp.setStringList(
      'userMenus',
      items
          .map(
            (e) => jsonEncode(
              e.toJson(),
            ),
          )
          .toList(),
    );
  }

  void setUserMenu(HomeMenuConfig config) {
    final existsMenu = userMenus.firstWhere(
        (element) =>
            element.shopUrl == shopUrl && element.username == shopUsername,
        orElse: () => null);

    config.shopUrl = shopUrl;
    config.username = shopUsername;
    config.name = 'Menu của $shopUsername';
    if (existsMenu == null) {
      userMenus.add(config);
    } else {
      userMenus.replace(config, userMenus.indexOf(existsMenu));
    }

    setUserMenus(userMenus);
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

  HomeMenuConfig getUserDefaultMenu() {
    if (userMenus == null || userMenus.isEmpty) {
      return null;
    }
    final menu = userMenus.firstWhere(
        (element) =>
            element.shopUrl == shopUrl && element.username == shopUsername,
        orElse: () => null);

    return menu;
  }

  @override
  String get currencyFormat =>
      _currencyFormat ??
      (_currencyFormat = _sp.getString('currencyFormat')) ??
      '###,###,###,###,###';

  @override
  String get dateFormat =>
      _dateFormat ??
      (_dateFormat = _sp.getString('dateFormat')) ??
      'dd/MM/yyyy';

  @override
  String get dateTimeFormat =>
      _dateTimeFormat ??
      (_dateTimeFormat = _sp.getString('dateTimeFormat')) ??
      'dd/MM/yyyy HH:mm:ss';

  void setPreviousVersion(String value) {
    if (previousVersion != value) {
      _previousVersion = value;
      _sp.setString('previousVersion', value);
    }
  }

  void updateVersion(String version) {
    setPreviousVersion(version);
    if (!historyVersions.any((element) => element == version)) {
      historyVersions.add(version);
      _sp.setStringList('historyVersions', historyVersions);
    }
  }

  @override
  void startMigration() {
    // TODO: implement startMigration
  }
}
