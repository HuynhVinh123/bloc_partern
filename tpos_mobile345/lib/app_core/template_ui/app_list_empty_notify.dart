import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';

///Hiện thông báo khi danh sách không có dữ liệu (Items==null or length =0)
class AppListEmptyNotify extends StatelessWidget {
  AppListEmptyNotify({
    this.icon,
    this.title,
    this.message,
    this.actions = const <Widget>[],
  });
  final Widget icon;
  final Widget title;
  final Widget message;
  final List<Widget> actions;

  final defaultColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            icon ??
                Icon(
                  FontAwesomeIcons.box,
                  color: Colors.grey.shade200,
                  size: 60,
                ),
            const SizedBox(
              height: 20,
            ),
            title ??
                Text(
                  S.current.notify_NoDataTitle,
                  style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
            const SizedBox(
              height: 20,
            ),
            message,
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: actions,
            ),
          ],
        ),
      ),
    );
  }
}

///Thông báo trong list không có dữ liệu mặc định dựa trên AppListEmptyNotify
///Gồm 1 Icon, Tiêu đề, thông tin và action tải lại
class AppListEmptyNotifyDefault extends StatelessWidget {
  const AppListEmptyNotifyDefault(
      {this.title, this.message = "", this.onRefresh});
  final String title;
  final String message;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return AppListEmptyNotify(
      icon: Icon(
        FontAwesomeIcons.box,
        size: 60,
        color: Colors.grey.shade300,
      ),
      title: title != null
          ? Text(
              title ?? S.current.notify_NoDataTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )
          : null,
      message: message != null ? Text(message) : null,
      actions: <Widget>[
        RaisedButton.icon(
          textColor: Colors.white,
          label: Text(S.current.refresh),
          icon: const Icon(
            Icons.refresh,
          ),
          onPressed: onRefresh,
        )
      ],
    );
  }
}
