import 'package:tpos_mobile/services/config_service/config_model/home_menu_config.dart';

import 'menu_type.dart';

abstract class MenuEvent {}

class MenuLoaded extends MenuEvent {
  MenuLoaded();
}

class MenuTypeChanged extends MenuEvent {
  MenuTypeChanged(this.menuType);
  final MenuType menuType;
}

class MenuReorder extends MenuEvent {
  MenuReorder({this.oldIndex, this.newIndex, this.groupName});
  final int oldIndex;
  final int newIndex;
  final String groupName;
}

class MenuDeleted extends MenuEvent {
  MenuDeleted({this.groupName, this.menuRoute});
  final String groupName;
  final String menuRoute;
}

class MenuAdded extends MenuEvent {
  MenuAdded({this.addRoute, this.groupName});
  final List<String> addRoute;
  final String groupName;
}

class MenuGroupReOrdered extends MenuEvent {
  MenuGroupReOrdered({this.isUp, this.groupName});
  final bool isUp;
  final String groupName;
}

class MenuGroupDeleted extends MenuEvent {
  MenuGroupDeleted({this.groupName});
  final String groupName;
}

class MenuGroupAdded extends MenuEvent {}

class MenuRestoreDefault extends MenuEvent {}

class MenuGroupRenamed extends MenuEvent {
  MenuGroupRenamed(this.group, this.newName, {this.maxLine = 0});
  final HomeMenuConfigGroup group;
  final String newName;
  final int maxLine;
}
