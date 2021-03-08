import 'package:flutter/material.dart';

class InputCardWrapper extends StatelessWidget {
  const InputCardWrapper({Key key, this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(8),
      child: child,
    );
  }
}
