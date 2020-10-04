import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tpos_mobile/application/menu/normal_menu_item_wrap.dart';

class OtherMenuPage extends StatelessWidget {
  const OtherMenuPage({Key key, this.menuItems}) : super(key: key);
  final List<Widget> menuItems;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.8),
          body: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.1, sigmaY: 3.1),
            child: Stack(
              children: [
                Center(
                  child: NormalMenuItemWrap(
                    onReorder: (a1, a2) {},
                    children: menuItems,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
