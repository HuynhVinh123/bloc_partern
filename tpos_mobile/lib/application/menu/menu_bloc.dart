import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_mobile/resources/app_colors.dart';
import 'package:tpos_mobile/resources/menus.dart';
import 'package:tpos_mobile/services/config_service/config_model/home_menu_config.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';
import 'package:tpos_mobile/services/config_service/shop_config_service.dart';

import 'menu_event.dart';
import 'menu_state.dart';
import 'menu_type.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc({
    MenuState initialState,
    ConfigService configService,
    ShopConfigService shopConfigService,
    SecureConfigService secureConfigService,
  }) : super(initialState) {
    _configService = configService ?? GetIt.instance<ConfigService>();
    _shopConfig = shopConfigService ?? GetIt.instance<ShopConfigService>();
    _secureConfig = secureConfigService?? GetIt.instance<SecureConfigService>();
  }

  ConfigService _configService;
  ShopConfigService _shopConfig;
  SecureConfigService _secureConfig;
  MenuType _menuType = MenuType.all;
  HomeMenuConfig _allMenu;
  HomeMenuConfig _userMenu;

  @override
  Stream<MenuState> mapEventToState(MenuEvent event) async* {
    if (event is MenuLoaded) {
      _menuType =
          _configService.showAllMenuOnStart ? MenuType.all : MenuType.custom;
      _allMenu = homeMenuAll();
      _userMenu = _shopConfig.getUserDefaultMenu();
      if (_userMenu != null) {
        yield MenuLoadSuccess(
          allMenu: _allMenu,
          userMenu: _userMenu,
          menuType: _menuType,
        );
      } else {
        // Khởi tạo menu lần đầu tiên nếu menu chưa tồn tại

        yield MenuLoading('Đang chuẩn bị danh mục tính năng');
        await Future.delayed(const Duration(seconds: 5));
        _userMenu = HomeMenuConfig(
          shopUrl: _secureConfig.shopUrl,
          username: _secureConfig.shopUsername,
          name: 'Menu riêng của ${_secureConfig.shopUsername}',
          version: '1.0',
          mainMenus: _configService.homeMenuDefault.mainMenus,
          menuGroups: _configService.homeMenuDefault.menuGroups,
        );

        _shopConfig.setUserMenu(_userMenu);
        yield MenuLoadSuccess(
          allMenu: _allMenu,
          userMenu: _userMenu,
          menuType: _menuType,
        );
      }
      // even [MenuTypeChanged]
    } else if (event is MenuTypeChanged) {
      _configService.setShowAllMenuOnStart(event.menuType == MenuType.all);
      _menuType = event.menuType;
      yield MenuLoadSuccess(
        allMenu: _allMenu,
        userMenu: _userMenu,
        menuType: _menuType,
      );
      // even [MenuReorder]
    } else if (event is MenuReorder) {
      final HomeMenuConfigGroup groups = _userMenu.menuGroups.firstWhere(
          (element) => element.name == event.groupName,
          orElse: () => null);
      final String removed = groups.children.removeAt(event.oldIndex);
      groups.children.insert(event.newIndex, removed);
      _shopConfig.setUserMenu(_userMenu);
      yield MenuLoadSuccess(
        allMenu: _allMenu,
        userMenu: _userMenu,
        menuType: _menuType,
      );
      // even [MenuDeleted]
    } else if (event is MenuDeleted) {
      final HomeMenuConfigGroup groups = _userMenu.menuGroups.firstWhere(
          (element) => element.name == event.groupName,
          orElse: () => null);
      groups.children.removeWhere((element) => element == event.menuRoute);

      _shopConfig.setUserMenu(_userMenu);
      yield MenuLoadSuccess(
        allMenu: _allMenu,
        userMenu: _userMenu,
        menuType: _menuType,
      );
      // even [MenuAdded]
    } else if (event is MenuAdded) {
      final HomeMenuConfigGroup groups = _userMenu.menuGroups.firstWhere(
          (element) => element.name == event.groupName,
          orElse: () => null);
      groups.children.addAll(event.addRoute);

      _shopConfig.setUserMenu(_userMenu);
      yield MenuLoadSuccess(
        allMenu: _allMenu,
        userMenu: _userMenu,
        menuType: _menuType,
      );
    } else if (event is MenuGroupReOrdered) {
      final int indexOfGroup = _userMenu.menuGroups.indexWhere(
        (a) => event.groupName == a.name,
      );

      if (event.isUp) {
        if (indexOfGroup != 0) {
          final item = _userMenu.menuGroups.removeAt(indexOfGroup);
          _userMenu.menuGroups.insert(indexOfGroup - 1, item);
        }
      } else {
        if (indexOfGroup != _userMenu.menuGroups.length) {
          final item = _userMenu.menuGroups.removeAt(indexOfGroup);
          _userMenu.menuGroups.insert(indexOfGroup + 1, item);
        }
      }

      _shopConfig.setUserMenu(_userMenu);
      yield MenuLoadSuccess(
        allMenu: _allMenu,
        userMenu: _userMenu,
        menuType: _menuType,
      );
    } else if (event is MenuGroupDeleted) {
      final HomeMenuConfigGroup groups = _userMenu.menuGroups.firstWhere(
          (element) => element.name == event.groupName,
          orElse: () => null);

      _userMenu.menuGroups.remove(groups);

      _shopConfig.setUserMenu(_userMenu);
      yield MenuLoadSuccess(
        allMenu: _allMenu,
        userMenu: _userMenu,
        menuType: _menuType,
      );
      // Thêm nhóm mới
    } else if (event is MenuGroupAdded) {
      _userMenu.menuGroups.add(
        HomeMenuConfigGroup(
          name: 'Nhóm mới 1',
          color: AppColors.backgroundColor.value,
          children: [],
        ),
      );

      _shopConfig.setUserMenu(_userMenu);
      yield MenuLoadSuccess(
        allMenu: _allMenu,
        userMenu: _userMenu,
        menuType: _menuType,
      );
      // Khôi phục mặc định
    } else if (event is MenuRestoreDefault) {
      _userMenu = _configService.homeMenuDefault;
      _shopConfig.setUserMenu(_userMenu);
      yield MenuLoadSuccess(
        allMenu: _allMenu,
        userMenu: _userMenu,
        menuType: _menuType,
      );
      yield MenuNotifySuccess('Đã khôi phục menu tùy chọn về mặc định');
    } else if (event is MenuGroupRenamed) {
      final index = _userMenu.menuGroups.indexOf(event.group);
      _userMenu.menuGroups[index].name = event.newName;
      _userMenu.menuGroups[index].maxLine = event.maxLine;
      _shopConfig.setUserMenu(_userMenu);
      yield MenuLoadSuccess(
        allMenu: _allMenu,
        userMenu: _userMenu,
        menuType: _menuType,
      );
    }
  }
}
