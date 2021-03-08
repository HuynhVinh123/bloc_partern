import 'package:flutter/material.dart';
import 'package:tpos_mobile/resources/app_route.dart';
import 'package:tpos_mobile/resources/menus.dart';
import 'package:tpos_mobile/widgets/menu/menu_dialog.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';

class AddMenuPage extends StatelessWidget {
  final List<String> _routes = [
    AppRoute.addCustomer,
    AppRoute.addProductTemplate,
    AppRoute.addSupplier,
    AppRoute.addFastSaleOrder
  ];

  final List<MenuItem> _menus = <MenuItem>[];

  @override
  Widget build(BuildContext context) {
    return MenuDialog(
      menus: _menus,
      title: S.current.add,
    );
  }
}
