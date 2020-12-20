import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_mobile/application/menu/menu_multi_select_page.dart';
import 'package:tpos_mobile/application/menu_v2/favorite_menu_card.dart';
import 'package:tpos_mobile/application/menu_v2/favorite_menu_container.dart';
import 'package:tpos_mobile/resources/app_colors.dart';
import 'package:tpos_mobile/resources/menus.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';
import 'package:tpos_mobile/widgets/button/action_button.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/dialog/app_alert_dialog.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';
import 'package:tpos_mobile/extensions.dart';

import 'favorite_menu_item.dart';
import 'model.dart';

/// Tùy chỉnh menu yêu thích của khách hàng
class FavoriteMenuCustomizePage extends StatefulWidget {
  @override
  _FavoriteMenuCustomizePageState createState() =>
      _FavoriteMenuCustomizePageState();
}

class _FavoriteMenuCustomizePageState extends State<FavoriteMenuCustomizePage> {
  final config = GetIt.I<ConfigService>();
  HomeMenuV2FavoriteModel _menu;

  @override
  void initState() {
    _menu = config.favoriteMenu;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<FavoriteMenuItem> _menuItems = <FavoriteMenuItem>[];

    for (final route in _menu.routes) {
      final menu = getMenuByRoute(route);
      _menuItems.add(FavoriteMenuItem(
        title: menu?.name() ?? "N/A",
        icon: menu?.icon,
        gradient: menu?.type?.linearGradient,
        onDeleted: () {
          setState(() {
            _menu.routes.removeWhere((element) => element == menu.route);
          });
        },
      ));
    }

    const TextStyle guideStyle = TextStyle(fontSize: 17, color: Colors.grey);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.rearrangeTheFavoriteMenu),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 12,
            ),
            // Hướng dẫn.
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: S.current.rearrangeTheFavoriteMenu_tutorial1,
                    style: guideStyle,
                  ),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: S.current.press,
                    style: guideStyle,
                  ),
                  const WidgetSpan(
                    child: Icon(Icons.add_circle),
                  ),
                  TextSpan(
                    text: S.current.rearrangeTheFavoriteMenu_tutorial2,
                    style: guideStyle,
                  ),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: FavoriteMenuCard(
                child: FavoriteMenuContainer(
                  onReorder: (v1, v2) {
                    setState(() {
                      final String removed = _menu.routes.removeAt(v1);
                      _menu.routes.insert(v2, removed);
                      config.setFavoriteMenu(_menu);
                    });
                  },
                  isCustomize: true,
                  items: _menuItems,
                  onAddPressed: () {
                    _showAddMenuItem();
                  },
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(S.current.saveAndClose),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AppAlertDialog(
                      type: AlertDialogType.warning,
                      title: Text(S.current.confirmRestoreDefault),
                      // Menu tùy chọn sẽ được khôi phục về trạng thái như lúc mới cài ứng dụng.
                      content: Text(S.current.homePage_infoRestoreMenu),
                      actions: <Widget>[
                        //Hủy bỏ
                        ActionButton(
                          child: Text(S.current.cancel),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: AppColors.dialogCancelColor,
                        ),
                        // 'Đồng ý'
                        ActionButton(
                          child: Text(S.current.agree),
                          onPressed: () {
                            Navigator.pop(context);
                            config.setFavoriteMenu(getFavoriteMenu());
                            _menu = config.favoriteMenu;
                            setState(() {});
                            context.showToast(
                              title: 'Đã thao tác thành công',
                              message:
                                  'Đã khôi phục "Danh mục tính năng yêu thích" về mặc định',
                            );
                          },
                          color: AppColors.dialogWarningColor,
                        ),
                      ],
                    ),
                  );
                },
                child: Text(S.current.restoreDefault),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddMenuItem() async {
    final List<String> selectedRoute = await showGeneralDialog(
      context: context,
      pageBuilder: (context, anim, secondAnim) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          margin:
              const EdgeInsets.only(left: 16, right: 16, top: 100, bottom: 100),
          child: MenuMultiSelectPage(
            oldSelectedItem: _menu.routes,
          ),
        );
      },
    );

    if (selectedRoute != null) {
      setState(() {
        _menu.routes.addAll(selectedRoute);
        config.setFavoriteMenu(_menu);
      });
    }
  }
}
