import 'package:flutter/material.dart';

///Xây dựng giao diện skackbar có thể đóng khi nhấn vào
/// Show snackbar trên Scaffold mà scaffoldKey đang ở đó.
///TODO(all): Di chuyển tới ui_help
SnackBar getCloseableSnackBar(
    {GlobalKey<ScaffoldState> scaffoldKey,
    @required String message,
    @required BuildContext context}) {
  if (scaffoldKey != null) {
    scaffoldKey.currentState.removeCurrentSnackBar();
  } else {
    Scaffold.of(context).removeCurrentSnackBar();
  }

  return SnackBar(
    content: GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (scaffoldKey != null) {
          scaffoldKey.currentState.hideCurrentSnackBar();
        } else {
          Scaffold.of(context).hideCurrentSnackBar();
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(child: Text(message ?? '')),
            const Text(
              'Đóng',
              style: TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 40, 167, 69),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
