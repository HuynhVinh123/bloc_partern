import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';

/// Khung bao điều kiện lọc dùng chung
/// Khung áp dụng cho endDrawer có sẵn tiêu đề, nút đóng lại, Nút thiết lập lại và Áp dụng điều kiện
class AppFilterDrawerContainer extends StatelessWidget {
  const AppFilterDrawerContainer({
    this.onApply,
    this.onRefresh,
    Key key,
    this.child,
    this.bottomContent,
    this.closeWhenConfirm = false,
  }) : super(key: key);
  final VoidCallback onApply;
  final VoidCallback onRefresh;
  final Widget child;
  final bool closeWhenConfirm;
  final Widget bottomContent;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.all(5),
              child: SafeArea(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          S.current.filter.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      child: const Padding(
                        padding: EdgeInsets.all(3),
                        child: Icon(Icons.close, color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: child ?? const SizedBox(),
            ),
            bottomContent ?? const SizedBox(),
            Container(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: OutlineButton.icon(
                      textColor: Theme.of(context).primaryColor,
                      color: Colors.white,
                      onPressed: onRefresh,
                      icon: const Icon(Icons.refresh),
                      label: Text(S.current.reset),
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                            width: 1, color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: RaisedButton.icon(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () {
                        onApply();
                        if (closeWhenConfirm) {
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(Icons.check),
                      label: Text(S.current.apply),
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                            width: 1, color: Theme.of(context).primaryColor),
                      ),
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
}

///  Khung điều kiện lọc phía trên danh sách dùng để chứa cáo điều kiện lọc
class AppFilterListHeader extends StatelessWidget {
  const AppFilterListHeader({this.height = 40, this.children});
  final double height;
  final List<AppFilterListHeaderItem> children;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: Colors.grey, width: 0.5),
            color: Colors.grey.shade100,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: children != null
                      ? children
                          .map(
                            (f) => Padding(
                              padding: const EdgeInsets.only(left: 3),
                              child: f,
                            ),
                          )
                          .toList()
                      : <AppFilterListHeaderItem>[],
                ),
              ),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Badge(
                    child: const Icon(Icons.filter_list),
                    badgeContent: const Text("0"),
                  ),
                ),
                onTap: () {
                  Scaffold.of(context).openEndDrawer();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Một điều kiện lọc áp dụng cho FilterListHeader
/// Một điều kiện lọc có 2 trạng thái. Có dữ liệu và không có dữ liệu. Khi không có sẽ hiện nội dung gợi ý "hint"
class AppFilterListHeaderItem extends StatelessWidget {
  const AppFilterListHeaderItem({this.value, this.hint = "", this.onPressed});
  final String value;
  final String hint;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: value != null ? Colors.green : Colors.grey.shade100,
      textColor: value != null ? Colors.white : Colors.grey,
      onPressed: onPressed,
      child: Text(value ?? hint ?? ""),
    );
  }
}
