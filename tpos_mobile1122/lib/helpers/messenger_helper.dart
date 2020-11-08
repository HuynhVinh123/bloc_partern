/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 7/4/19 6:25 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 7/4/19 4:57 PM
 *
 */

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

class OldDialogMessage {
  static const String show_info = "SHOW_INFO";
  static const String show_error = "SHOW_ERROR";
  static const String show_warning = "SHOW_WARNING";
  static const String show_confirm = "SHOW_CONFIRM";
  static const String show_snackbar = "SHOW_SNACKBAR";
  static const String show_toast = "SHOW_TOAST";
  static const String show_snackbar_indicator = "SHOW_SNACKBAR_INDICATOR";
  static const String show_page_error = "SHOW_PAGE_ERROR";

  String message;
  Object messageObj;
  String action;
  String title;
  Function callBack;
  Object sender;
  Object receiver;
  bool isShow = false;
  bool isNotAllowDismiss;
  bool isRetryRequired;

  OldDialogMessage(this.message,
      {this.action,
      this.title,
      this.callBack,
      this.sender,
      this.receiver,
      this.isRetryRequired = false,
      this.messageObj});
  factory OldDialogMessage.info(String message) {
    return OldDialogMessage(message, title: "Thông tin", action: "SHOW_INFO");
  }

  factory OldDialogMessage.error(String message, String errorStr,
      {String title = "Error!",
      Object sender,
      Object receiver,
      Function callback,
      bool isRetryRequired = false,
      Object error,
      Object stackTrade}) {
    String msg = message != null && message.isNotEmpty ? message + ". " : "";
    msg += (errorStr ?? "");
    return OldDialogMessage(msg,
        title: title,
        action: "SHOW_ERROR",
        sender: sender,
        receiver: receiver,
        callBack: callback,
        messageObj: error,
        isRetryRequired: isRetryRequired);
  }

  factory OldDialogMessage.warning(String message,
      {Object sender, String title}) {
    return OldDialogMessage(message,
        title: title ?? "Cảnh báo", action: show_warning, sender: sender);
  }

  factory OldDialogMessage.confirm(
      String message, Function(OldDialogResult) callBack,
      {Object sender}) {
    return OldDialogMessage(
      message,
      title: "Xác nhận",
      action: show_confirm,
      callBack: callBack,
      sender: sender,
    );
  }

  factory OldDialogMessage.flashMessage(String message,
      {Object sender, Object receiver}) {
    return OldDialogMessage(message,
        title: "Thông tin",
        action: show_snackbar,
        sender: sender,
        receiver: receiver);
  }

  factory OldDialogMessage.progress(String message, {Object sender}) {
    return OldDialogMessage(message,
        title: "Đang thực hiện",
        action: show_snackbar_indicator,
        sender: sender);
  }
}

class ActionMessage {
  String action;
  String message;

  ActionMessage({this.action, this.message});
}

enum DialogMessageType {
  SHOW_INFO,
  SHOW_ERROR,
  SHOW_WARNING,
  SHOW_CONFIRM,
  SHOW_SNACKBAR,
  SHOW_TOAST
}

Future registerDialogToView(BuildContext context, OldDialogMessage message,
    {Function callBack, ScaffoldState scaffState}) async {
  switch (message.action) {
    case OldDialogMessage.show_info:
      showInfo(
          context: context, title: message.title, message: message.message);
      break;
    case OldDialogMessage.show_warning:
      showInfo(
          context: context, title: message.title, message: message.message);
      break;
    case OldDialogMessage.show_error:
      if (message.isRetryRequired) {
        var result = await showErrorWithRetry(
            callback: message.callBack,
            context: context,
            title: message.title,
            message: message.message,
            exception: message.messageObj);
        if (result) {
          if (message.callBack != null) message.callBack(true);
        } else {
          Navigator.of(context)?.pop();
        }
      } else {
        showError(
            context: context,
            title: message.title,
            message: message.message,
            exception: message.messageObj);
      }

      break;
    case OldDialogMessage.show_snackbar:
      showSnackbar(
          context: context,
          message: message.message,
          scaffoldState: scaffState);
      break;
    case OldDialogMessage.show_toast:
      showSnackbar(
          context: context,
          message: message.message,
          scaffoldState: scaffState);
      break;
    case OldDialogMessage.show_snackbar_indicator:
      showSnackIndicator(
          context: context,
          message: message.message,
          scaffoldState: scaffState);
      break;
    case OldDialogMessage.show_confirm:
      var result = await showQuestion(
        context: context,
        title: "Xác nhận",
        message: message.message,
      );

      message.callBack(result);
      break;
  }
}

void showMessage({BuildContext context, String title, String message}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: new Text(
          title.isNotEmpty ? title : "Thông báo",
        ),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text("Đồng ý"),
            onPressed: () {
              Navigator.of(context)?.pop();
            },
          ),
        ],
      );
    },
  );
}

void showInfo({BuildContext context, String title, String message}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: new Text(
          title != null && title.isNotEmpty ? title : "Thông tin",
        ),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text("ĐỒNG Ý"),
            onPressed: () {
              Navigator.of(context)?.pop();
            },
          ),
        ],
      );
    },
  );
}

void showWarning({BuildContext context, String title, String message}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: new Text(
          title != null && title.isNotEmpty ? title : "Cảnh báo",
        ),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text("ĐỒNG Ý"),
            onPressed: () {
              Navigator.of(context)?.pop();
            },
          ),
        ],
      );
    },
  );
}

void showError(
    {BuildContext context,
    String title,
    String message,
    Object exception,
    bool isRetryRequired}) {
  String msg = message;
  String tle = title;
  if (exception != null) {
    if (exception is SocketException) {
      SocketException ex = exception;
      msg =
          "Không có kết nối mạng hoặc địa chỉ '${exception.address}' không hoạt động";
      tle = title ?? "Không tìm thấy máy chủ!";
    } else if (exception is TimeoutException) {
      msg =
          "Đã hết thời gian xử lý mà vẫn chưa có kết quả phản hồi. Vui lòng thử lại!";
      tle = title ?? "Hết thời gian!";
    } else {
      msg = exception?.toString()?.replaceAll("Exception: ", "");
    }
  }
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: new Text(
          title != null && tle.isNotEmpty ? tle : "Error!",
          style: TextStyle(color: Colors.red),
        ),
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            )),
        content: Text(msg ?? ""),
        actions: <Widget>[
          FlatButton(
            child: Text("ĐỒNG Ý"),
            onPressed: () {
              Navigator.of(context)?.pop();
            },
          ),
        ],
      );
    },
  );
}

Future<bool> showErrorWithRetry({
  BuildContext context,
  String title,
  String message,
  Object exception,
  Function callback,
}) async {
  return await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      String msg = message;
      String tle = title;
      if (exception != null) {
        if (exception is SocketException) {
          SocketException ex = exception;
          msg =
              "Không có kết nối mạng hoặc địa chỉ '${exception.address ?? "N/A"}' không hoạt động";
          tle = title ?? "Không tìm thấy máy chủ!";
        } else if (exception is TimeoutException) {
          msg =
              "Đã hết thời gian xử lý mà vẫn chưa có kết quả phản hồi. Vui lòng thử lại!";
          tle = title ?? "Hết thời gian!";
        } else {
          msg = exception?.toString()?.replaceAll("Exception: ", "");
        }
      }
      return AlertDialog(
        title: new Text(
          title != null && title.isNotEmpty ? title : "Error!",
          style: TextStyle(color: Colors.red),
        ),
        content: Text(msg),
        actions: <Widget>[
          RaisedButton.icon(
            textColor: Colors.white,
            icon: Icon(Icons.arrow_back),
            label: Text("Quay lại"),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          RaisedButton.icon(
            textColor: Colors.white,
            icon: Icon(Icons.refresh),
            label: Text("Thử lại"),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}

Future<OldDialogResult> showQuestion(
    {BuildContext context, String title, String message}) async {
  var result = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            width: 0,
          ),
        ),
        title: new Text(
          title.isNotEmpty ? title : "Xác nhận",
        ),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text("HỦY BỎ"),
            onPressed: () {
              Navigator.of(context).pop(OldDialogResult.Cancel);
            },
          ),
          FlatButton(
            child: Text("XÁC NHẬN"),
            onPressed: () {
              Navigator.of(context).pop(OldDialogResult.Yes);
            },
          ),
        ],
      );
    },
  );
  if (result != null) {
    return result;
  } else {
    return OldDialogResult.Cancel;
  }
}

void
showSnackbar(
    {ScaffoldState scaffoldState, BuildContext context, String message}) {
  //scaffoldState
  scaffoldState?.removeCurrentSnackBar();
  scaffoldState?.showSnackBar(new SnackBar(
    content: new Text(message),
  ));
}

void showSnackIndicator(
    {ScaffoldState scaffoldState, BuildContext context, String message}) {
  Key key = new Key("snack");

  scaffoldState?.showSnackBar(
    new SnackBar(
      key: key,
      duration: new Duration(minutes: 10),
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(),
          Text(message),
        ],
      ),
    ),
  );
}

void showProgressDialog(BuildContext context, onCompltedCallback) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Vui lòng đợi"),
          content: Container(
            height: 100,
            width: 100,
            color: Colors.green.shade300,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      });
}

void showPageError(
    {BuildContext context,
    String title = "Đã xảy ra lỗi!",
    String message = ""}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
        );
      });
}

enum OldDialogResult {
  Ok,
  Cancel,
  Yes,
  No,
}

void showSnackNotify(BuildContext context,String content){
  Scaffold.of(context).showSnackBar(SnackBar(
    content: Text(content ?? ""),
    duration: Duration(seconds: 3),
  ));
}