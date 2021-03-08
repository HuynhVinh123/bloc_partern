import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tpos_mobile/widgets/reg_ex_input_formatter.dart';

class FocusTextField extends StatefulWidget {
  @override
  _FocusTextFieldState createState() => _FocusTextFieldState();
}

class _FocusTextFieldState extends State<FocusTextField> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Widget _buildNumberTextField(
      {TextEditingController controller,
      FocusNode focusNode,
      Widget suffix,
      bool isRequire = false,
      String hint,
      EdgeInsets contentPadding = const EdgeInsets.only(right: 10),
      String uom,
      String title,
      RegExInputFormatter regExInputFormatter,
      Function() onTapSuffix}) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(title,
                style: TextStyle(
                    color: focusNode.hasFocus ? const Color(0xff28A745) : const Color(0xff929DAA), fontSize: 12)),
            Stack(
              children: [
                if (suffix != null) Positioned(right: 0, top: 5, child: suffix),
                Positioned(
                  top: 15,
                  left: 0,
                  child: InkWell(
                    onTap: () {
                      if (focusNode != null) {
                        FocusScope.of(context).requestFocus(focusNode);
                      }
                    },
                    child: Row(
                      children: [
                        Text(controller.text, style: const TextStyle(color: Colors.transparent, fontSize: 17)),
                        const SizedBox(width: 5),
                        Text(uom,
                            style: const TextStyle(
                              color: Color(0xff929DAA),
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                            ))
                      ],
                    ),
                  ),
                ),
                if (isRequire && controller.text == '')
                  Positioned(
                      top: 11,
                      left: 0,
                      child: InkWell(
                        child: RichText(
                          text: TextSpan(style: DefaultTextStyle.of(context).style, children: [
                            TextSpan(
                              text: hint,
                              style:
                                  const TextStyle(color: Color(0xff929DAA), fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                            const TextSpan(
                              text: ' *',
                              style: TextStyle(color: Color(0xffEB3B5B), fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                          ]),
                          maxLines: 1,
                        ),
                        onTap: () {
                          if (focusNode != null) {
                            FocusScope.of(context).requestFocus(focusNode);
                          }
                        },
                      )),
                Container(
                  height: 50,
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    onChanged: (String text) {
                      setState(() {});
                    },
                    inputFormatters: regExInputFormatter != null
                        ? <TextInputFormatter>[regExInputFormatter]
                        : <TextInputFormatter>[],
                    style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
                    decoration: InputDecoration(
                      contentPadding: contentPadding,
                      suffix: onTapSuffix != null
                          ? SvgPicture.asset(
                              'assets/icon/tag_green.svg',
                              width: 20,
                              height: 20,
                              color: Colors.transparent,
                            )
                          : null,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      hintText: isRequire ? '' : hint,
                      hintStyle: const TextStyle(color: Color(0xff929DAA), fontSize: 17),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff28A745)),
                      ),
                    ),
                  ),
                ),
                if (onTapSuffix != null)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: ClipOval(
                      child: Container(
                        height: 50,
                        width: 50,
                        child: Material(
                          color: Colors.transparent,
                          child: IconButton(
                            iconSize: 25,
                            icon: SvgPicture.asset(
                              'assets/icon/tag_green.svg',
                              width: 20,
                              height: 20,
                              color: focusNode.hasFocus ? const Color(0xff28A745) : const Color(0xff858F9B),
                            ),
                            onPressed: () {
                              onTapSuffix?.call();
                            },
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ],
        );
      },
    );
  }
}
