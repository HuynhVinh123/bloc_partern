import 'package:flutter/material.dart';

class MainMenuWidget extends StatelessWidget {
  const MainMenuWidget({
    Key key,
    this.name = '',
    this.gradient = const LinearGradient(colors: [
      Color(0xff305698),
      Color(0xff589AEF),
    ]),
    this.icon,
    this.iconColor = Colors.white,
    this.onPressed,
    this.tootip,
  }) : super(key: key);
  final String name;
  final String tootip;
  final Gradient gradient;
  final Widget icon;
  final Color iconColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      InkWell(
        onTap: onPressed,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            // gradient: gradient,
            borderRadius: BorderRadius.circular(50),
            color: Colors.grey.shade200,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: icon ?? const SizedBox(),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(
          name,
          textAlign: TextAlign.center,
        ),
      ),
    ]);
  }
}

/// Menu bình thường nằm trong nhóm
class NormalMenuItem extends StatelessWidget {
  const NormalMenuItem(
      {Key key,
      this.name = '',
      this.gradient,
      this.icon,
      this.iconColor,
      this.onPressed,
      this.isEdit,
      this.height,
      @required this.canDelete,
      this.onDeleted,
      this.tooltip,
      @required this.hasPermission})
      : super(key: key);

  final String name;
  final String tooltip;
  final Gradient gradient;
  final Widget icon;
  final Color iconColor;
  final VoidCallback onPressed;
  final VoidCallback onDeleted;
  final double height;
  final bool canDelete;
  final bool hasPermission;

  /// Mục menu có đang trong trạng thái được edit hay không. Khi [isEdit] icon có thể được xóa, di chuyển ...
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    final TextStyle _disableStyle = TextStyle(color: Colors.grey.shade200);
    const TextStyle _enableStyle = TextStyle();
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: hasPermission ? onPressed : null,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xffF8F9FB),
                        ),
                        color: const Color(0xffF8F9FB),
                      ),
                      height: 56,
                      width: 56,
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: IconTheme(
                          child: hasPermission
                              ? (icon ?? const SizedBox())
                              : const SizedBox(),
                          data: IconThemeData(
                            color: iconColor,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (canDelete)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: InkWell(
                        onTap: onDeleted,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Color(0xFFE3E7E9)),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: hasPermission ? _enableStyle : _disableStyle,
                ),
              ),
            ]),
      ),
    );
  }
}
