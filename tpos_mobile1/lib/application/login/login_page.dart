import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_mobile/application/application/application_bloc.dart';
import 'package:tpos_mobile/application/application/application_event.dart';

import 'package:tpos_mobile/application/login/login_bloc.dart';
import 'package:tpos_mobile/application/login/login_event.dart';
import 'package:tpos_mobile/application/login/login_state.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';
import 'package:tpos_mobile/helpers/ui_help.dart';
import 'package:tpos_mobile/resources/app_route.dart';
import 'package:tpos_mobile/resources/themes.dart';

import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';
import 'package:tpos_mobile/widgets/button/action_button.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/dialog/app_alert_dialog.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';

import '../for_got_pass_word_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LoginBloc _loginBloc = LoginBloc();
  final FocusNode _shopUrlFocus = FocusNode();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final _shopUrlController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final _scrollController = ScrollController();

  bool _showPassword = false;
  bool _keyboardVisible = false;

  final _boxDecorate = BoxDecoration(
    border: Border.all(
      color: const Color(0xffE9EDF2),
      width: 1.0,
    ),
    borderRadius: BorderRadius.circular(8.0),
  );

  final _inputTextStyle = const TextStyle(fontSize: 16);

  @override
  void initState() {
    _loginBloc.add(LoginLoaded());

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _loginBloc?.close();
    super.dispose();
  }

  void _handleLoginPressed(BuildContext context) {
    _loginBloc.add(
      LoginButtonPressed(
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
        shopUrl:
            'https://${_shopUrlController.text.replaceAll('https://', '').replaceAll('tpos.vn', '')}.tpos.vn',
      ),
    );
  }

  /// Xử lý khi keyboard hiện lên
  Future<void> _onKeyboardOpen() async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent - 50,
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn);
    } catch (e) {
      print(e);
    }
  }

  void _showLoginFailureAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AppAlertDialog(
        title: Text(S.current.loginPage_loginFailTitle),
        content: Text(message),
        type: AlertDialogType.error,
        actions: <Widget>[
          ActionButton(
            child: Text(S.current.close),
            color: const Color(0xffF0F1F3),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardOn = context.isKeyboardOpen;
    if (_keyboardVisible != keyboardOn) {
      _keyboardVisible = keyboardOn;
      if (_keyboardVisible) {
        _onKeyboardOpen();
      }
    }
    return BlocUiProvider<LoginBloc>(
      bloc: _loginBloc,
      busyStates: const [LoginLoading, LoginLogging],
      listen: (state) {
        if (state is LoginLoadSuccess) {
          _shopUrlController.text = state.shopUrl
              .replaceAll('https://', "")
              .replaceAll('.tpos.vn', '');
          _usernameController.text = state.username;
          setState(() {});
        } else if (state is LoginFailure) {
          _showLoginFailureAlert(context, state.message);
        } else if (state is LoginSuccess) {
          // Navigator.of(context).pushNamedAndRemoveUntil(
          //   AppRoute.home,
          //   ModalRoute.withName(AppRoute.home),
          // );

          context.bloc<ApplicationBloc>().add(ApplicationLoaded());
        }
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        body: _showBody(),
      ),
    );
  }

  Widget _showBody() {
    return GestureDetector(
      child: _showLoginPanel(),
      onTap: () {
        FocusScope.of(context)?.requestFocus(FocusNode());
      },
    );
  }

  Widget _showLoginPanel() {
    final _media = MediaQuery.of(context);
    final _padding = _media.size.width * 10 / 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: Center(
            child: Form(
              key: _formKey,
              child: ListView(
                controller: _scrollController,
                shrinkWrap: false,
                padding: EdgeInsets.only(
                    left: _padding, right: _padding, top: 5, bottom: 5),
                physics: const BouncingScrollPhysics(),
                children: <Widget>[
                  _showLogo(),
                  _showHostInput(),
                  _showUserInput(),
                  _showPasswordInput(),
                  Visibility(visible: false, child: _buildForgotPassWord()),
                  _buildLoginNotify(),
                  _buildLoginButton(),

                  //Đăng ký
                  if (Platform.isAndroid)
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20, right: 8, bottom: 8, left: 8),
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            S.current.loginPage_registerButtonTitle,
                            style: TextStyle(color: Colors.blue),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onTap: () async {
                          //await Navigator.pushNamed(context, AppRoute.register);

                          urlLauch(
                              'https://tpos.vn/register-trial/phan-mem-quan-ly-ban-hang-tpos-p1.html');
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  showLanguageSelect(context);
                },
                icon: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFDD647A),
                  ),
                  height: 28,
                  child: const Center(
                    child: Text(
                      "VI",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  urlLauch('tel:19002852');
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      S.of(context).hotline(': '),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Icon(
                      FontAwesomeIcons.phoneAlt,
                      size: 15,
                      color: Colors.green,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Text(
                      '1900 2852',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildForgotPassWord() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (ctx) => ForgotPasswordPage()),
        );
      },
      child: Text(
        S.current.loginPage_forgotPassword,
        textAlign: TextAlign.right,
        style: const TextStyle(color: Colors.blue),
      ),
    );
  }

  Widget _showLogo() {
    return Container(
      padding: const EdgeInsets.only(top: 80, bottom: 10, left: 50, right: 50),
      child: Image.asset("images/tpos_logo_512.png"),
    );
  }

  Widget _showHostInput() {
    return Container(
      decoration: _boxDecorate,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
      child: Row(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Icon(
              Icons.language,
              color: Colors.grey,
            ),
          ),
          Container(
            height: 30.0,
            width: 1.0,
            color: Colors.grey.withOpacity(0.3),
            margin: const EdgeInsets.only(left: 00.0, right: 10.0),
          ),
          Expanded(
            child: StatefulBuilder(
              builder: (a, setState) => Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Row(children: [
                    Text(
                      'https://${_shopUrlController.text}',
                      style: _inputTextStyle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '.tpos.vn',
                      style:
                          _inputTextStyle.copyWith(color: Colors.grey.shade400),
                    ),
                  ]),
                  TextFormField(
                    controller: _shopUrlController,
                    maxLines: 1,
                    keyboardType: TextInputType.url,
                    keyboardAppearance: Brightness.dark,
                    textInputAction: TextInputAction.next,
                    autofocus: false,
                    focusNode: _shopUrlFocus,
                    style: _inputTextStyle,
                    onFieldSubmitted: (tern) {
                      _shopUrlFocus.unfocus();
                      FocusScope.of(context).requestFocus(_usernameFocus);
                    },
                    onChanged: (value) {
                      setState(() {});
                    },
                    validator: (text) {
                      if (text.isEmpty) {
                        return 'Tên miền không được để trống';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixText: 'https://',
                      prefixStyle:
                          _inputTextStyle.copyWith(color: Colors.grey.shade400),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _showUserInput() {
    return Container(
      decoration: _boxDecorate,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
      child: Row(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Icon(
              Icons.person_outline,
              color: Colors.grey,
            ),
          ),
          Container(
            height: 30.0,
            width: 1.0,
            color: Colors.grey.withOpacity(0.3),
            margin: const EdgeInsets.only(left: 00.0, right: 10.0),
          ),
          Expanded(
            child: TextFormField(
              controller: _usernameController,
              maxLines: 1,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              autofocus: false,
              focusNode: _usernameFocus,
              style: _inputTextStyle,
              onFieldSubmitted: (tern) {
                _usernameFocus.unfocus();
                FocusScope.of(context).requestFocus(_passwordFocus);
              },
              decoration: InputDecoration(
                hintText: S.current.username,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showPasswordInput() {
    return Container(
      decoration: _boxDecorate,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
      child: Row(
        children: <Widget>[
          const Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Icon(
              Icons.lock_open,
              color: Colors.grey,
            ),
          ),
          Container(
            height: 30.0,
            width: 1.0,
            color: Colors.grey.withOpacity(0.3),
            margin: const EdgeInsets.only(left: 00.0, right: 10.0),
          ),
          Expanded(
            child: TextFormField(
              controller: _passwordController,
              maxLines: 1,
              obscureText: !_showPassword,
              autofocus: false,
              focusNode: _passwordFocus,
              textInputAction: TextInputAction.done,
              style: _inputTextStyle,
              decoration: InputDecoration(
                hintText: S.current.password,
                border: InputBorder.none,
              ),
              onEditingComplete: () {
                _handleLoginPressed(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              child: Icon(
                Icons.remove_red_eye,
                color: _showPassword ? Colors.green : Colors.grey.shade500,
              ),
              onTap: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginNotify() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      if (state is LoginValidateFailure) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            state.message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        );
      }
      return const SizedBox();
    });
  }

  Widget _buildLoginButton({bool enable = true}) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xff21834A),
              Color(0xff21AD15),
            ],
          ),
          boxShadow: [
            const BoxShadow(
              offset: const Offset(0, 2),
              blurRadius: 3,
              color: AppTheme.primary1Color,
            ),
          ],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.circular(30),
            onTap: () => _handleLoginPressed(context),
            child: Center(
              child: Text(
                S.current.introPage_loginButtonTitle.toUpperCase(),
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
