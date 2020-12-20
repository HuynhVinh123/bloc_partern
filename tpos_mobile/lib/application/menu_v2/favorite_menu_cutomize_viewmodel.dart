import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';

class MenuV2ViewModel with ChangeNotifier {
  MenuV2ViewModel(ConfigService configService) {
    _config = configService ?? GetIt.I<ConfigService>();
    init();
  }

  ConfigService _config;
  List<String> _favoriteMenus;

  List<String> get favoriteMenus => _favoriteMenus;

  /// Init view model. called by contructor
  void init() {}

  /// Init view model data. Caled by UI
  Future<void> initData() async {
    final menuConfig = _config.favoriteMenu;
    _favoriteMenus = menuConfig.routes;
  }
}
