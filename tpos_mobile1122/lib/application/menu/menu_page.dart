import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:tmt_flutter_untils/sources/enum_utils/enum_extensions.dart';

import 'package:tpos_mobile/application/home_page/home_page_bloc.dart';
import 'package:tpos_mobile/application/home_page/home_page_event.dart';
import 'package:tpos_mobile/application/home_page/home_page_state.dart';
import 'package:tpos_mobile/application/menu/drawer_menu.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';
import 'package:tpos_mobile/resources/app_colors.dart';
import 'package:tpos_mobile/resources/menus.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';
import 'package:tpos_mobile/widgets/button/action_button.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/dialog/app_alert_dialog.dart';
import 'package:tpos_mobile/services/config_service/config_model/home_menu_config.dart';
import 'package:tmt_flutter_untils/tmt_flutter_utils.dart';
import 'package:tpos_mobile/extensions.dart';
import 'menu_alert.dart';
import 'menu_bloc.dart';
import 'menu_event.dart';
import 'menu_multi_select_page.dart';
import 'menu_search_delegate.dart';
import 'menu_state.dart';
import 'menu_type.dart';
import 'menu_widget.dart';
import 'normal_menu_item_wrap.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final MenuBloc _menuBloc = MenuBloc();
  MenuType _menuType;
  bool _reorderEnable = false;
  bool get _canReorder => _menuType == MenuType.custom && _reorderEnable;

  @override
  void initState() {
    _menuBloc.add(MenuLoaded());
    super.initState();
  }

  /// Handle when tapped 'edit' button on [NormalMenuItemWrap]
  Future<void> _handleRenameGroup(
      HomeMenuConfigGroup group, BuildContext context) async {
    final TextEditingController _controler =
        TextEditingController(text: group.name);
    final MoneyMaskedTextController _maxLineController =
        MoneyMaskedTextController(
            initialValue: group.maxLine?.toDouble() ?? 0,
            decimalSeparator: '',
            precision: 0,
            thousandSeparator: '');

    context.showDialog(AlertDialog(
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _controler,
            ),
            SizedBox(
              height: 40,
              width: 400,
              child: StatefulBuilder(
                builder: (context, setState1) => Wrap(
                  children: MenuGroupType.values
                      .map(
                        (e) => InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              color: e.backgroundColor,
                              border: Border.all(color: Colors.white),
                            ),
                            width: 40,
                            height: 40,
                            child: group.color == e.backgroundColor.value
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  )
                                : const SizedBox(),
                          ),
                          onTap: () {
                            setState(() {
                              group.color = e.backgroundColor.value;
                            });
                            setState1(() {});
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            TextFormField(
              controller: _maxLineController,
              onChanged: (text) {
                if (text == '' || text == null) {
                  _maxLineController.updateValue(0.0);
                }
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Số dòng tối đa:',
                hintText: 'Để 0 để hiện tất cả',
              ),
            ),
          ],
        ),
      ),
      actions: [
        ActionButton(
          color: AppColors.primary1,
          child: Text(
            S.current.dialogActionOk,
            style: const TextStyle(color: Colors.white),
          ),
          onPressed: () {
            if (_maxLineController.text == '') {
              _maxLineController.updateValue(0);
            }
            _menuBloc.add(
              MenuGroupRenamed(
                group,
                _controler.text.trim(),
                maxLine: _maxLineController.numberValue?.toInt(),
              ),
            );
            Navigator.pop(context);
          },
        ),
      ],
    ));
  }

  @override
  void dispose() {
    _menuBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocUiProvider<MenuBloc>(
      bloc: _menuBloc,
      listen: (state) {
        if (state is MenuNotifySuccess) {
          context.showToast(type: AlertDialogType.info, message: state.message);
        }
      },
      busyStates: const [MenuLoading],
      child: Scaffold(
        body: _buildBody(),
        backgroundColor: AppColors.backgroundColor,
        drawer: DrawerMenu(),
      ),
    );
  }

  // UI Appbar. Thanh tìm kiếm và nút đổi công ty hiện tại
  Widget _buildAppBar() {
    return SafeArea(
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: InkWell(
              onTap: () async {
                await showSearch(
                  context: context,
                  delegate: MenuSearchDelegate(),
                );
              },
              child: Container(
                height: 34,
                decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(17)),
                child: Row(
                  children: <Widget>[
                    Builder(
                      builder: (context) => Material(
                        color: Colors.transparent,
                        child: InkWell(
                          child: const Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: Icon(
                              Icons.menu,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    const Icon(
                      Icons.search,
                      size: 19,
                      color: Colors.white70,
                    ),
                    Text(
                      S.current.menu_search,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Stack(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                width: 32,
                height: 32,
                child: const CircleAvatar(
                  backgroundImage: AssetImage("assets/icon/ic_user.png"),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 12,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      shape: BoxShape.circle),
                  child: const CircleAvatar(
                    backgroundColor: Colors.green,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  /// UI Phần thân của giao diện chính
  Widget _buildBody() {
    return BlocBuilder<MenuBloc, MenuState>(
      buildWhen: (context, state) => state is MenuLoadSuccess,
      builder: (context, state) {
        if (state is MenuLoadSuccess) {
          _menuType ??= state.menuType;
          return Stack(
            children: [
              ClipPath(
                clipper: _MyClipper(),
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1CAC3E), Color(0xFF035A1A)],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  _buildAppBar(),
                  const SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () {
                        BlocProvider.of<HomeBloc>(context).add(HomeLoaded());
                        return Future.delayed(const Duration(seconds: 1));
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 20,
                            ),
                            _buildMainMenu(state.allMenu),
                            _buildButton(),
                            // _buildButton2(),
                            _buildCustomMenu(
                              state.menuType == MenuType.all
                                  ? state.allMenu
                                  : state.userMenu,
                              state.menuType,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _buildNotifyMenu()
                ],
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  /// Mở dialog và chọn menu mới cần thêm vào danh sách
  Future<void> _showAddMenuItem(HomeMenuConfigGroup group) async {
    final List<String> selectedRoute = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(12),
          titlePadding: const EdgeInsets.all(0),
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1,
              )),
          content: Container(
            width: MediaQuery.of(context).size.width,
            child: MenuMultiSelectPage(
              oldSelectedItem: group.children,
            ),
          ),
        );
      },
    );

    if (selectedRoute != null) {
      _menuBloc.add(MenuAdded(groupName: group.name, addRoute: selectedRoute));
    }
  }

  /// Phần menu chính gồm 4 tính năng cơ bản nằm ở phía trên trang
  Widget _buildMainMenu(HomeMenuConfig config) {
    return _MenuItemContainer(
      children: config.mainMenus.map(
        (String route) {
          final menu = getMenuByRoute(route);
          if (menu != null) {
            return MainMenuWidget(
              name: menu.name(),
              icon: menu.icon,
              gradient: menu.gradient,
              onPressed: () {
                if (menu.onPressed != null) {
                  menu.onPressed(context);
                } else {
                  Navigator.pushNamed(context, menu.route);
                }
              },
            );
          }
          return const MainMenuWidget();
        },
      ).toList(),
    );
  }

  /// Tùy chỉnh, Người dùng tùy chỉnh, Đồng ý tùy chỉnh...
  Widget _buildButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 0),
      child: Row(
        children: <Widget>[
          const Spacer(),
          if (_menuType == MenuType.custom)
            _MenuOptionButton(
              title: _reorderEnable ? "Sắp xếp xong" : "Sắp xếp",
              isReorder: _canReorder,
              onPressed: () {
                setState(() {
                  _reorderEnable = !_reorderEnable;
                });
              },
            ),
          _MenuShowAllButton(
            title: _menuType.description,
            onPressed: () {
              _menuType =
                  _menuType == MenuType.custom ? MenuType.all : MenuType.custom;
              _menuBloc.add(
                MenuTypeChanged(_menuType),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Nút cá nhân, tùy chỉnh sử dụng cupertino
  Widget _buildButton2() {
    return SizedBox(
      width: double.infinity,
      child: CupertinoSegmentedControl(
        groupValue: '1',
        padding: EdgeInsets.all(16),
        onValueChanged: (value) {},
        children: {
          "1": Padding(
            padding: EdgeInsets.all(8),
            child: const Text('Tất cả'),
          ),
          "2": Padding(
            padding: EdgeInsets.all(8),
            child: const Text('Cá nhân'),
          ),
        },
      ),
    );
  }

  /// Hiển thị menu do người dùng tự định nghĩa
  Widget _buildCustomMenu(HomeMenuConfig config, MenuType type) {
    final List<Widget> menuGroupWidget = <Widget>[
      ...config.menuGroups.map((group) {
        return NormalMenuItemWrap(
          maxLine: group.maxLine,
          reorderEnable: _canReorder,
          onReorder: (p1, p2) {
            _menuBloc.add(
                MenuReorder(oldIndex: p1, newIndex: p2, groupName: group.name));
          },
          title: Text(
            type == MenuType.all ? group.menuGroupType.description : group.name,
            style: TextStyle(
              color: group.color?.toColor()?.textColor() ??
                  Colors.grey?.textColor(),
            ),
          ),
          background: group.color?.toColor() ?? Colors.grey,
          children: group.children.map((menuRoute) {
            final menu = getMenuByRoute(menuRoute);

            if (menu != null) {
              final bool isPermission = checkPermission(menuRoute);
              return NormalMenuItem(
                name: menu.name(),
                tooltip: menu.tooltip,
                icon: menu.icon,
                canDelete: _canReorder,
                hasPermission: isPermission,
                onPressed: _canReorder
                    ? null
                    : () {
                        Navigator.pushNamed(context, menu.route);
                      },
                onDeleted: () {
                  _menuBloc.add(
                      MenuDeleted(groupName: group.name, menuRoute: menuRoute));
                },
              );
            }
            return NormalMenuItem(
              canDelete: _canReorder,
              hasPermission: false,
            );
          }).toList(),
          onAddPressed: () {
            // Add item to menu
            // Open menu select page
            _showAddMenuItem(group);
          },
          onUpPressed: () {
            _menuBloc
                .add(MenuGroupReOrdered(groupName: group.name, isUp: true));
          },
          onDownPressed: () {
            _menuBloc
                .add(MenuGroupReOrdered(groupName: group.name, isUp: false));
          },
          onDeleted: () {
            _menuBloc.add(MenuGroupDeleted(groupName: group.name));
          },
          onTitlePressed: () {
            _handleRenameGroup(group, context);
          },
        );
      }).toList()
        ..removeWhere((element) => !_canReorder && element.children.isEmpty),
      if (_canReorder)
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: RaisedButton(
            color: AppColors.brand4,
            textColor: Colors.white,
            child: const Text('Thêm nhóm mới'),
            onPressed: () {
              _menuBloc.add(MenuGroupAdded());
            },
          ),
        ),
      if (_canReorder)
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: OutlineButton(
            color: AppColors.brand4,
            textColor: AppColors.brand3,
            child: const Text('Khôi phục mặc định'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AppAlertDialog(
                  type: AlertDialogType.warning,
                  title: const Text('Bạn có muốn khôi phục mặc định?'),
                  content: const Text(
                    "Menu tùy chọn sẽ được khôi phục về trạng thái như lúc mới cài ứng dụng.",
                  ),
                  actions: <Widget>[
                    ActionButton(
                      child: const Text('Hủy bỏ'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: AppColors.dialogCancelColor,
                    ),
                    ActionButton(
                      child: const Text('Đồng ý'),
                      onPressed: () {
                        _menuBloc.add(MenuRestoreDefault());
                        Navigator.pop(context);
                      },
                      color: AppColors.dialogWarningColor,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
    ];

    return ListView(
      padding: const EdgeInsets.only(top: 8),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: menuGroupWidget,
    );
  }

  Widget _buildNotifyMenu() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (last, current) =>
                current is HomeLoadSuccess || current is HomeLoadFailure,
            builder: (context, state) {
              if (state is HomeLoadSuccess && state.isExprired == true) {
                return MenuAlertExpired(
                  expiredDay: state.expriredTime,
                );
              } else if (state is HomeLoadFailure) {
                return MenuAlertLoadingFailure(
                  message: state.message,
                  onReload: () {
                    BlocProvider.of<HomeBloc>(context).add(
                      HomeLoaded(),
                    );
                  },
                );
              } else {
                return const SizedBox();
              }
            }),
      ],
    );
  }
}

class _MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

/// Bọc bên ngoài các [menu item] trong một nhóm. VÍ dụ các menu bên trong 'Bán hàng online' ' Bán hàng nhanh" mà ko có tiêu đề
class _MenuItemContainer extends StatelessWidget {
  const _MenuItemContainer({Key key, this.children = const [], this.title})
      : super(key: key);
  final List<Widget> children;
  final Text title;

  Widget get container => Container(
        margin: const EdgeInsets.only(left: 16, right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children
              .map((e) => Expanded(
                    child: e,
                  ))
              .toList(),
        ),
      );
  @override
  Widget build(BuildContext context) {
    if (title != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 12),
            child: DecoratedBox(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                child: title,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.green,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          container,
          const SizedBox(
            height: 10,
          ),
        ],
      );
    }

    return container;
  }
}

class _MenuShowAllButton extends StatelessWidget {
  const _MenuShowAllButton({Key key, this.title, this.onPressed})
      : super(key: key);
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            InkWell(
              onTap: onPressed,
              child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xFFDCE2E5),
                    borderRadius: BorderRadius.circular(16)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                margin: const EdgeInsets.only(left: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(title,
                        style: const TextStyle(
                            color: Color(0xFF657088), fontSize: 13)),
                    const SizedBox(
                      width: 4,
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 17,
                      color: const Color(0xFF929DAA),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

class _MenuOptionButton extends StatelessWidget {
  const _MenuOptionButton(
      {Key key, this.onPressed, this.title, this.isReorder = false})
      : super(key: key);
  final VoidCallback onPressed;
  final String title;
  final bool isReorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          InkWell(
            onTap: onPressed,
            child: Container(
              decoration: BoxDecoration(
                  color: isReorder ? Colors.green : const Color(0xFFDCE2E5),
                  borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(right: 12),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.edit,
                    size: 16,
                    color: isReorder ? Colors.white : const Color(0xFF929DAA),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    title,
                    style: isReorder
                        ? const TextStyle(color: Colors.white, fontSize: 15)
                        : const TextStyle(
                            color: Color(0xFF657088), fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
