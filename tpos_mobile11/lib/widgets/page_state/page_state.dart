import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tpos_mobile/widgets/page_state/page_state_type.dart';

/// Cung cấp 1 UI thông báo trạng thái trên màn hình của ứng dụng. Ví dụ như thông báo lỗi, thông báo không có dữ liệu
class PageState extends StatelessWidget {
  const PageState(
      {Key key,
      this.title,
      this.message,
      this.icon,
      this.type = PageStateType.listEmpty,
      this.actions})
      : super(key: key);

  /// Cung cấp một UI thông báo trạng thái lỗi trên màn hình ứng dụng.
  factory PageState.dataError({
    String title,
    String message,
    Widget icon,
    List<Widget> actions,
  }) {
    return PageState(
      type: PageStateType.dataError,
      title: title,
      message: message,
      icon: icon,
      actions: actions,
    );
  }
  final String title;
  final String message;
  final Widget icon;
  final PageStateType type;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon ?? type.icon,
            const SizedBox(
              height: 16,
            ),
            DefaultTextStyle(
              style: const TextStyle(fontSize: 20, color: Colors.black87),
              child: Text(type.title),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            DefaultTextStyle(
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              child: Text(message ?? type.message),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            if (actions != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: actions,
              ),
          ],
        ),
      ),
    );
  }
}
