import 'package:flutter/material.dart';

bool handlePermission(String? permission) {
  final List<Item> _menuItems = MenuItems;

  if (permission == null) {
    return true;
  }

  /// Kiểm tra xem có tồn tại quyền hay không (Danh sách quyền để thêm sau)
  final bool isExist =
      _menuItems.any((Item element) => element.permission == permission);
  if(isExist){
    return true;
  }

  return false;
}

List<Item> MenuItems = <Item>[
  Item(
      name: 'Lịch hẹn',
      icon: const Icon(
        Icons.description,
      )),
  Item(name: 'Khách hàng', icon: const Icon(Icons.description)),
  Item(name: 'Labo', icon: const Icon(Icons.description)),
  Item(name: 'Phiếu điều trị nhanh', icon: const Icon(Icons.description)),
];

class Item {
  Item({required this.name, required this.icon, this.permission, this.route});

  String name;
  Widget icon;
  String? permission;
  String? route;
}
