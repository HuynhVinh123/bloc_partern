import 'package:flutter/material.dart';

class SupportPage extends StatefulWidget {
  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liên hệ hỗ trợ"),
      ),
      body: Column(
        children: const [
          ListTile(),
        ],
      ),
    );
  }
}
