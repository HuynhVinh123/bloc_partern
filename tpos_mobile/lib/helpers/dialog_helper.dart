import 'package:flutter/material.dart';

import '../resources/app_colors.dart';

// Các trạng thái dialog
enum DialogType { error, warning, info, success }

// Lấy danh sách màu sắc của dialog
Color getColor(DialogType dialogType) {
  switch (dialogType) {
    case DialogType.error:
      return AppColors.dialogErrorColor;
      break;
    case DialogType.info:
      return AppColors.dialogInfoColor;
      break;
    case DialogType.success:
      return AppColors.dialogSuccessColor;
      break;
    case DialogType.warning:
      return AppColors.dialogWarningColor;
      break;
    default:
      return Colors.grey.shade400;
      break;
  }
}

// Lấy về mô tả mặc đinh cho dialog
String getDescription() {
  return "";
}

// Trả về tiêu đề mặc định của dialog
String getDefaultTitle(DialogType type) {
  switch (type) {
    case DialogType.warning:
      return "Cảnh báo";
      break;
    case DialogType.error:
      return "Lỗi";
      break;
    case DialogType.info:
      return "Thông tin";
      break;
    case DialogType.success:
      return "Thông báo";
      break;
    default:
      return "";
  }
}

// Trả về tiêu đề mặc định cho button của dialog
String getDefaultTitleButton(DialogType type) {
  switch (type) {
    case DialogType.warning:
      return "XÁC NHẬN";
      break;
    case DialogType.error:
      return "XÁC NHẬN";
      break;
    case DialogType.info:
      return "OK";
      break;
    case DialogType.success:
      return "OK";
      break;
    default:
      return "";
  }
}

// Lấy về tin nhắn mặc đinh cho dialog
String getDefaultMessage(DialogType type) {
  switch (type) {
    case DialogType.warning:
      return "Nếu bạn thực thi sẽ gây ra những vấn đề không mong muốn!";
      break;
    case DialogType.error:
      return "Lỗi xử lý!";
      break;
    case DialogType.info:
      return "Thông tin đã được lấy thành công.";
      break;
    case DialogType.success:
      return "Thực thi thành công.";
      break;
    default:
      return "";
  }
}

// Hiển thị dialog cho các trạng thài của Dialog Helper.
// type: bắt buộc phải truyền vào không được để null, context :bắt buộc truyền vào không được để null
Future<void> showDialogApp(
    {BuildContext context,
    DialogType type,
    String title,
    String message,
    List<Widget> actions}) async {
  switch (type) {
    case DialogType.warning:
      _showDialogBase(
          context: context,
          title: title ?? getDefaultTitle(type),
          message: message ?? getDefaultMessage(type),
          actions: actions,
          titleButton: getDefaultTitleButton(type),
          type: type);
      break;
    case DialogType.error:
      _showDialogBase(
          context: context,
          title: title ?? getDefaultTitle(type),
          message: message ?? getDefaultMessage(type),
          actions: actions,
          titleButton: getDefaultTitleButton(type),
          type: type);
      break;
    case DialogType.info:
      _showDialogBase(
          context: context,
          title: title ?? getDefaultTitle(type),
          message: message ?? getDefaultMessage(type),
          actions: actions,
          titleButton: getDefaultTitleButton(type),
          type: type);
      break;
    case DialogType.success:
      _showDialogBase(
          context: context,
          title: title ?? getDefaultTitle(type),
          message: message ?? getDefaultMessage(type),
          actions: actions,
          titleButton: getDefaultTitleButton(type),
          type: type);
      break;
  }
}

Future<void> _showDialogBase(
    {BuildContext context,
    String title,
    String message,
    String titleButton,
    DialogType type,
    List<Widget> actions}) async {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            width: 0,
            color: Colors.white,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                title ?? '',
                style: TextStyle(color: getColor(type)),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.close,
                size: 20,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        content: Text("$message"),
        actions: actions ??
            [
              Container(
                height: 32,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: const Color(0xFF28A745)),
                child: FlatButton(
                  child: Text("$titleButton",
                      style: const TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
            ]),
  );
}
