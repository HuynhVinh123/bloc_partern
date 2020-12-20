import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tpos_mobile/helpers/svg_icon.dart';
import 'package:tpos_mobile/widgets/button/action_button.dart';
import 'package:tpos_mobile/widgets/button/page_state_action_button.dart';
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

  /// UI thông báo trong danh sách khách hàng rằng không có khách hàng nào. Bạn cần phải thêm khách hàng mới vào danh sách
  factory PageState.emptyCustomer({
    String title,
    String message,
    Widget icon,
    List<Widget> actions,
    VoidCallback onRefreshButtonPressed,
    VoidCallback onFilterButtonPressed,
    VoidCallback onResetFilterPressed,
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

    return PageState(
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
