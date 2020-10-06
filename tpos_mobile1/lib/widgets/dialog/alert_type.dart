import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tpos_mobile/widgets/button/action_button.dart';

import '../../resources/app_colors.dart';

enum AlertDialogType {
  info,
  error,
  success,
  warning,
}

extension AlertDialogTypeExtensions on AlertDialogType {
  String get describe => describeEnum(this);
  String get defaultTitle {
    switch (this) {
      case AlertDialogType.info:
        return 'Thông tin!';
      case AlertDialogType.error:
        return 'Thông báo lỗi!';
      case AlertDialogType.success:
        return 'Thành công!';
      case AlertDialogType.warning:
        return 'Cảnh báo!';
      default:
        return 'N/A';
    }
  }

  Color get backgroundColor {
    switch (this) {
      case AlertDialogType.info:
        return AppColors.dialogInfoColor.withOpacity(0.1);
      case AlertDialogType.error:
        return AppColors.dialogErrorColor.withOpacity(0.1);

      case AlertDialogType.success:
        return AppColors.dialogSuccessColor.withOpacity(0.1);

        break;
      case AlertDialogType.warning:
        return AppColors.dialogWarningColor.withOpacity(0.1);
      default:
        return AppColors.dialogInfoColor.withOpacity(0.1);
    }
  }

  Color get textColor {
    switch (this) {
      case AlertDialogType.info:
        return AppColors.dialogInfoColor;
      case AlertDialogType.error:
        return AppColors.dialogErrorColor;

      case AlertDialogType.success:
        return AppColors.dialogSuccessColor;
      case AlertDialogType.warning:
        return AppColors.dialogWarningColor;
      default:
        return AppColors.dialogInfoColor;
    }
  }

  Icon get icon {
    switch (this) {
      case AlertDialogType.info:
        return Icon(
          Icons.info,
          size: 70,
          color: textColor,
        );
      case AlertDialogType.error:
        return Icon(
          Icons.error,
          size: 70,
          color: textColor,
        );

      case AlertDialogType.success:
        return Icon(
          Icons.check_circle,
          color: textColor,
          size: 70,
        );
      case AlertDialogType.warning:
        return Icon(
          Icons.warning,
          color: textColor,
          size: 70,
        );
      default:
        return Icon(
          Icons.warning,
          color: textColor,
          size: 70,
        );
    }
  }

  List<Widget> getDefaultActions() {
    final ActionButton button = ActionButton(
      child: const Text('Đồng ý'),
      color: backgroundColor,
    );
    switch (this) {
      case AlertDialogType.info:
        return [
          button,
        ];

      case AlertDialogType.error:
        return [
          button,
        ];

      case AlertDialogType.success:
        return [
          button,
        ];
      case AlertDialogType.warning:
        return [
          button,
        ];
      default:
        return [
          button,
        ];
    }
    ;
  }
}
