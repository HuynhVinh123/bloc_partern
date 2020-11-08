import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_mobile/application/application/application_bloc.dart';
import 'package:tpos_mobile/application/change_password/change_pass_word_bloc.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';
import 'package:tpos_mobile/widgets/button/action_button.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/dialog/app_alert_dialog.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import 'application/application_event.dart';
import 'change_password/change_pass_word_event.dart';
import 'change_password/change_password_state.dart';

class ChangePassWordPage extends StatefulWidget {
  const ChangePassWordPage({this.oldPassword});
  final String oldPassword;

  @override
  _ChangePassWordPageState createState() => _ChangePassWordPageState();
}

class _ChangePassWordPageState extends State<ChangePassWordPage> {
  final _bloc = ChangePasswordBloc();

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPassWordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _oldPasswordFocusNode = FocusNode();
  final FocusNode _newPasswordFocusNode = FocusNode();
  final FocusNode _confirmPassWordFocusNode = FocusNode();

  bool _isHideOldPassword = true;
  bool _isHideNewPassword = true;
  bool _isHideConfirmPassword = true;

  bool _isShowError = false;

  /// Mật khẩu không được để trống
  final String _errorText = S.current.changePassword_isNotEmpty;

  /// Mật khẩu phải lớn hơn 6 kí tự
  final String _errorTextCharacter6 = S.current.changePassword_characterLength6;

  /// Mật khẩu phải nhỏ hơn 36 kí tự
  final String _errorTextCharacter36 =
      S.current.changePassword_characterLength36;

  @override
  Widget build(BuildContext context) {
    return BlocUiProvider<ChangePasswordBloc>(
      bloc: _bloc,
      listen: (state) {
        if (state is ChangePasswordFailure) {
          _showLoginFailureAlert(context, state.content, state.title);
        } else if (state is ChangePasswordSuccess) {
          BlocProvider.of<ApplicationBloc>(context).add(ApplicationLogout());
        }
      },
      child: Scaffold(

          /// Thay đổi mật khẩu
          appBar: AppBar(
            title: Text(S.current.changePassword_changePassword),
          ),
          body: _buildBody()),
    );
  }

  Widget _buildBody() {
    return BlocLoadingScreen<ChangePasswordBloc>(
      busyStates: const [ChangePasswordLoading],
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: <Widget>[
              /// Mật khẩu cũ
              _buildTextField(
                currentFocusNode: _oldPasswordFocusNode,
                nextFocusNode: _newPasswordFocusNode,
                controller: _oldPasswordController,
                isHide: _isHideOldPassword,
                labelText: S.current.changePassword_oldPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    !_isHideOldPassword
                        ? FontAwesomeIcons.eyeSlash
                        : Icons.remove_red_eye,
                    size: 18,
                  ),
                  onPressed: () {
                    setState(() {
                      _isHideOldPassword = !_isHideOldPassword;
                    });
                  },
                ),
              ),

              /// Mật khẩu mới
              _buildTextField(
                  currentFocusNode: _newPasswordFocusNode,
                  nextFocusNode: _confirmPassWordFocusNode,
                  controller: _newPassWordController,
                  isHide: _isHideNewPassword,
                  labelText: S.current.changePassword_newPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      !_isHideNewPassword
                          ? FontAwesomeIcons.eyeSlash
                          : Icons.remove_red_eye,
                      size: 18,
                    ),
                    onPressed: () {
                      setState(() {
                        _isHideNewPassword = !_isHideNewPassword;
                      });
                    },
                  ),
                  isErrorCharacter: true),

              /// Xác nhận mật khẩu
              _buildTextField(
                  labelText: S.current.changePassword_confirmPassword,
                  currentFocusNode: _confirmPassWordFocusNode,
                  controller: _confirmPasswordController,
                  isHide: _isHideConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      !_isHideConfirmPassword
                          ? FontAwesomeIcons.eyeSlash
                          : Icons.remove_red_eye,
                      size: 18,
                    ),
                    onPressed: () {
                      setState(() {
                        _isHideConfirmPassword = !_isHideConfirmPassword;
                      });
                    },
                  ),
                  isErrorCharacter: true,
                  isConfirm: true),
              const SizedBox(
                height: 38,
              ),
              _buildButton()
            ],
          ),
        ),
      ),
    );
  }

  void confirmChangePassword() {
    setState(() {
      _isShowError = true;
    });
    if (_confirmPasswordController.text != "" &&
        _newPassWordController.text != "" &&
        _oldPasswordController.text != "") {
      if ((_newPassWordController.text.length > 6 &&
              _newPassWordController.text.length < 36) &&
          (_confirmPasswordController.text.length > 6 &&
              _confirmPasswordController.text.length < 36)) {
        if (_newPassWordController.text == _confirmPasswordController.text) {
          _bloc.add(ChangePassWordLoaded(
              oldPassword: _oldPasswordController.text,
              newPassword: _newPassWordController.text,
              confirmPassWord: _confirmPasswordController.text));
        }
      }
    }
  }

  Widget _buildButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
//        color: registerButtonBackgroundColor,
        border: Border.all(
          color: const Color(0xFFEBEDEF),
        ),
        gradient:  LinearGradient(colors: [
          Color(0xff21834A),
          Color(0xff21AD15),
        ]),
        borderRadius: BorderRadius.circular(25),
      ),
      child: FlatButton(
        onPressed: () {
          confirmChangePassword();
        },

        /// Xác nhận
        child: Text(
          S.current.save,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {FocusNode currentFocusNode,
      FocusNode nextFocusNode,
      TextEditingController controller,
      String labelText,
      bool isHide,
      Widget suffixIcon,
      bool isErrorCharacter = false,
      bool isConfirm = false}) {
    currentFocusNode.addListener(() {
      if (currentFocusNode.hasFocus) {
        setState(() {});
      }
    });
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextField(
        focusNode: currentFocusNode,
        onSubmitted: (text) {
          if (nextFocusNode != null)
            FocusScope.of(context).requestFocus(nextFocusNode);
        },
        obscureText: isHide,
        autofocus: true,
        controller: controller,
        decoration: InputDecoration(
          errorText: checkError(controller, isErrorCharacter, isConfirm),
          labelText: labelText,
          suffixIcon: suffixIcon,
        ),
        onChanged: (text) {
//          if (isFail = true) {
//            setState(() {
//              isFail = false;
//            });
//          }
        },
      ),
    );
  }

  String checkError(
      TextEditingController controller, bool isErrorCharacter, bool isConfirm) {
    if (_isShowError) {
      if (controller.text == "") {
        return _errorText;
      } else {
        if (controller.text.length <= 6 && isErrorCharacter) {
          return _errorTextCharacter6;
        } else if (controller.text.length >= 36 && isErrorCharacter) {
          return _errorTextCharacter36;
        } else if (_newPassWordController.text !=
                _confirmPasswordController.text &&
            isErrorCharacter &&
            isConfirm) {
          return S.current.changePassword_confirmPasswordError;
        }
      }
    }

    return null;
  }

  void _showLoginFailureAlert(
      BuildContext context, String message, String title) {
    showDialog(
      context: context,
      builder: (context) => AppAlertDialog(
        title: Text(title),
        content: Text(message),
        type: AlertDialogType.error,
        actions: <Widget>[
          ActionButton(
            child: Text(S.current.changePassword_confirm),
            color: const Color(0xffF0F1F3),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
