import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';

class DialogProvider extends StatefulWidget {
  const DialogProvider({this.child, this.key}) : super(key: key);
  final Widget child;
  final Key key;

  @override
  _DialogProviderState createState() => _DialogProviderState();
}

class _DialogProviderState extends State<DialogProvider> {
  final _dialogService = locator<DialogService>();

  @override
  void initState() {
    _dialogService.registerDialogListener(_showDialog);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_dialogService.showDialogListener == null) {
      print("Dialog ShowDialogListner is null");
    }
    return widget.child;
  }

  void _showDialog(DialogMessageInfo message) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
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
    });
  }

  void _showDialogInfo(DialogMessageInfo message, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message.title),
        content: Text(message.content),
        actions: <Widget>[
          FlatButton(
            child: Text(message.title),
            onPressed: () {
              _dialogService
                  .dialogComplete(new DialogResult(type: DialogResultType.OK));
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
              _dialogService
                  .dialogComplete(new DialogResult(type: DialogResultType.OK));
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
          style: TextStyle(color: Colors.red),
        ),
        content: Text(message.content),
        actions: <Widget>[
          FlatButton(
            child: Text("QUAY LẠI"),
            onPressed: () {
              _dialogService.dialogComplete(
                  new DialogResult(type: DialogResultType.GOBACK));
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text("THỬ LẠI"),
            onPressed: () {
              _dialogService.dialogComplete(
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
    Flushbar(
      title: message.title,
      message: message.content ?? "",
      duration: Duration(seconds: 3),
      borderRadius: 12,
      margin: EdgeInsets.all(12),
      backgroundColor: getNotifyColor(message.type),
      flushbarPosition:
          message.showOnTop ? FlushbarPosition.TOP : FlushbarPosition.BOTTOM,
    )..show(context);
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
              _dialogService
                  .dialogComplete(new DialogResult(type: DialogResultType.NO));
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text("${message.yesButtonTitle}"),
            onPressed: () {
              _dialogService.dialogComplete(
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
