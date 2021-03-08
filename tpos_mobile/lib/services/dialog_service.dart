import 'dart:async';
import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';

import '../app.dart';

@Deprecated('')
abstract class DialogService {
  @Deprecated(
      "DialogService and showInfo will Deprecated. Using NewDialogService instead")
  Future<DialogResult> showError(
      {String title,
      String content,
      String buttonTitle = "OK",
      Object error,
      bool isRetry = false});

  @Deprecated(
      "DialogService and showInfo will Deprecated. Using NewDialogService instead")
  Future<DialogResult> showNotify(
      {String title,
      String message,
      bool showOnTop,
      AlertDialogType type = AlertDialogType.info});
}

@Deprecated('')
class MainDialogService extends DialogService {
  @Deprecated(
      'The function showInfo will be deprecated. Using showDialog on NewDialogService instate')
  Future<DialogResult> showError(
      {String title,
      String content,
      String buttonTitle = "OK",
      Object error,
      bool isRetry = false}) async {
    String errorMessage = content?.replaceAll("Exception: ", "");
    if (error != null) {
      //Catch exception
      if (error is SocketException) {
        errorMessage =
            "Không thể kết nối tới địa chỉ mạng${error.address ?? ""}. Không có kết nối internet hoặc máy chủ không hoạt động tại thời điểm hiện tại.\n${error.message}";
      } else if (error is TimeoutException) {
        errorMessage = "Đã hết thời gian kết nối, vui lòng thử lại";
      } else
        errorMessage = error.toString().replaceAll("Exception: ", "");
    }
    return showAppDialog(
      type: DialogType.ERROR,
      title: title,
      content: errorMessage,
      okButtonTitle: buttonTitle,
      isRetry: isRetry,
    );
  }

  Future<DialogResult> showAppDialog(
      {String title,
      String content,
      String yesButtonTitle,
      String noButtonTitle,
      String cancelButtonTitle,
      String okButtonTitle,
      DialogType type,
      bool isRetry = false,
      bool showOnTop = false}) {
    final diallog = DialogMessageInfo(
        title: title,
        content: content,
        type: type,
        yesButtonTitle: yesButtonTitle,
        noButtonTitle: noButtonTitle,
        cancelButtonTitle: cancelButtonTitle,
        isRetry: isRetry,
        okButtonTitle: okButtonTitle,
        showOnTop: showOnTop);
    _showDialog(diallog);

    return diallog.completer.future;
  }

  void _showDialog(DialogMessageInfo message) {
    final context = App.overlayContext;
    switch (message.type) {
      case DialogType.INFO:
        _showDialogInfo(message, context);
        break;
      case DialogType.WARNING:
        _showDialogInfo(message, context);
        break;
      case DialogType.ERROR:
        if (message.isRetry)
          _showDialogErrorRetry(message, context);
        else
          _showDialogError(message, context);
        break;
      case DialogType.NOTIFY:
        _showNotify(message, context);
        break;
      case DialogType.NOTIFY_INFO:
        _showNotify(message, context);
        break;
      case DialogType.NOTIFY_ERROR:
        _showNotify(message, context);
        break;
      case DialogType.CONFIRM:
        // TODO: Handle this case.
        break;
    }
  }

  Future<DialogResult> showNotify({
    String title,
    String message,
    bool showOnTop = false,
    AlertDialogType type = AlertDialogType.info,
  }) async {
    return await App.showToast(title: title, message: message, type: type);
  }

  void _showDialogInfo(DialogMessageInfo message, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message.title),
        content: Text(message.content),
        actions: <Widget>[
          FlatButton(
            child: Text(message.okButtonTitle ?? "Ok"),
            onPressed: () {
              message.completer
                  ?.complete(DialogResult(type: DialogResultType.OK));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showDialogError(DialogMessageInfo message, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        title: Text(
          message.title ?? "",
          style: const TextStyle(color: Colors.red),
        ),
        content: Text(message.content),
        actions: <Widget>[
          FlatButton(
            child: Text(
              message.okButtonTitle ?? "",
              style: const TextStyle(color: Colors.blue),
            ),
            onPressed: () {
              message.completer
                  ?.complete(DialogResult(type: DialogResultType.OK));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showDialogErrorRetry(DialogMessageInfo message, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.green.shade200, width: 0.5)),
        title: Text(
          message.title ?? 'ERROR!',
          style: const TextStyle(color: Colors.red),
        ),
        content: Text(message.content),
        actions: <Widget>[
          FlatButton(
            child: const Text("QUAY LẠI"),
            onPressed: () {
              Navigator.of(context).pop();
              message.completer
                  ?.complete(DialogResult(type: DialogResultType.GOBACK));
            },
          ),
          FlatButton(
            child: const Text("THỬ LẠI"),
            onPressed: () {
              Navigator.pop(ctx);
              message.completer?.complete(
                DialogResult(type: DialogResultType.RETRY, isRetry: true),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showNotify(DialogMessageInfo message, BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Flushbar(
        title: message.title,
        message: message.content ?? "",
        duration: const Duration(seconds: 3),
        borderRadius: 12,
        margin: const EdgeInsets.all(12),
        backgroundColor: getNotifyColor(message.type),
        flushbarPosition:
            message.showOnTop ? FlushbarPosition.TOP : FlushbarPosition.BOTTOM,
      ).show(context);
    });
  }

  Color getNotifyColor(DialogType type) {
    switch (type) {
      case DialogType.INFO:
        return Colors.green;

      case DialogType.WARNING:
        return Colors.orangeAccent;

      case DialogType.ERROR:
        return Colors.red;

      case DialogType.CONFIRM:
        return Colors.orangeAccent;

      case DialogType.NOTIFY:
        return Colors.grey;
        break;
      case DialogType.NOTIFY_INFO:
        return Colors.green;
        break;
      case DialogType.NOTIFY_ERROR:
        return Colors.red;
        break;
      default:
        return Colors.blue;
    }
  }
}

class DialogResult {
  DialogResult(
      {this.responseMessage,
      this.value,
      this.isRetry = false,
      this.type = DialogResultType.OK});
  String responseMessage;
  Object value;
  bool isRetry;
  DialogResultType type;
}

class DialogMessageInfo {
  DialogMessageInfo(
      {this.title,
      this.content,
      this.type,
      this.yesButtonTitle,
      this.noButtonTitle,
      this.cancelButtonTitle,
      this.okButtonTitle,
      this.retryCallback,
      this.isRetry = false,
      this.showOnTop = false,
      this.completer}) {
    completer = Completer<DialogResult>();
  }
  String title;
  String content;
  DialogType type;

  String yesButtonTitle;
  String noButtonTitle;
  String cancelButtonTitle;
  String okButtonTitle;
  Function retryCallback;
  bool isRetry;
  bool showOnTop;
  Completer<DialogResult> completer;
}

@Deprecated('DialogType is deprecated. Using AlertDialogType instead')
enum DialogType {
  INFO,
  WARNING,
  ERROR,
  CONFIRM,
  NOTIFY,
  NOTIFY_INFO,
  NOTIFY_ERROR,
}

enum DialogResultType {
  OK,
  YES,
  NO,
  CANCEL,
  RETRY,
  GOBACK,
}

Future<DialogResultType> showQuestion(
    {BuildContext context, String title, String message}) async {
  final result = await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            width: 0,
          ),
        ),
        title: Text(
          title.isNotEmpty ? title : "Xác nhận",
          style: const TextStyle(color: Colors.red),
        ),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: const Text("HỦY BỎ"),
            onPressed: () {
              Navigator.of(context).pop(DialogResultType.CANCEL);
            },
          ),
          FlatButton(
            child: const Text("XÁC NHẬN"),
            onPressed: () {
              Navigator.of(context).pop(DialogResultType.YES);
            },
          ),
        ],
      );
    },
  );
  if (result != null) {
    return result;
  } else {
    return DialogResultType.CANCEL;
  }
}

Future<DialogResultType> showQuestionAction(
    {BuildContext context, String title, String message}) async {
  final result = await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            width: 0,
          ),
        ),
        title: Text(
          title.isNotEmpty ? title : "Xác nhận",
          style: const TextStyle(color: Colors.red),
        ),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: const Text("HỦY BỎ"),
            onPressed: () {
              Navigator.of(context).pop(DialogResultType.CANCEL);
            },
          ),
          FlatButton(
            child: const Text("XÁC NHẬN"),
            onPressed: () {
              Navigator.of(context).pop(DialogResultType.YES);
            },
          ),
        ],
      );
    },
  );
  if (result != null) {
    return result;
  } else {
    return DialogResultType.CANCEL;
  }
}
