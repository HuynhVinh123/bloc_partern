import 'package:flutter/material.dart';

///Xây dựng ui để giữ trạng thái cho widget trong PageView
class AliveState extends StatefulWidget {
  const AliveState({Key key, this.child}) : super(key: key);

  @override
  _AliveStateState createState() => _AliveStateState();
  final Widget child;
}

class _AliveStateState extends State<AliveState>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
