import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/application/notification_page/notification_bloc.dart';
import 'package:tpos_mobile/application/notification_page/notification_event.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationPopupDialogPage extends StatefulWidget {
  const NotificationPopupDialogPage({this.notification});
  final TPosNotification notification;

  @override
  _NotificationPopupDialogPageState createState() =>
      _NotificationPopupDialogPageState();
}

class _NotificationPopupDialogPageState
    extends State<NotificationPopupDialogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          // Nội dung
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            margin: const EdgeInsets.only(
                left: 30, right: 30, top: 100, bottom: 100),
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 8, left: 8, right: 8, bottom: 20),
                child: Text(
                  "${widget.notification.title}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                child: _buildBody(),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    OutlineButton(
                      child: const Text("Đóng"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    RaisedButton(
                      child: const Text("Đánh dấu đã đọc"),
                      textColor: Colors.white,
                      color: Colors.deepPurple,
                      onPressed: () {
                        context.bloc<NotificationBloc>().add(
                              NotificationMarkRead(widget.notification),
                            );
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              )
            ]),
          ),

          // Nút tắt

          Positioned(
            right: 10,
            top: 75,
            child: IconButton(
              icon: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.close,
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final content = Uri.dataFromString(
        "<!DOCTYPE html><html><head><title>Page Title</title></head><body>${widget.notification.content}</body></html>",
        mimeType: 'text/html',
        encoding: const Utf8Codec());
    return WebView(
      initialUrl: content.toString(),
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (value) {},
    );
  }
}
