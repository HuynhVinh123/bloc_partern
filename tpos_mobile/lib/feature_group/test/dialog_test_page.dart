import 'package:flutter/material.dart';
import 'package:tpos_mobile/helpers/dialog_helper.dart';

class DialogTestPage extends StatefulWidget {
  @override
  _DialogTestPageState createState() => _DialogTestPageState();
}

class _DialogTestPageState extends State<DialogTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FlatButton(
              color: Colors.grey[300],
              child: const Text("Dialog Error"),
              onPressed: () {
                showDialogApp(context: context, type: DialogType.error);
              },
            ),
            FlatButton(
              color: Colors.grey[300],
              child: const Text("Dialog warning"),
              onPressed: () {
                showDialogApp(context: context, type: DialogType.warning);
              },
            ),
            FlatButton(
              color: Colors.grey[300],
              child: const Text("Dialog success"),
              onPressed: () {
                showDialogApp(context: context, type: DialogType.success);
              },
            ),
            FlatButton(
              color: Colors.grey[300],
              child: const Text("Dialog info"),
              onPressed: () {
                showDialogApp(context: context, type: DialogType.info);
              },
            )
          ],
        ),
      ),
    );
  }
}
