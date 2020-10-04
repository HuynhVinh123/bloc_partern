import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NotificationViewPage extends StatefulWidget {
  const NotificationViewPage(
      {this.htmlString, this.title = "Nội dung", this.notification});
  final TPosNotification notification;
  final String htmlString;
  final String title;

  @override
  _NotificationViewPageState createState() => _NotificationViewPageState();
}

class _NotificationViewPageState extends State<NotificationViewPage> {
  @override
  void initState() {
    //Đánh dấu đã đọc

    if (widget.notification?.dateRead == null)
      GetIt.instance<NotificationApi>()
          .markRead(widget.notification.id)
          .catchError((e) {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final content = Uri.dataFromString(
        "<!DOCTYPE html><html><head><title>Page Title</title></head><body>${widget.htmlString}</body></html>",
        mimeType: 'text/html',
        encoding: const Utf8Codec());
    return WebView(
      initialUrl: content.toString(),
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (value) {},
    );
  }
}
