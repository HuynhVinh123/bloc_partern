import 'dart:async';
import 'dart:io';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../app.dart';
import '../locator.dart';
import 'navigation_service.dart';

@Deprecated('')
abstract class DialogService {
  @Deprecated(
      "DialogService and showInfo will Deprecated. Using NewDialogService instead")
  Future<DialogResult> showInfo(
      {String title = "INFO", String content, String buttonTitle = "ĐỒNG Ý"});
  @Deprecated(
      "DialogService and showInfo will Deprecated. Using NewDialogService instead")
  Future<DialogResult> showError(
      {String title = "ERROR!",
      String content,
      String buttonTitle = "OK",
      Object error,
      bool isRetry = false});
  @Deprecated(
      "DialogService and showInfo will Deprecated. Using NewDialogService instead")
  Future<DialogResult> showConfirm(
      {String title = "CONFIRM",
      String content,
      String yesButtonTitle = "YES",
      String noButtonTitle = "NO"});
  @Deprecated(
      "DialogService and showInfo will Deprecated. Using NewDialogService instead")
  Future<DialogResult> showNotify(
      {String title,
      String message,
      bool showOnTop,
      DialogType type = DialogType.NOTIFY_INFO});
}

@Deprecated('')
class MainDialogService extends DialogService {
  Completer<DialogResult> _dialogCompleter;

  @Deprecated(
      'The function showInfo will be deprecated. Using showDialog on NewDialogService instate')
  Future<DialogResult> showInfo(
      {String title = "INFO", String content, String buttonTitle = "ĐỒNG Ý"}) {
    return showAppDialog(
        type: DialogType.INFO,
        title: title,
        content: content,
        okButtonTitle: buttonTitle);
  }

  @Deprecated(
      'The function showInfo will be deprecated. Using showDialog on NewDialogService instate')
  Future<DialogResult> showError(
      {String title = "ERROR!",
      String content,
      String buttonTitle = "OK",
      Object error,
      bool isRetry = false}) {
    String errorMessage = content?.replaceAll("Exception: ", "");
    if (error != null) {
      //Catch exception
      if (error is SocketException) {
        SocketException e = error;
        errorMessage =
            "Không thể kết nối tới địa chỉ mạng${error.address ?? ""}. Không có kết nối mạng hoặc địa chỉ máy chủ không hoạt động\n${error.message}";
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

  Future<DialogResult> showConfirm(
      {String title = "CONFIRM",
      String content,
      String yesButtonTitle = "YES",
      String noButtonTitle = "NO"}) {
    return showAppDialog(
        type: DialogType.CONFIRM,
        title: title,
        content: content,
        noButtonTitle: noButtonTitle,
        yesButtonTitle: yesButtonTitle);
  }

  Future<DialogResult> showNotify({
    String title,
    String message,
    bool showOnTop = false,
    DialogType type = DialogType.NOTIFY_INFO,
  }) {
    return showAppDialog(
        type: type, title: title, content: message, showOnTop: showOnTop);
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
    _dialogCompleter = Completer<DialogResult>();

    _showDialog(
      DialogMessageInfo(
          title: title,
          content: content,
          type: type,
          yesButtonTitle: yesButtonTitle,
          noButtonTitle: noButtonTitle,
          cancelButtonTitle: cancelButtonTitle,
          isRetry: isRetry,
          okButtonTitle: okButtonTitle,
          showOnTop: showOnTop),
    );

    return _dialogCompleter.future;
  }

  void dialogComplete(DialogResult result) {
    _dialogCompleter?.complete(result);
    _dialogCompleter = null;
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
      case DialogType.CONFIRM:
        _showConfirm(message, context);
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
    }
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
              dialogComplete(DialogResult(type: DialogResultType.OK));
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
          borderSide: BorderSide(color: Colors.grey),
        ),
        title: Text(
          message.title ?? "",
          style: TextStyle(color: Colors.red),
        ),
        content: Text(message.content),
        actions: <Widget>[
          FlatButton(
            child: Text(
              message.okButtonTitle ?? "",
              style: TextStyle(color: Colors.blue),
            ),
            onPressed: () {
              dialogComplete(new DialogResult(type: DialogResultType.OK));
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
          message.title,
          style: const TextStyle(color: Colors.red),
        ),
        content: Text(message.content),
        actions: <Widget>[
          FlatButton(
            child: const Text("QUAY LẠI"),
            onPressed: () {
              dialogComplete(new DialogResult(type: DialogResultType.GOBACK));
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text("THỬ LẠI"),
            onPressed: () {
              dialogComplete(
                new DialogResult(type: DialogResultType.RETRY, isRetry: true),
              );
              Navigator.pop(ctx);
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

  void _showConfirm(DialogMessageInfo message, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(
          message.title,
          style: TextStyle(color: Colors.red),
        ),
        content: Text(message.content),
        actions: <Widget>[
          FlatButton(
            child: Text("${message.noButtonTitle}"),
            onPressed: () {
              dialogComplete(new DialogResult(type: DialogResultType.NO));
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text("${message.yesButtonTitle}"),
            onPressed: () {
              dialogComplete(
                new DialogResult(type: DialogResultType.YES),
              );
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
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
  DialogMessageInfo({
    this.title,
    this.content,
    this.type,
    this.yesButtonTitle,
    this.noButtonTitle,
    this.cancelButtonTitle,
    this.okButtonTitle,
    this.retryCallback,
    this.isRetry = false,
    this.showOnTop = false,
  });
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
}

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
