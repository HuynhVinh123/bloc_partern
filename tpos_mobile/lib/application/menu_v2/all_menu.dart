import 'package:flutter/material.dart';
import 'package:tmt_flutter_untils/tmt_flutter_utils.dart';
import 'package:tpos_mobile/application/menu_v2/all_menu_item.dart';
import 'package:tpos_mobile/resources/menus.dart';

/// All Menu tab
class AllMenu extends StatefulWidget {
  @override
  _AllMenuState createState() => _AllMenuState();
}

class _AllMenuGroupModel {
  _AllMenuGroupModel({this.group, this.items = const <MenuItem>[]});
  MenuGroupType group;
  List<MenuItem> items;
}

class _AllMenuState extends State<AllMenu> with TickerProviderStateMixin {
  int tabLength = 0;
  int tabIndex = 0;
  TabController _tabController;

  final List<_AllMenuGroupModel> _menuGroups = <_AllMenuGroupModel>[];

  void _refreshMenu() {
    final homeMenuConfig = homeMenuAll();
    for (final group in homeMenuConfig.menuGroups) {
      final type = group.menuGroupType;
      final _AllMenuGroupModel model = _AllMenuGroupModel(group: type, items: <MenuItem>[]);

      for (final route in group.children) {
        final menu = getMenuByRouteWithPermission(route);
        if (menu != null) {
          model.items.add(menu);
        }
      }

      if (model.items.isNotEmpty) {
        _menuGroups.add(model);
      }
    }
  }

  double height;
  GlobalKey key = GlobalKey();

  void _afterLayout(_) {
    final RenderBox renderBoxRed = key.currentContext.findRenderObject();
    final sizeRed = renderBoxRed.size;
    setState(() {
      height = sizeRed.height;
    });
  }

  @override
  void initState() {
    // Load menu
    _refreshMenu();
    _tabController = TabController(length: _menuGroups.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        tabIndex = _tabController.index;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: DefaultTabController(
        length: _menuGroups.length,
        initialIndex: 0,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                  isScrollable: true,
                  indicatorPadding: const EdgeInsets.all(0),
                  indicatorWeight: 0,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Colors.red,
                  labelPadding: const EdgeInsets.only(left: 0, right: 5),
                  labelColor: Colors.white,
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    // color: _menuGroups[tabIndex].group.backgroundColor,
                  ),
                  onTap: (value) {
                    setState(() {
                      tabIndex = value;
                    });
                  },
                  tabs: _menuGroups.map((e) {
                    final tabColor =
                        tabIndex == _menuGroups.indexOf(e) ? e.group.backgroundColor : const Color(0xffF2F3F4);

                    final textColor = tabIndex == _menuGroups.indexOf(e) ? e.group.textColor : const Color(0xff8A96A3);
                    return Tab(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            24,
                          ),
                          color: tabColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            e.group.description,
                            style: TextStyle(color: textColor),
                          ),
                        ),
                      ),
                    );
                  }).toList()),
              const SizedBox(
                height: 10,
              ),
              Builder(builder: (context) {
                Widget _firstWidget;

                final List<Widget> tabPages = <Widget>[];
                for (final itm in _menuGroups) {
                  tabPages.add(
                    _AllMenuItemContainer(
                      items: itm.items
                          .map(
                            (e) => AllMenuItem(
                              icon: IconTheme(
                                child: e.icon,
                                data: IconThemeData(
                                  color: e.type.backgroundColor,
                                  size: context.isTablet ? 30 : 30,
                                ),
                              ),
                              title: e.name(),
                              onPressed: () {
                                e.onPressed?.call(context);
                                if (e.onPressed == null) {
                                  Navigator.pushNamed(context, e.route);
                                }
                              },
                            ),
                          )
                          .toList(),
                    ),
                  );
                }

                final tabBarView = TabBarView(
                  children: tabPages,
                  controller: _tabController,
                );

                if (height == null) {
                  _firstWidget = Container();
                } else {
                  _firstWidget = Container(
                    height: height,
                    child: tabBarView,
                  );
                }

                return IndexedStack(
                  key: key,
                  children: [
                    _firstWidget,
                    ...tabPages,
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _AllMenuItemContainer extends StatelessWidget {
  const _AllMenuItemContainer({Key key, this.items}) : super(key: key);
  final List<AllMenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(
        builder: (context, cs) {
          return GridView.extent(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            maxCrossAxisExtent: 100,
            children: items
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.all(4),
                    child: e,
                  ),
                )
                .toList(),
          );

          // return Wrap(
          //   runSpacing: 10,
          //   spacing: 10,
          //   children: items
          //       .map(
          //         (e) => SizedBox(
          //           width: itemSize,
          //           height: itemSize + 5,
          //           child: e,
          //         ),
          //       )
          //       .toList(),
          // );
        },
      ),
    );
  }
}
