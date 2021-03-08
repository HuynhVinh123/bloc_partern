import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_mobile/application/menu/drawer_menu.dart';
import 'package:tpos_mobile/application/menu/menu_search_page.dart';
import 'package:tpos_mobile/application/menu_v2/favorite_menu_card.dart';
import 'package:tpos_mobile/application/menu_v2/favorite_menu_container.dart';
import 'package:tpos_mobile/resources/app_route.dart';
import 'package:tpos_mobile/resources/menus.dart';
import 'package:tpos_mobile/services/config_service/shop_config_service.dart';
import 'package:tpos_mobile/widgets/background/app_bar_clip_shape.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import 'all_menu.dart';
import 'favorite_menu_cutomize_page.dart';
import 'favorite_menu_item.dart';

class MenuV2Page extends StatefulWidget {
  @override
  _MenuV2PageState createState() => _MenuV2PageState();
}

class _MenuV2PageState extends State<MenuV2Page> {
  final GlobalKey key = GlobalKey();
  Key reloadKey = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      drawer: DrawerMenu(),
      body: Stack(
        fit: StackFit.passthrough,
        children: [
          Container(
            child: AppbarClipShape(),
          ),
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 20,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Column(
              children: [
                _buildAppBarContent(),
                const SizedBox(
                  height: 20,
                ),
                _buildFavoriteMenu(),
              ],
            ),
          ),
          AllMenu(),
        ],
      ),
    );
  }

  /// Chức năng yêu thích
  Widget _buildFavoriteMenu() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
      child: FavoriteMenuCard(
        child: FavoriteMenuWrapper(
          key: reloadKey,
          onChanged: () {
            reloadKey = UniqueKey();
            WidgetsBinding.instance.addPostFrameCallback((a) {
              setState(() {});
            });
          },
          title: S.current.favoriteMenu.toUpperCase(),
          child: const _FavoriteMenuSwipper(),
        ),
      ),
    );
  }

  Widget _buildAppBarContent() {
    return SafeArea(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 10),
            child: Builder(builder: (context) {
              return Material(
                borderRadius: BorderRadius.circular(30),
                color: const Color(0xff409249),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: InkWell(
                    child: const Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
              );
            }),
          ),
          Expanded(
            child: InkWell(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MenuSearchPage();
                    },
                  ),
                );
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      width: 12,
                    ),
                    const Icon(
                      Icons.search,
                      size: 21,
                      color: Colors.white70,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        S.current.menu_search,
                        style: const TextStyle(color: Colors.white54),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              width: 40,
              height: 40,
              child: CircleAvatar(
                backgroundColor: const Color(0xff75CC57),
                child: SvgPicture.asset(
                  "assets/svg/user-multicolor.svg",
                  color: const Color(0xffC5F4B2),
                ),
              ),
            ),
            onTap: () async =>
                await Navigator.pushNamed(context, AppRoute.changeCompany),
          ),
        ],
      ),
    );
  }
}

/// Chứa nhiều trang menu có thể swipe qua lại
class _FavoriteMenuSwipper extends StatefulWidget {
  /// Tạo một UI menu mà nội dung bên trong có thể slide qua lại
  const _FavoriteMenuSwipper({Key key, this.onMenuChanged}) : super(key: key);
  final VoidCallback onMenuChanged;

  @override
  __FavoriteMenuSwipperState createState() => __FavoriteMenuSwipperState();
}

class __FavoriteMenuSwipperState extends State<_FavoriteMenuSwipper> {
  double height;
  GlobalKey key = GlobalKey();
  final ShopConfigService _shopConfig = GetIt.I<ShopConfigService>();

  void _afterLayout(_) {
    final RenderBox renderBoxRed = key.currentContext.findRenderObject();
    final sizeRed = renderBoxRed.size;
    setState(() {
      height = sizeRed.height;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final menu = _shopConfig.favoriteMenu;

    final List<FavoriteMenuItem> items = <FavoriteMenuItem>[];
    for (final route in menu.routes) {
      final menu = getMenuByRoute(route);
      if (menu != null) {
        final menuItem = FavoriteMenuItem(
          icon: menu.icon,
          title: menu.name(),
          gradient: menu.type.linearGradient,
          badge: menu.badge,
          onPressed: () {
            if (menu.onPressed != null) {
              menu.onPressed(context);
            } else {
              Navigator.pushNamed(context, menu.route);
            }
          },
        );

        items.add(menuItem);
      }
    }

    Widget _firstWidget;

    return LayoutBuilder(builder: (context, cs) {
      final List<FavoriteMenuContainer> pages = [];
      final screenSize = cs.maxWidth;
      final double maxExtent = screenSize > 720 ? 100 : 80;
      final int column = screenSize ~/ maxExtent;
      final maxValue = column * 2;

      for (var i = 0; i < items.length; i += maxValue) {
        final end = (i + maxValue < items.length) ? i + maxValue : items.length;
        final group = items.sublist(i, end);
        pages.add(
          FavoriteMenuContainer(
            items: group,
            column: column,
          ),
        );
        if (group == null || group.isEmpty) {
          continue;
        }
      }

      final Widget swiper = LayoutBuilder(builder: (context, cs) {
        return Swiper.children(
          outer: true,
          loop: false,
          pagination: const SwiperPagination(
            builder: DotSwiperPaginationBuilder(
              color: Color(
                0xffD5DAE2,
              ),
              activeColor: Color(0xff858F9B),
            ),
          ),
          children: pages,
        );
      });

      if (height == null) {
        _firstWidget = Container();
      } else {
        _firstWidget = Container(
          height: height + 40,
          child: swiper,
        );
      }
      return IndexedStack(
        key: key,
        children: [
          _firstWidget,
          ...pages,
        ],
      );
    });
  }
}

/// Bao bọc [child] bằng một container có tiêu đề và nút tùy chỉnh
class FavoriteMenuWrapper extends StatelessWidget {
  /// Tạo một UI bọc [child] bằng một container có thể tùy chỉnh tiêu đề và có sẵn một nút nhấn cố định bên phải tiêu đề
  const FavoriteMenuWrapper({
    Key key,
    this.title,
    this.child,
    this.onChanged,
  }) : super(key: key);
  final String title;
  final Widget child;
  final VoidCallback onChanged;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            top: 8,
            right: 16,
            bottom: 8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xff6B7280),
                    fontSize: 14,
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return FavoriteMenuCustomizePage();
                  }));
                  onChanged?.call();
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      color: const Color(0xffE9EDF2),
                    ),
                  ),
                  child: const SizedBox(
                    height: 36,
                    width: 36,
                    child: Icon(
                      Icons.tune,
                      color: Color(
                        0xff858F9B,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        child,
      ],
    );
  }
}
