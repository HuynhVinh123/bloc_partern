import 'package:flutter/material.dart';

class AllMenuItem extends StatelessWidget {
  const AllMenuItem({Key key, this.icon, this.title, this.onPressed})
      : super(key: key);
  final Widget icon;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xffE9EDF2),
            ),
          ),
          padding: const EdgeInsets.only(top: 8, bottom: 8, left: 3, right: 3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              const SizedBox(
                height: 3,
              ),
              Flexible(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  style: const TextStyle(fontSize: 12),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
