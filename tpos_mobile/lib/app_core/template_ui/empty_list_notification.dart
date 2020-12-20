import 'package:flutter/material.dart';

class AppEmptyList extends StatelessWidget {
  final Widget icon;
  final String title;
  final String message;
  final VoidCallback onReloadPressed;
  final VoidCallback onRefillterPressed;
  const AppEmptyList(
      {this.icon,
      this.title,
      this.message,
      this.onRefillterPressed,
      this.onReloadPressed});

  @override
  Widget build(BuildContext context) {
    final icon = this.icon ??
        Icon(
          Icons.info_outline,
          size: 60,
          color: Colors.grey.shade200,
        );

    final title = Text(
      this.title ?? "Không có dữ liệu",
      style: const TextStyle(fontWeight: FontWeight.bold),
    );

    final message = Text(this.message ??
        "Không có dữ liệu nào, Thử tải lại danh sách hoặc nhấn + để thêm mới");
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            icon,
            const SizedBox(
              height: 20,
            ),
            title,
            const SizedBox(height: 20),
            message,
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton.icon(
                    icon: Icon(Icons.refresh),
                    label: Text("Tải lại"),
                    textColor: Colors.blue,
                    onPressed: onReloadPressed,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FlatButton.icon(
                    icon: Icon(Icons.filter_list),
                    label: Text("Lọc"),
                    textColor: Colors.blue,
                    onPressed: onRefillterPressed,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
