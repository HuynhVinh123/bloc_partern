import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

class NotificationHtmlViewPage extends StatefulWidget {
  const NotificationHtmlViewPage({Key key, this.notification})
      : super(key: key);
  final TPosNotification notification;

  @override
  _NotificationHtmlViewPageState createState() =>
      _NotificationHtmlViewPageState();
}

class _NotificationHtmlViewPageState extends State<NotificationHtmlViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.notification.title),
      ),
      body: Html(
        data: widget.notification.content,
        style: {
          "p": Style(
            fontSize: FontSize.large,
          )
        },
      ),
    );
  }
}
