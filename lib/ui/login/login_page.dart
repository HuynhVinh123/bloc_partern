import 'package:flutter/material.dart';

import 'register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final String errText = "Bạn không được để trống!";

  TextEditingController _controllerUserName = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  bool isHidden = false;
  bool showPassword = true;
  bool _serverInvalid = false;
  bool _userInvalid = false;
  bool _passInvalid = false;

  FocusNode _focusNodeUserName = FocusNode();
  FocusNode _focusNodePassword = FocusNode();

  void iconHidden() {
    setState(() {
      isHidden = !isHidden;
      showPassword = !showPassword;
    });
  }

  _validateLogin() {
    bool _checkUsername = _controllerUserName.text.isNotEmpty ? true : false;
    bool _checkPassword = _controllerPassword.text.isNotEmpty ? true : false;

    if (_checkPassword && _checkUsername) {
      setState(() {
        _userInvalid = !_checkUsername;
        _passInvalid = !_checkPassword;
      });
    } else {
      setState(() {
        _userInvalid = !_checkUsername;
        _passInvalid = !_checkPassword;
      });
    }
  }

  Widget _textFiledUserName(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
      child: TextField(
        onSubmitted: (term) {
          _focusNodeUserName.unfocus();
          FocusScope.of(context).requestFocus(_focusNodePassword);
        },
        focusNode: _focusNodeUserName,
        controller: _controllerUserName,
        cursorColor: Colors.lightBlue[400],
        obscureText: false,
        decoration: InputDecoration(
            labelText: 'Tên đăng nhập',
            labelStyle: TextStyle(color: Colors.grey[700], fontSize: 16),
            errorText: _userInvalid ? errText : null),
      ),
    );
  }

  Widget _textFiledPassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
      child: Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[
          TextField(
            onSubmitted: (term) {
              _focusNodeUserName.unfocus();
              _validateLogin();
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
            onTap: iconHidden,
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
              "ĐĂNG NHẬP",
              style: TextStyle(color: Colors.white, fontSize: 17),
            )),
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
                height: 500,
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
                            "ĐĂNG NHẬP",
                            style: TextStyle(
                                color: Colors.lightBlue[600],
                                fontSize: 30,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      _textFiledUserName(context),
                      _textFiledPassword(context),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 30, top: 12),
                          child: Text(
                            "Quên mật khẩu?",
                            style: TextStyle(
                                color: Colors.blue[300], fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _btnLogin(),
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Hoặc đăng nhập với",
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Container(
                              color: Color(0xFF4a6ea9),
                              child: Center(
                                  child: Image.asset(
                                "images/ic_facebook.png",
                                width: 40,
                                height: 40,
                              )),
                            ),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Expanded(
                            child: Container(
                              color: Color(0xFF00ACD4),
                              child: Center(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Image.asset(
                                  "images/icon_zalo.png",
                                  width: 32,
                                  height: 32,
                                ),
                              )),
                            ),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Expanded(
                            child: Container(
                              color: Color(0xFFda4835),
                              child: Center(
                                  child: Image.asset(
                                "images/ic_google.png",
                                width: 40,
                                height: 40,
                              )),
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Bạn chưa có tài khoản? ",
                              style: TextStyle(
                                color: Colors.blue[300],
                                fontSize: 15,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new RegisterPage()),
                                );
                              },
                              child: Text(
                                "Đăng ký",
                                style: TextStyle(
                                    color: Colors.blue[300],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                              ),
                            )
                          ],
                        ),
                      )
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
