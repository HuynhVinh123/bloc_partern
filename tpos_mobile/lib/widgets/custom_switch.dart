library flutter_switch;

import 'package:flutter/material.dart';

///Xây dựng giao diện switch với toggle lớn hơn switch
class CustomSwitch extends StatefulWidget {
  /// Creates a material design switch.
  ///
  /// The following arguments are required:
  ///
  /// * [value] determines whether this switch is on or off.
  /// * [onToggle] is called when the user toggles the switch on or off.
  ///

  const CustomSwitch({
    Key key,
    @required this.value,
    @required this.onToggle,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.activeTextColor = Colors.white70,
    this.inactiveTextColor = Colors.white70,
    this.toggleColor = Colors.white,
    this.width = 70.0,
    this.height = 35.0,
    this.toggleSize = 25.0,
    this.valueFontSize = 16.0,
    this.borderRadius = 20.0,
    this.padding = 4.0,
    this.showOnOff = false,
    this.activeText,
    this.inactiveText,
    this.activeTextFontWeight,
    this.inactiveTextFontWeight,
  }) : super(key: key);

  /// Determines if the switch is on or off.
  ///
  /// This property is required.
  final bool value;

  /// Called when the user toggles the switch.
  ///
  /// This property is required.
  ///
  /// [onToggle] should update the state of the parent [StatefulWidget]
  /// using the [setState] method, so that the parent gets rebuilt; for example:
  ///
  /// ```dart
  /// FlutterSwitch(
  ///   value: _status,
  ///   width: 110,
  ///   borderRadius: 30.0,
  ///   onToggle: (val) {
  ///     setState(() {
  ///        _status = val;
  ///     });
  ///   },
  /// ),
  /// ```
  final ValueChanged<bool> onToggle;

  /// Displays an on or off text.
  ///
  /// Text value can be override by the [activeText] and
  /// [inactiveText] properties.
  ///
  /// Defaults to 'false' if no value was given.
  final bool showOnOff;

  /// The text to display when the switch is on.
  /// This parameter is only necessary when [showOnOff] property is true.
  ///
  /// Defaults to 'On' if no value was given.
  ///
  /// To change value style, the following properties are available
  ///
  /// [activeTextColor] - The color to use on the text value when the switch is on.
  /// [activeTextFontWeight] - The font weight to use on the text value when the switch is on.
  final String activeText;

  /// The text to display when the switch is off.
  /// This parameter is only necessary when [showOnOff] property is true.
  ///
  /// Defaults to 'Off' if no value was given.
  ///
  /// To change value style, the following properties are available
  ///
  /// [inactiveTextColor] - The color to use on the text value when the switch is off.
  /// [inactiveTextFontWeight] - The font weight to use on the text value when the switch is off.
  final String inactiveText;

  /// The color to use on the switch when the switch is on.
  ///
  /// Defaults to [Colors.blue].
  final Color activeColor;

  /// The color to use on the switch when the switch is off.
  ///
  /// Defaults to [Colors.grey].
  final Color inactiveColor;

  /// The color to use on the text value when the switch is on.
  /// This parameter is only necessary when [showOnOff] property is true.
  ///
  /// Defaults to [Colors.white70].
  final Color activeTextColor;

  /// The color to use on the text value when the switch is off.
  /// This parameter is only necessary when [showOnOff] property is true.
  ///
  /// Defaults to [Colors.white70].
  final Color inactiveTextColor;

  /// The font weight to use on the text value when the switch is on.
  /// This parameter is only necessary when [showOnOff] property is true.
  ///
  /// Defaults to [FontWeight.w900].
  final FontWeight activeTextFontWeight;

  /// The font weight to use on the text value when the switch is off.
  /// This parameter is only necessary when [showOnOff] property is true.
  ///
  /// Defaults to [FontWeight.w900].
  final FontWeight inactiveTextFontWeight;

  /// The color to use on the toggle of the switch.
  ///
  /// Defaults to [Colors.white].
  final Color toggleColor;

  /// The given width of the switch.
  ///
  /// Defaults to a width of 70.0.
  final double width;

  /// The given height of the switch.
  ///
  /// Defaults to a height of 35.0.
  final double height;

  /// The size of the toggle of the switch.
  ///
  /// Defaults to a size of 25.0.
  final double toggleSize;

  /// The font size of the values of the switch.
  /// This parameter is only necessary when [showOnOff] property is true.
  ///
  /// Defaults to a size of 16.0.
  final double valueFontSize;

  /// The border radius of the switch.
  ///
  /// Defaults to the value of 20.0.
  final double borderRadius;

  /// The padding of the switch.
  ///
  /// Defaults to the value of 4.0.
  final double padding;

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> with SingleTickerProviderStateMixin {
  Animation _toggleAnimation;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      value: widget.value ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 60),
    );
    _toggleAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value == widget.value) {
      return;
    }

    if (widget.value)
      _animationController.forward();
    else
      _animationController.reverse();
  }

  bool value = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (value)
              _animationController.reverse();
            else
              _animationController.forward();
            value = !value;
            widget.onToggle(!widget.value);
          },
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              color: _toggleAnimation.value == 0 ? widget.inactiveColor : widget.activeColor,
            ),
            child: Stack(
              overflow: Overflow.visible,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (_toggleAnimation.value == Alignment.centerRight)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: _activeText,
                    ),
                  )
                else
                  Container(),
                Positioned(
                  left: _toggleAnimation.value * (widget.width - widget.toggleSize),
                  top: -widget.toggleSize / 2 + widget.height / 2,
                  child: Container(
                    width: widget.toggleSize,
                    height: widget.toggleSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.toggleColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(1),
                          spreadRadius: 0,
                          blurRadius: 5,
                          offset: const Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                  ),
                ),
                if (_toggleAnimation.value == Alignment.centerLeft)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      alignment: Alignment.centerRight,
                      child: _inactiveText,
                    ),
                  )
                else
                  Container(),
              ],
            ),
          ),
        );
      },
    );
  }

  FontWeight get _activeTextFontWeight => widget.activeTextFontWeight ?? FontWeight.w900;

  FontWeight get _inactiveTextFontWeight => widget.inactiveTextFontWeight ?? FontWeight.w900;

  Widget get _activeText {
    if (widget.showOnOff) {
      return Text(
        (widget?.activeText != null) ? widget.activeText : "On",
        style: TextStyle(
          color: widget.activeTextColor,
          fontWeight: _activeTextFontWeight,
          fontSize: widget.valueFontSize,
        ),
      );
    }

    return const Text("");
  }

  Widget get _inactiveText {
    if (widget.showOnOff) {
      return Text(
        (widget?.inactiveText != null) ? widget.inactiveText : "Off",
        style: TextStyle(
          color: widget.inactiveTextColor,
          fontWeight: _inactiveTextFontWeight,
          fontSize: widget.valueFontSize,
        ),
        textAlign: TextAlign.right,
      );
    }

    return const Text("");
  }
}
