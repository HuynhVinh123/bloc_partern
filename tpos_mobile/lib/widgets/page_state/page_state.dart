import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tmt_flutter_ui/tmt_flutter_ui.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';
import 'package:tpos_mobile/helpers/svg_icon.dart';
import 'package:tpos_mobile/widgets/page_state/page_state_type.dart';

/// Cung cấp 1 UI thông báo trạng thái trên màn hình của ứng dụng. Ví dụ như thông báo lỗi, thông báo không có dữ liệu
class AppPageState extends StatelessWidget {
  const AppPageState(
      {Key key,
      this.title,
      this.message,
      this.icon,
      this.type = PageStateType.listEmpty,
      this.actions,
      this.hint})
      : super(key: key);

  /// Cung cấp một UI thông báo trạng thái lỗi trên màn hình ứng dụng.
  factory AppPageState.dataError({
    String title,
    String message,
    Widget icon,
    List<Widget> actions,
  }) {
    return AppPageState(
      type: PageStateType.dataError,
      title: title,
      message: message,
      icon: icon,
      actions: actions,
    );
  }

  /// UI thông báo trong danh sách khách hàng rằng không có khách hàng nào. Bạn cần phải thêm khách hàng mới vào danh sách
  factory AppPageState.emptyCustomer({
    String title,
    String message,
    Widget icon,
    List<Widget> actions,
    VoidCallback onRefreshButtonPressed,
  }) {
    Widget _buildIcon() {
      if (icon != null) {
        return icon;
      }
      return const SvgIcon(
        SvgIcon.emptyCustomer,
      );
    }

    List<Widget> _buildAction() {
      return [
        if (onRefreshButtonPressed != null)
          PageStateActionButton(
            child: const Text("Tải lại trang"),
            onPressed: onRefreshButtonPressed,
          ),
      ];
    }

    return AppPageState(
      title: title ?? 'Chưa có khách hàng!',
      icon: _buildIcon(),
      message: message,
      actions: actions ?? _buildAction(),
    );
  }
  final String title;
  final String message;
  final Widget icon;
  final PageStateType type;
  final List<Widget> actions;
  final String hint;

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
              child: Text(title ?? type.title),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            DefaultTextStyle(
              style: TextStyle(fontSize: 14, color: type.contentColor),
              child: Text(message ?? type.message),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            if (hint.isNotNullOrEmpty())
              DefaultTextStyle(
                style: const TextStyle(fontSize: 14, color: Colors.green),
                child: Text(hint ?? ''),
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
