import 'package:flutter/material.dart';

class AppLoadMoreButton extends StatelessWidget {
  const AppLoadMoreButton(
      {this.label,
      this.icon,
      this.isLoading = false,
      this.onPressed,
      this.onLongPressed});
  final String label;
  final Widget icon;
  final bool isLoading;
  final VoidCallback onPressed;
  final VoidCallback onLongPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        child: RaisedButton(
          color: Colors.blue,
          textColor: Colors.white,
          child:
              isLoading ? const CircularProgressIndicator() : Text(label ?? ""),
          onPressed: onPressed,
        ),
        onLongPress: onLongPressed,
      ),
    );
  }
}
