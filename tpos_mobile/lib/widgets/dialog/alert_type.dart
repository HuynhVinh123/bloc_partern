import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tpos_mobile/widgets/button/action_button.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

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
        return S.current.dialog_infoTitle;
      case AlertDialogType.error:
        return S.current.dialog_errorTitle;
      case AlertDialogType.success:
        return S.current.dialog_successTitle;
      case AlertDialogType.warning:
        return S.current.dialog_warningTitle;
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

  Icon getIcon([double size = 70, Color color]) {
    switch (this) {
      case AlertDialogType.info:
        return Icon(
          Icons.info,
          size: size,
          color: color ?? textColor,
        );
      case AlertDialogType.error:
        return Icon(
          Icons.error,
          size: size,
          color: color ?? textColor,
        );

      case AlertDialogType.success:
        return Icon(
          Icons.check_circle,
          color: color ?? textColor,
          size: size,
        );
      case AlertDialogType.warning:
        return Icon(
          Icons.warning,
          color: color ?? textColor,
          size: size,
        );
      default:
        return Icon(
          Icons.warning,
          color: color ?? textColor,
          size: size,
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
  }
}
