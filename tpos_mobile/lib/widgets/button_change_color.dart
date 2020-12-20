import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/conversation/conversation_filter/conversation_filter.dart';

class ButtonChangeColor extends StatefulWidget {
  /// Thay đổi màu button khi nhấn
  ButtonChangeColor(
      {this.title, this.applicationUser, this.conservationFilter});
  final String title;
  ApplicationUser applicationUser;
  ConversationFilter conservationFilter;
  @override
  _ButtonChangeColorState createState() => _ButtonChangeColorState();
}

class _ButtonChangeColorState extends State<ButtonChangeColor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.conservationFilter.isCheckStaff
          ? const Color(0xFFE9F6EC)
          : Colors.white,
      height: 30,
      child: OutlineButton(
        child: Text(
          widget.title,
          style: widget.conservationFilter.isCheckStaff
              ? const TextStyle(color: Color(0xFF28A745))
              : const TextStyle(color: Color(0xFF6B7280)),
        ),
        onPressed: () {
          setState(() {
//            widget.isClickButton = !widget.isClickButton;
            widget.conservationFilter.isCheckStaff =
                !widget.conservationFilter.isCheckStaff;
            print(widget.conservationFilter.isCheckStaff);
          });
        }, //callback when button is clicked
        borderSide: BorderSide(
          color: widget.conservationFilter.isCheckStaff
              ? const Color(0xFF28A745)
              : const Color(0xFFE9EDF2), //Color of the border
          style: BorderStyle.solid, //Style of the border
          width: 2, //width of the border
        ),
      ),
    );
  }
}
