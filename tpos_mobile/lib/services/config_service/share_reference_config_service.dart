import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';
import 'package:tpos_mobile/application/menu_v2/model.dart';
import 'package:tpos_mobile/resources/app_route.dart';
import 'package:tpos_mobile/resources/menus.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';

import 'config_model/home_menu_config.dart';

class SharedPreferencesConfigService implements ConfigService {
  String _shopUrl;
  String _shopUsername;
  SharedPreferences _sp;
  int _loginCount;
  HomeMenuConfig _homeMenu;
  HomeMenuV2FavoriteModel _favoriteMenu;

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

  String _homePageStyle;

  ///Game lucky wheel
  bool _luckyWheelHasComment;
  bool _luckyWheelHasShare;
  bool _luckyWheelHasOrder;
  bool _luckyWheelIgnoreWinnerPlayer;
  bool _luckyWheelPrioritySharers;
  bool _luckyWheelPriorityGroupSharers;
  bool _luckyWheelPriorityPersonalSharers;
  bool _luckyWheelPriorityCommentPlayers;
  bool _luckyWheelPriorityIgnoreWinner;
  bool _luckyWheelIgnoreWinnerDay;
  int _luckyWheelTimeInSecond;
  int _luckyWheelSkipDays;
  bool _luckyWheelIsPriority;

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
    } catch (e, s) {
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

  void setHomePageStyle(String value) {
    _homePageStyle = value;
    _sp.setString('homePageStyle', value);
  }

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

  @override
  bool get luckyWheelHasComment =>
      _luckyWheelHasComment ??
      (_luckyWheelHasComment = _sp.getBool('luckyWheelHasComment')) ??
      true;

  @override
  bool get luckyWheelHasOrder =>
      _luckyWheelHasOrder ??
      (_luckyWheelHasOrder = _sp.getBool('luckyWheelHasOrder')) ??
      true;

  @override
  bool get luckyWheelHasShare =>
      _luckyWheelHasShare ??
      (_luckyWheelHasShare = _sp.getBool('luckyWheelHasShare')) ??
      true;

  @override
  bool get luckyWheelIgnoreWinnerDay =>
      _luckyWheelIgnoreWinnerDay ??
      (_luckyWheelIgnoreWinnerDay = _sp.getBool('luckyWheelIgnoreWinnerDay')) ??
      true;

  @override
  bool get luckyWheelIgnoreWinnerPlayer =>
      _luckyWheelIgnoreWinnerPlayer ??
      (_luckyWheelIgnoreWinnerPlayer =
          _sp.getBool('luckyWheelIgnoreWinnerPlayer')) ??
      true;

  @override
  bool get luckyWheelPriorityCommentPlayers =>
      _luckyWheelPriorityCommentPlayers ??
      (_luckyWheelPriorityCommentPlayers =
          _sp.getBool('luckyWheelPriorityCommentPlayers')) ??
      true;

  @override
  bool get luckyWheelPriorityGroupSharers =>
      _luckyWheelPriorityGroupSharers ??
      (_luckyWheelPriorityGroupSharers =
          _sp.getBool('luckyWheelPriorityGroupSharers')) ??
      true;

  @override
  bool get luckyWheelPriorityIgnoreWinner =>
      _luckyWheelPriorityIgnoreWinner ??
      (_luckyWheelPriorityIgnoreWinner =
          _sp.getBool('luckyWheelPriorityIgnoreWinner')) ??
      true;

  @override
  bool get luckyWheelPriorityPersonalSharers =>
      _luckyWheelPriorityPersonalSharers ??
      (_luckyWheelPriorityPersonalSharers =
          _sp.getBool('luckyWheelPriorityPersonalSharers')) ??
      true;

  @override
  bool get luckyWheelPrioritySharers =>
      _luckyWheelPrioritySharers ??
      (_luckyWheelPrioritySharers = _sp.getBool('luckyWheelPrioritySharers')) ??
      true;

  @override
  int get luckyWheelTimeInSecond =>
      _luckyWheelTimeInSecond ??
      (_luckyWheelTimeInSecond = _sp.getInt('luckyWheelTimeInSecond')) ??
      10;

  @override
  int get luckyWheelSkipDays =>
      _luckyWheelSkipDays ??
      (_luckyWheelSkipDays = _sp.getInt('luckyWheelSkipDays')) ??
      0;

  @override
  bool get luckyWheelIsPriority =>
      _luckyWheelIsPriority ??
      (_luckyWheelIsPriority = _sp.getBool('luckyWheelIsPriority')) ??
      true;

  @override
  void setLuckyWheelIsPriority(bool value) {
    if (_luckyWheelIsPriority != value) {
      _luckyWheelIsPriority = value;
      _sp.setBool('luckyWheelIsPriority', _luckyWheelIsPriority);
    }
  }

  @override
  void setLuckyWheelHasComment(bool value) {
    if (_luckyWheelHasComment != value) {
      _luckyWheelHasComment = value;
      _sp.setBool('luckyWheelHasComment', _luckyWheelHasComment);
    }
  }

  @override
  void setLuckyWheelHasOrder(bool value) {
    if (_luckyWheelHasOrder != value) {
      _luckyWheelHasOrder = value;
      _sp.setBool('luckyWheelHasOrder', _luckyWheelHasOrder);
    }
  }

  @override
  void setLuckyWheelHasShare(bool value) {
    if (_luckyWheelHasShare != value) {
      _luckyWheelHasShare = value;
      _sp.setBool('luckyWheelHasShare', _luckyWheelHasShare);
    }
  }

  @override
  void setLuckyWheelIgnoreWinnerPlayer(bool value) {
    if (_luckyWheelIgnoreWinnerPlayer != value) {
      _luckyWheelIgnoreWinnerPlayer = value;
      _sp.setBool(
          'luckyWheelIgnoreWinnerPlayer', _luckyWheelIgnoreWinnerPlayer);
    }
  }

  @override
  void setLuckyWheelPriorityGroupSharers(bool value) {
    if (_luckyWheelPriorityGroupSharers != value) {
      _luckyWheelPriorityGroupSharers = value;
      _sp.setBool(
          'luckyWheelPriorityGroupSharers', _luckyWheelPriorityGroupSharers);
    }
  }

  @override
  void setLuckyWheelPriorityIgnoreWinner(bool value) {
    if (_luckyWheelPriorityIgnoreWinner != value) {
      _luckyWheelPriorityIgnoreWinner = value;
      _sp.setBool(
          'luckyWheelPriorityIgnoreWinner', _luckyWheelPriorityIgnoreWinner);
    }
  }

  @override
  void setLuckyWheelPriorityIgnoreWinnerDay(int value) {
    if (_luckyWheelSkipDays != value) {
      _luckyWheelSkipDays = value;
      _sp.setInt('luckyWheelSkipDays', _luckyWheelSkipDays);
    }
  }

  @override
  void setLuckyWheelPriorityPersonalSharers(bool value) {
    if (_luckyWheelPriorityPersonalSharers != value) {
      _luckyWheelPriorityPersonalSharers = value;
      _sp.setBool('luckyWheelPriorityPersonalSharers',
          _luckyWheelPriorityPersonalSharers);
    }
  }

  @override
  void setLuckyWheelPrioritySharers(bool value) {
    if (_luckyWheelPrioritySharers != value) {
      _luckyWheelPrioritySharers = value;
      _sp.setBool('luckyWheelPrioritySharers', _luckyWheelPrioritySharers);
    }
  }

  @override
  void setLuckyWheelTimeInSecond(int value) {
    if (_luckyWheelTimeInSecond != value) {
      _luckyWheelTimeInSecond = value;
      _sp.setInt('luckyWheelTimeInSecond', _luckyWheelTimeInSecond);
    }
  }

  @override
  void setLuckyWheelSkipDays(int value) {
    if (_luckyWheelSkipDays != value) {
      _luckyWheelSkipDays = value;
      _sp.setInt('luckyWheelSkipDays', _luckyWheelSkipDays);
    }
  }

  void setFavoriteMenu(HomeMenuV2FavoriteModel model) {
    assert(model != null);
    _favoriteMenu = model;
    final String jsonString = jsonEncode(model.toJson());
    _sp.setString("favoriteMenu", jsonString);
  }
}
