import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  final bool _isShowError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.loginPage_forgotPassword),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    errorText: _isShowError ? "" : null,
                    labelText: "Email",
                  ),
                  onChanged: (text) {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18, left: 24, right: 24),
                child: Text(
                  S.current.forgotPassword_Notify,
                  textAlign: TextAlign.center,
                ),
              ),
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

  Widget _buildButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
//        color: registerButtonBackgroundColor,
        border: Border.all(
          color: const Color(0xFFEBEDEF),
        ),
        gradient: const LinearGradient(colors: [
          Color(0xff21834A),
          Color(0xff21AD15),
        ]),
        borderRadius: BorderRadius.circular(25),
      ),
      child: FlatButton(
        onPressed: () {},

        /// Xác nhận
        child: Text(
          S.current.forgotPassword_Send,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
