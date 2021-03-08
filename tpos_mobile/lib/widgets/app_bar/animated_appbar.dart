import 'package:flutter/material.dart';

/// An appbar has title and search area alway visible.
class AnimatedAppbar extends StatefulWidget implements PreferredSizeWidget {
  const AnimatedAppbar({Key key, this.leading, this.title, this.actions})
      : super(key: key);
  final Widget leading;
  final Widget title;
  final List<Widget> actions;

  @override
  _AnimatedAppbarState createState() => _AnimatedAppbarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size(double.infinity, 50);
}

class _AnimatedAppbarState extends State<AnimatedAppbar> {
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      child: AppBar(),
      preferredSize: const Size(double.infinity, 50),
    );
  }
}
