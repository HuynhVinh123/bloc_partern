import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final String errText = "Bạn không được để trống!";

  TextEditingController _controllerUserName = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerPhone = TextEditingController();
  TextEditingController _controllerConfirmPass = TextEditingController();

  bool isHidden = false;
  bool isConfirmHidden = false;
  bool showPassword = true;
  bool showConfirmPassword = true;
  bool _userInvalid = false;
  bool _passInvalid = false;
  bool _nameInvalid = false;
  bool _phoneInvalid = false;
  bool _confirmPassInvalid = false;
  bool _addressInvalid = false;
  bool _noteInvalid = false;

  FocusNode _focusNodeUserName = FocusNode();
  FocusNode _focusNodePassword = FocusNode();
  FocusNode _focusNodeName = FocusNode();
  FocusNode _focusNodePhone = FocusNode();
  FocusNode _focusNodeConfirmPassword = FocusNode();

  void iconHidden(bool isConfirmPass) {
    setState(() {
      if (isConfirmPass) {
        isConfirmHidden = !isConfirmHidden;
        showConfirmPassword = !showConfirmPassword;
      } else {
        isHidden = !isHidden;
        showPassword = !showPassword;
      }
    });
  }

  _validateLogin() {
    bool _checkUsername = _controllerUserName.text.isNotEmpty ? true : false;
    bool _checkPassword = _controllerPassword.text.isNotEmpty ? true : false;
    bool _checkName = _controllerName.text.isNotEmpty ? true : false;
    bool _checkPhone = _controllerPhone.text.isNotEmpty ? true : false;
    bool _checkConfirmPass =
        _controllerConfirmPass.text.isNotEmpty ? true : false;

    if (_checkPassword &&
        _checkUsername &&
        _checkName &&
        _checkPhone &&
        _checkConfirmPass) {
      setState(() {
        _userInvalid = !_checkUsername;
        _passInvalid = !_checkPassword;
        _phoneInvalid = !_checkPhone;
        _confirmPassInvalid = !_checkConfirmPass;

        _nameInvalid = !_checkName;
      });
    } else {
      setState(() {
        _userInvalid = !_checkUsername;
        _passInvalid = !_checkPassword;
        _phoneInvalid = !_checkPhone;
        _confirmPassInvalid = !_checkConfirmPass;
        _nameInvalid = !_checkName;
      });
    }
  }

  Widget _textFiledSDT(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 4),
      child: TextField(
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ],
        onSubmitted: (term) {
          _focusNodePhone.unfocus();
          FocusScope.of(context).requestFocus(_focusNodePassword);
        },
        focusNode: _focusNodePhone,
        controller: _controllerPhone,
        cursorColor: Colors.lightBlue[400],
        obscureText: false,
        decoration: InputDecoration(
            labelText: 'Số điện thoại',
            labelStyle: TextStyle(color: Colors.grey[700], fontSize: 16),
            errorText: _phoneInvalid ? errText : null),
      ),
    );
  }

  Widget _textFiledName(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 4),
      child: TextField(
        onSubmitted: (term) {
          _focusNodeName.unfocus();
          FocusScope.of(context).requestFocus(_focusNodeUserName);
        },
        focusNode: _focusNodeName,
        controller: _controllerName,
        cursorColor: Colors.lightBlue[400],
        obscureText: false,
        decoration: InputDecoration(
            labelText: 'Họ tên',
            labelStyle: TextStyle(color: Colors.grey[700], fontSize: 16),
            errorText: _nameInvalid ? errText : null),
      ),
    );
  }

  Widget _textFiledUserName(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 4),
      child: TextField(
        onSubmitted: (term) {
          _focusNodeUserName.unfocus();
          FocusScope.of(context).requestFocus(_focusNodePhone);
        },
        focusNode: _focusNodeUserName,
        controller: _controllerUserName,
        cursorColor: Colors.lightBlue[400],
        obscureText: false,
        decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: TextStyle(color: Colors.grey[700], fontSize: 16),
            errorText: _userInvalid ? errText : null),
      ),
    );
  }

  Widget _textFiledConfirmPassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 4),
      child: Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          TextField(
            onSubmitted: (term) {
              _focusNodeConfirmPassword.unfocus();
            },
            focusNode: _focusNodeConfirmPassword,
            controller: _controllerConfirmPass,
            obscureText: showConfirmPassword,
            decoration: InputDecoration(
                labelText: 'Nhập lại mật khẩu',
                labelStyle: TextStyle(color: Colors.grey[700], fontSize: 16),
                errorText: _confirmPassInvalid ? errText : null),
          ),
          GestureDetector(
            onTap: () {
              iconHidden(true);
            },
            child: Icon(
              !isConfirmHidden ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _textFiledPassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 4),
      child: Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          TextField(
            onSubmitted: (term) {
              _focusNodePassword.unfocus();
              FocusScope.of(context).requestFocus(_focusNodeConfirmPassword);
            },
            focusNode: _focusNodePassword,
            controller: _controllerPassword,
            obscureText: showPassword,
            decoration: InputDecoration(
                labelText: 'Mật khẩu',
                labelStyle: TextStyle(color: Colors.grey[700], fontSize: 16),
                errorText: _passInvalid ? errText : null),
          ),
          GestureDetector(
            onTap: () {
              iconHidden(false);
            },
            child: Icon(
              !isHidden ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _paintCircleOne(var height, var width) {
    return Positioned(
      right: 0,
      top: height * 0.3,
      child: Container(
        height: width * 0.6,
        width: width * 0.6,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Colors.white.withOpacity(0.3)),
      ),
    );
  }

  Widget _paintCircleTwo(var height, var width) {
    return Positioned(
      left: width * 0.15,
      top: -width * 0.5,
      child: Container(
        height: width * 1.6,
        width: width * 1.6,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.4),
        ),
      ),
    );
  }

  Widget _paintCircleThree(var height, var width) {
    return Positioned(
      right: -width * 0.2,
      top: -50,
      child: Container(
        height: width * 0.6,
        width: width * 0.6,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.6),
        ),
      ),
    );
  }

  Widget _btnLogin() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 180,
        height: 45,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
                colors: [Colors.lightBlue[500], Colors.lightBlue[100]])),
        child: FlatButton(
            splashColor: Colors.grey[100],
            onPressed: () {
              _validateLogin();
            },
            child: Text(
              "ĐĂNG KÝ",
              style: TextStyle(color: Colors.white, fontSize: 17),
            )),
      ),
    );
  }

  Widget _showOptionSex() {
    return Container(
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 12,
          ),
          new Radio(
            value: 0,
            groupValue: 0,
            onChanged: (value) {},
          ),
          new Text(
            'Nam',
            style: new TextStyle(fontSize: 16.0),
          ),
          new Radio(
            value: 1,
            groupValue: 0,
            onChanged: (value) {},
          ),
          new Text(
            'Nữ',
            style: new TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height / 2;
    final width = MediaQuery.of(context).size.width / 2;
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          ClipPath(
            clipper: MyClipper(),
            child: Container(
              height: 350,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.lightBlue[600], Colors.blue[200]])),
            ),
          ),
          _paintCircleOne(height, width),
          _paintCircleTwo(height, width),
          _paintCircleThree(height, width),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.85,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[300],
                          offset: Offset(0, 3),
                          blurRadius: 3)
                    ]),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            "ĐĂNG KÝ",
                            style: TextStyle(
                                color: Colors.lightBlue[600],
                                fontSize: 30,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      _textFiledName(context),
                      _textFiledUserName(context),
                      _textFiledSDT(context),
                      _textFiledPassword(context),
                      _textFiledConfirmPassword(context),
                      _showOptionSex(),
                      SizedBox(
                        height: 20,
                      ),
                      _btnLogin(),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 100);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
