import 'package:flutter/material.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/resources/menus.dart';
import 'package:tpos_mobile/services/config_service/config_model/home_menu_config.dart';
import 'package:tpos_mobile/widgets/language_button.dart';
import 'package:tpos_mobile/widgets/tpos_logo.dart';

class DrawerMenu extends StatefulWidget {
  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              left: true,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const TPosLogo(
                      width: 150,
                    ),
                    const Spacer(),
                    CloseButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            Expanded(child: _buildList(drawerMenu().menuGroups)),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    SelectLanguageButton(
                      onChanged: () {
                        setState(() {});
                      },
                    ),
                    const Spacer(),
                    Text('Version: ${App.appVersion}'),
                    const SizedBox(
                      width: 12,
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<HomeMenuConfigGroup> groups) {
    return ListView.builder(
        itemCount: groups.length,
        shrinkWrap: false,
        itemBuilder: (context, index) => _buildGroup(context, groups[index]));
  }

  Widget _buildGroup(BuildContext context, HomeMenuConfigGroup group) {
    return ExpansionTile(
      title: Text(
        group.menuGroupType.description,
        style: const TextStyle(fontSize: 15),
      ),
      children: group.children.map((String menuRoute) {
        final MenuItem menuItem = getMenuByRouteWithPermission(menuRoute);
        if (menuItem != null) {
          return _buildItem(context, menuItem);
        } else {
          return const SizedBox();
        }
      }).toList(),
    );
  }

  Widget _buildItem(BuildContext context, MenuItem item) {
    return ListTile(
      leading: item.icon,
      title: Text(
        item.name(),
      ),
      onTap: () {
        if (item.onPressed != null) {
          item.onPressed(context);
        } else {
          Navigator.of(context).pushNamed(item.route);
        }
      },
    );
  }
}
