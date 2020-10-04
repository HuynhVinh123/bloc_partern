import 'package:flutter/cupertino.dart';
import 'package:tpos_mobile/application/menu/menu_type.dart';
import 'package:tpos_mobile/services/config_service/config_model/home_menu_config.dart';

abstract class MenuState {}

class MenuLoading extends MenuState {
  MenuLoading(this.message);
  final String message;
}

class MenuLoadSuccess extends MenuState {
  MenuLoadSuccess(
      {@required this.userMenu, @required this.allMenu, this.menuType});
  final MenuType menuType;
  final HomeMenuConfig userMenu;
  final HomeMenuConfig allMenu;
}

class MenuNotifySuccess extends MenuState {
  MenuNotifySuccess(this.message);
  final String message;
}
