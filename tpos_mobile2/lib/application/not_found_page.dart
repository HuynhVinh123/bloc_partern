import 'package:flutter/material.dart';
import 'package:tpos_mobile/resources/app_route.dart';

class NotFoundPage extends StatefulWidget {
  static const routeName = "/not_found";
  @override
  _NotFoundPageState createState() => _NotFoundPageState();
}

class _NotFoundPageState extends State<NotFoundPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  "Chức năng bạn đang truy cập hiện không khả dụng với bạn. Vui lòng Liên hệ người quản trị của bạn để biết thêm chi tiết",
                  style: TextStyle(fontSize: 20, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 30,
                ),
                RaisedButton(
                  child: const Text("Quay lại"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                RaisedButton(
                  child: Text("Về Menu"),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, AppRoute.home, (Route<dynamic> r) => false);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
