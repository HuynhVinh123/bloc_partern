import 'package:flutter/material.dart';
import 'package:tpos_mobile/resources/menus.dart';

/// CHọn nhiều menu để thêm vào danh sách
class MenuMultiSelectPage extends StatefulWidget {
  const MenuMultiSelectPage({Key key, this.oldSelectedItem = const []})
      : super(key: key);
  final List<String> oldSelectedItem;

  @override
  _MenuMultiSelectPageState createState() => _MenuMultiSelectPageState();
}

class _MenuMultiSelectPageState extends State<MenuMultiSelectPage> {
  final menu = applicationMenu;
  List<String> _selectedItems;
  @override
  void initState() {
    _selectedItems = <String>[];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: const <Widget>[
                Expanded(
                  child: Text(
                    "Thêm chức năng vào nhóm",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                CloseButton(),
              ],
            ),
            const Text('Chọn một hoặc nhiều tính năng để thêm vào nhóm '),
            Expanded(
              child: _buildMenu(),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: const Color(0xffF0F1F3),
                      textColor: Colors.black87,
                      child: const Text('Hủy'),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: RaisedButton(
                      color: const Color(0xff28A745),
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.pop(context, _selectedItems);
                      },
                      child: const Text('Hoàn tất'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenu() {
    return ListView(
        children: MenuGroupType.values
            .map(
              (e) => _GroupListMenuContainer(
                type: e,
                title: Text(
                  e.description,
                  style: TextStyle(
                    color: e.backgroundColor.computeLuminance() > 0.5
                        ? Colors.black87
                        : Colors.white70,
                  ),
                ),
                background: e.backgroundColor,
                selectedItems: _selectedItems,
                oldSelectedItems: widget.oldSelectedItem,
                onChanged: (value, route) {
                  if (value) {
                    if (!_selectedItems.any((element) => element == route)) {
                      _selectedItems.add(route);
                    }
                  } else {
                    if (_selectedItems.any((element) => element == route)) {
                      _selectedItems.remove(route);
                    }
                  }
                  setState(() {});
                },
              ),
            )
            .toList());
  }
}

class _GroupListMenuContainer extends StatelessWidget {
  const _GroupListMenuContainer({
    Key key,
    this.title,
    this.background,
    this.type,
    this.selectedItems,
    this.onChanged,
    this.oldSelectedItems,
  }) : super(key: key);
  final Widget title;
  final Color background;
  final MenuGroupType type;
  final List<String> selectedItems;
  final List<String> oldSelectedItems;
  final Function(bool value, String route) onChanged;

  @override
  Widget build(BuildContext context) {
    final List<MenuItem> menus =
        applicationMenu.where((element) => element.type == type).toList();
    return Container(
      child: Column(
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
                color: background,
              ),
            ),
          ),
          Column(
            children: menus
                .map(
                  (e) => _CheckItem(
                      title: e.name(),
                      canCheck: !oldSelectedItems
                          .any((element) => element == e.route),
                      isChecked:
                          selectedItems.any((element) => element == e.route),
                      onValueChanged: (value) {
                        onChanged(value, e.route);
                      }),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _CheckItem extends StatelessWidget {
  const _CheckItem(
      {Key key,
      @required this.isChecked,
      @required this.title,
      this.onValueChanged,
      this.canCheck})
      : assert(isChecked != null),
        assert(title != null),
        super(key: key);
  final bool isChecked;
  final bool canCheck;
  final String title;
  final ValueChanged<bool> onValueChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (canCheck)
          Checkbox(
            value: isChecked,
            onChanged: onValueChanged,
          )
        else
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              Icons.check_box,
              color: Colors.grey.shade300,
            ),
          ),
        Text(title),
      ],
    );
  }
}
