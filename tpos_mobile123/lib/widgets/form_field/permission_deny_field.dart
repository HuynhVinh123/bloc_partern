import 'package:flutter/material.dart';

/// Widget dùng cho các TextFied nhập mà không có quyền xem hoặc chỉnh sửa
class PermissionDenyField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
      child: Material(
        color: Colors.orange.shade100,
        child: const Text(
          'Không có quyền xem',
          textAlign: TextAlign.right,
        ),
      ),
    );
  }
}
