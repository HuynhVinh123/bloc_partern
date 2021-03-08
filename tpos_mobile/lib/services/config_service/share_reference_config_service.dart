import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/application/menu_v2/model.dart';
import 'package:tpos_mobile/extensions.dart';
import 'package:tpos_mobile/resources/app_route.dart';
import 'package:tpos_mobile/resources/menus.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';

import 'config_model/home_menu_config.dart';

class SharedPreferencesConfigService implements ConfigService {
  String _shopUrl;
  String _shopUsername;
  SharedPreferences _sp;
  int _loginCount;
  HomeMenuV2FavoriteModel _favoriteMenu;

  bool _showAllMenuOnStart;
  String _languageCode;
  String _countryCode;
  String _currencyFormat;
  String _dateFormat;

  String _companyName;
  String _previousVersion;
  List<String> _historyVersions;

  String _homePageStyle;

  /// cache the [lastFcmToken] to memory.
  String _lastFcmToken;

  List<String> _versionsHistory;

  /// Hàm khởi tạo dịch vụ.
  /// Phải gọi khi khởi tạo ứng dụng
  Future<void> init() async {
    _sp = await SharedPreferences.getInstance();
  }

  @override
  bool get showAllMenuOnStart =>
      _showAllMenuOnStart ??
      (_showAllMenuOnStart = _sp.getBool('showAllMenuOnStart')) ??
      false;

  @override
  String get previousVersion {
    if (historyVersions.isNotEmpty) {
      return historyVersions.last;
    } else {
      return null;
    }
  }

  bool get isUpdated => previousVersion == App.appVersion;
  String get lastFcmToken => _lastFcmToken ??= _sp.getString('lastFcmToken');
  List<String> get historyVersions =>
      _historyVersions ??
      (_historyVersions = _sp.getStringList('historyVersions')) ??
      <String>[];

  void setLastFcmToken(String value) {
    _lastFcmToken = value;
    _sp.setString('lastFcmToken', value);
  }

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

  HomeMenuV2FavoriteModel get favoriteMenu {
    if (_favoriteMenu != null) {
      return _favoriteMenu;
    }

    try {
      final String jsonString = _sp.getString('favoriteMenu');
      if (json != null) {
        final json = jsonDecode(jsonString);
        _favoriteMenu = HomeMenuV2FavoriteModel.fromJson(json);
      } else {
        _favoriteMenu = getFavoriteMenu();
      }
    } catch (e) {
      _favoriteMenu = getFavoriteMenu();
    }

    return _favoriteMenu;
  }

  @override
  String get languageCode =>
      _languageCode ?? (_languageCode = _sp.getString('languageCode')) ?? 'vi';

  @override
  String get countryCode =>
      _countryCode ?? (_countryCode = _sp.getString('countryCode')) ?? 'VN';

  String get homePageStyle =>
      _homePageStyle ??
      (_homePageStyle = _sp.getString('homePageStyle')) ??
      "style1";

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

  String get dateFormat =>
      _dateFormat ??
      (_dateFormat = _sp.getString('dateFormat')) ??
      'dd/MM/yyyy';

  void setPreviousVersion(String value) {
    if (previousVersion != value) {
      _previousVersion = value;
      _sp.setString('previousVersion', value);
    }
  }

  void updateVersion(String version) {
    if (!historyVersions.any((element) => element == version)) {
      historyVersions.add(version);
      _sp.setStringList('historyVersions', historyVersions);
    }
  }

  @override
  void startMigration() {
    // TODO: implement startMigration
  }

  void setFavoriteMenu(HomeMenuV2FavoriteModel model) {
    assert(model != null);
    _favoriteMenu = model;
    final String jsonString = jsonEncode(model.toJson());
    _sp.setString("favoriteMenu", jsonString);
  }

  void fromJson(Map<String, dynamic> jsonMap) {
    if (jsonMap['ShopUrl'] != null) {
      _shopUrl = jsonMap['ShopUrl'];
    }

    if (jsonMap['ShopUsername'] != null) {
      _shopUsername = jsonMap['ShopUsername'];
    }

    if (jsonMap['CompanyName'] != null) {
      _companyName = jsonMap['CompanyName'];
    }

    if (jsonMap['LoginCount'] != null) {
      _loginCount = jsonMap['LoginCount'] != null
          ? int.tryParse(jsonMap['LoginCount'])
          : 0;
    }

    if (jsonMap['FavoriteMenu'] != null) {
      _favoriteMenu =
          HomeMenuV2FavoriteModel.fromJson(jsonDecode(jsonMap["FavoriteMenu"]));
    }
    if (jsonMap['LanguageCode'] != null) {
      _languageCode = jsonMap['LanguageCode'];
    }
    if (jsonMap['CountryCode'] != null) {
      _countryCode = jsonMap['CountryCode'];
    }

    if (jsonMap['CurrencyFormat'] != null) {
      _currencyFormat = jsonMap['CurrencyFormat'];
    }

    if (jsonMap['PreviousVersion'] != null) {
      _previousVersion = jsonMap['PreviousVersion'];
    }

    if (jsonMap['HomePageStyle'] != null) {
      _homePageStyle = jsonMap['HomePageStyle'];
    }
    if (jsonMap['ShowAllMenuOnStart'] != null) {
      _showAllMenuOnStart =
          jsonMap['ShowAllMenuOnStart']?.toString()?.parseBool();
    }

    setCompanyName(_companyName);

    setLoginCount(_loginCount);

    setFavoriteMenu(_favoriteMenu);

    setShowAllMenuOnStart(_showAllMenuOnStart);

    setLanguageCode(_languageCode);

    setCountryCode(_countryCode);

    setPreviousVersion(_previousVersion);
  }

  @override
  Map<String, dynamic> toJon([removeIfNull = false]) {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["CompanyName"] = companyName;
    map["LoginCount"] = loginCount?.toString();

    map["FavoriteMenu"] =
        favoriteMenu != null ? jsonEncode(favoriteMenu) : null;

    map["LanguageCode"] = languageCode;
    map["CountryCode"] = countryCode;

    map["HomePageStyle"] = homePageStyle;
    map["ShowAllMenuOnStart"] = showAllMenuOnStart?.toString();
    return map;
  }
}
