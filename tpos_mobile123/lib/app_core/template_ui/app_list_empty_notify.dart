import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

///Hiện thông báo khi danh sách không có dữ liệu (Items==null or length =0)
class AppListEmptyNotify extends StatelessWidget {
  final Widget icon;
  final Widget title;
  final Widget message;
  final List<Widget> actions;

  final defaultColor = Colors.grey;

  AppListEmptyNotify({
    this.icon,
    this.title = const Text(
      "Không có dữ liệu!",
      style: const TextStyle(
          color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
    ),
    this.message,
    this.actions = const <Widget>[],
  });
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
            title,
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
  final String title;
  final String message;
  final VoidCallback onRefresh;
  AppListEmptyNotifyDefault(
      {this.title = "Không có dữ liệu", this.message = "", this.onRefresh});

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
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )
          : null,
      message: message != null ? Text(message) : null,
      actions: <Widget>[
        RaisedButton.icon(
          textColor: Colors.white,
          label: Text("Tải lại"),
          icon: Icon(
            Icons.refresh,
          ),
          onPressed: onRefresh,
        )
      ],
    );
  }
}
