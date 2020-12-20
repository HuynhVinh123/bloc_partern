import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/data_helper.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/widget_helper.dart';

import 'package:tpos_mobile/src/tpos_apis/services/tpos_api.dart';

class ChangePassWordDialog extends StatefulWidget {
  const ChangePassWordDialog(this.scaffoldKey);

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _ChangePassWordDialogState createState() => _ChangePassWordDialogState();
}

class _ChangePassWordDialogState extends State<ChangePassWordDialog> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPassWordController = TextEditingController();
  FocusNode oldPasswordFocusNode = FocusNode();
  FocusNode newPasswordFocusNode = FocusNode();
  FocusNode confirmPassWordFocusNode = FocusNode();
  bool isLoading = false;
  bool isFail = false;

  bool isHideOldPassword = true;
  bool isHidenewPassword = true;
  bool isHideConfirmPassword = true;
  String errorText = "Đã xảy ra lỗi vui lòng thử lại";
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Đổi mật khẩu"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (isFail)
              Padding(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    const Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
                    Expanded(
                      child: Text(
                        errorText ?? '',
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  ],
                ),
                padding: const EdgeInsets.only(top: 8),
              )
            else
              const SizedBox(),
            _buildTextField(
              oldPasswordFocusNode,
              newPasswordFocusNode,
              oldPasswordController,
              "Mật khẩu cũ",
              isHideOldPassword,
              GestureDetector(
                onTap: () {
                  setState(() {
                    isHideOldPassword = !isHideOldPassword;
                  });
                },
                child: Icon(
                  isHideOldPassword
                      ? FontAwesomeIcons.eye
                      : FontAwesomeIcons.eyeSlash,
                ),
              ),
            ),
            _buildTextField(
              newPasswordFocusNode,
              confirmPassWordFocusNode,
              newPasswordController,
              "Mật khẩu mới",
              isHidenewPassword,
              GestureDetector(
                onTap: () {
                  setState(() {
                    isHidenewPassword = !isHidenewPassword;
                  });
                },
                child: Icon(
                  isHidenewPassword
                      ? FontAwesomeIcons.eye
                      : FontAwesomeIcons.eyeSlash,
                ),
              ),
            ),
            _buildTextField(
              confirmPassWordFocusNode,
              confirmPassWordFocusNode,
              confirmPassWordController,
              "Xác nhận mật khẩu mới",
              isHideConfirmPassword,
              GestureDetector(
                onTap: () {
                  setState(() {
                    isHideConfirmPassword = !isHideConfirmPassword;
                  });
                },
                child: Icon(
                  isHideConfirmPassword
                      ? FontAwesomeIcons.eye
                      : FontAwesomeIcons.eyeSlash,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        RaisedButton(
          color: Colors.redAccent,
          disabledColor: Colors.grey.shade300,
          onPressed: isLoading ? null : onAcceptTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (isLoading)
                const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(),
                )
              else
                const SizedBox(),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text(
                  "Xác nhận",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        RaisedButton(
          color: Colors.white,
          shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.grey)),
          onPressed: onCloseTap,
          child: const Text(
            "Đóng",
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    FocusNode currentFocusNode,
    FocusNode nextFocusNode,
    TextEditingController controller,
    String labelText,
    bool isHide,
    Widget suffixIcon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextField(
        focusNode: currentFocusNode,
        onSubmitted: (text) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        },
        obscureText: isHide,
        autofocus: true,
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
          suffixIcon: suffixIcon,
        ),
        onChanged: (text) {
          if (isFail = true) {
            setState(() {
              isFail = false;
            });
          }
        },
      ),
    );
  }

  Future onAcceptTap() async {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      isLoading = true;
    });
    try {
      final result = await TposApiService().doChangeUserPassWord(
          oldPassword: oldPasswordController.text,
          newPassword: newPasswordController.text,
          confirmPassWord: confirmPassWordController.text);
      if (result) {
        if (widget.scaffoldKey != null)
          showCusSnackBar(
            currentState: widget.scaffoldKey.currentState,
            child: Row(
              children: const <Widget>[
                Icon(
                  Icons.done,
                  color: Colors.green,
                ),
                Text(
                  "Đã đổi mật khẩu thành công",
                  style: TextStyle(color: Colors.greenAccent),
                ),
              ],
            ),
          );
        Navigator.pop(context);
      } else {
        isFail = true;
      }
    } catch (e) {
      print(e);
      errorText = convertErrorToString(e);
      isFail = true;
      isLoading = false;
      setState(() {});
    }
    isLoading = false;
    setState(() {});
  }

  void onCloseTap() {
    Navigator.pop(context);
  }
}
