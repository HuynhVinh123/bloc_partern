import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';

/// Khung bao điều kiện lọc dùng chung
/// Khung áp dụng cho endDrawer có sẵn tiêu đề, nút đóng lại, Nút thiết lập lại và Áp dụng điều kiện
class AppFilterDrawerContainer extends StatefulWidget {
  const AppFilterDrawerContainer(
      {this.onApply,
      this.onRefresh,
      Key key,
      this.child,
      this.bottomContent,
      this.closeWhenConfirm = false,
      this.countFilter = 0,
      this.colorHeaderDrawer,
      @Deprecated("Không được dùng biến này nữa. Tương lai sẽ bị loại bỏ do vi phạm luật sử dụng bởi hauddt")
          //TODO(namnv): Bỏ biến [isDrawerConversation]
          this.isDrawerConversation = false,
      this.stream,
      this.onClosed})
      : super(key: key);
  final VoidCallback onApply;
  final VoidCallback onRefresh;
  final Widget child;
  final bool closeWhenConfirm;
  final Widget bottomContent;
  final int countFilter;
  final Color colorHeaderDrawer;
  @Deprecated(
      "Không được dùng biến này nữa. Tương lai sẽ bị loại bỏ do vi phạm luật sử dụng bởi hauddt")
  final bool isDrawerConversation;
  final Stream<int> stream;
  final VoidCallback onClosed;

  @override
  _AppFilterDrawerContainerState createState() =>
      _AppFilterDrawerContainerState();
}

class _AppFilterDrawerContainerState extends State<AppFilterDrawerContainer> {
  @override
  void dispose() {
    widget.onClosed?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: widget.colorHeaderDrawer ?? Theme.of(context).primaryColor,
              padding: const EdgeInsets.all(5),
              child: SafeArea(
                child: Row(
                  children: <Widget>[
                    if (!widget.isDrawerConversation)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                // ignore: unnecessary_string_interpolations
                                '${S.current.filterTerms}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 14),
                                child: Container(
                                  height: 23,
                                  width: 33,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13.0),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                      child: Text(
                                    widget.countFilter.toString(),
                                    style: const TextStyle(
                                        color: Color(0xFF008E30)),
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            // ignore: unnecessary_string_interpolations
                            'Tùy chọn',
                            style: TextStyle(
                              color: Color(0xFF2C333A),
                              fontSize: 21,
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
              child: widget.child ?? const SizedBox(),
            ),
            widget.bottomContent ?? const SizedBox(),
            Container(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      onPressed: () {
                        widget.onRefresh();
                        if (widget.closeWhenConfirm) {
                          Navigator.pop(context);
                        }
                      },
                      color: const Color(0xFFF0F1F3),
                      textColor: const Color(0xFF2C333A),
                      // ignore: unnecessary_string_interpolations
                      child: Text('${S.current.reset}',
                          style: const TextStyle(fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      onPressed: () {
                        widget.onApply();
                        if (widget.closeWhenConfirm) {
                          Navigator.pop(context);
                        }
                      },
                      color: const Color(0xFF28A745),
                      textColor: const Color(0xFF2C333A),
                      child: Text('${S.current.apply} (${widget.countFilter})',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white)),
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
