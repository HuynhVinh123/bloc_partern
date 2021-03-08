import 'package:flutter/foundation.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

enum MenuType { all, custom }

extension MenuTypeExtensions on MenuType {
  String get reverse => this == MenuType.all ? 'TÙY CHỈNH' : "TẤT CẢ TÍNH NĂNG";
  String get describe => describeEnum(this);

  String get description {
    switch (this) {
      case MenuType.custom:
        return S.current.menu_customMenu.toUpperCase();
      case MenuType.all:
        return S.current.menu_allFeature.toUpperCase();
      default:
        return 'N/A';
    }
  }
}
