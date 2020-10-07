import 'package:flutter/material.dart';
import 'package:tpos_mobile/application/menu/menu_type.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';
import 'package:tpos_mobile/resources/menus.dart';

class HomeMenuConfig {
  HomeMenuConfig({
    this.version,
    this.name,
    this.username,
    this.shopUrl,
    this.mainMenus,
    this.menuGroups,
  });
  factory HomeMenuConfig.fromJson(Map<String, dynamic> json) {
    return HomeMenuConfig(
      version: json['version'],
      name: json['name'],
      shopUrl: json['shopUrl'],
      username: json['username'],
      mainMenus: json['mainMenus'] != null
          ? (json['mainMenus'] as List).cast<String>()
          : null,
      menuGroups: json['menuGroups'] != null
          ? (json['menuGroups'] as List)
              .map((e) => HomeMenuConfigGroup.fromJson(e))
              .toList()
          : null,
    );
  }

  String version;
  String name;

  /// Tên đăng nhập của khách hàng
  String username;

  /// Tên miền khách hàng
  String shopUrl;

  /// Danh sách menu chức năng chính
  List<String> mainMenus;

  /// Danh sách nhóm chức năng
  List<HomeMenuConfigGroup> menuGroups;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['version'] = version;
    data['name'] = name;
    data['username'] = username;
    data['shopUrl'] = shopUrl;

    data['mainMenus'] = mainMenus;
    data['menuGroups'] = menuGroups?.map((e) => e.toJson())?.toList();
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}

class HomeMenuConfigGroup {
  HomeMenuConfigGroup(
      {this.name,
      this.children,
      this.colorString,
      this.maxItem,
      this.maxLine,
      this.menuGroupType});
  factory HomeMenuConfigGroup.fromJson(Map<String, dynamic> json) {
    return HomeMenuConfigGroup(
      name: json['name'],
      children:
          json['children'] != null ? json['children'].cast<String>() : null,
      colorString: json['colorString'],
      maxItem: json['maxLine']?.toInt(),
      maxLine: json['maxItem']?.toInt(),
      menuGroupType: json['menuGroupType']
          ?.toString()
          ?.toEnum<MenuGroupType>(MenuGroupType.values),
    );
  }
  String name;
  MenuGroupType menuGroupType;
  String colorString;
  List<String> children;
  int maxLine;
  int maxItem;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['menuGroupType'] = menuGroupType?.describe;
    data['name'] = name;
    data['children'] = children;
    data['colorString'] = colorString;
    data['maxItem'] = maxItem;
    data['maxLine'] = maxLine;
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
