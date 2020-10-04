import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_mobile/application/application/language_bloc.dart';

import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';
import 'package:tpos_mobile/helpers/ui_help.dart';
import 'package:tpos_mobile/resources/app_route.dart';
import 'package:tpos_mobile/extensions/extensions.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  static const loginButtonBackgroundColor = Colors.white;
  static const registerButtonBackgroundColor = Color(0xFF28A745);
  static const dotSelectedColor = Color(0xFF75808E);
  static const dotColor = Color(0xFFE9EDF2);

  int currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final List<String> _imageBackGrounds = <String>[
    "images/intro_slide_1.png",
    "images/intro_slide_2.png",
    "images/intro_slide_3.png"
  ];

  final List<Widget> _backGrounds = <Widget>[
    Image.asset(
      "images/group_slide_1.png",
      fit: BoxFit.fill,
    ),
    Image.asset(
      "images/group_slide_2.png",
      fit: BoxFit.fill,
    ),
    Image.asset("images/group_slide_3.png", fit: BoxFit.fill)
  ];

  List<String> get titles => [
        S.current.introPage_page1Title,
        S.current.introPage_page2Title,
        S.current.introPage_page3Title
      ];

  List<String> get contents => [
        S.current.introPage_page1Description,
        S.current.introPage_page2Description,
        S.current.introPage_page3Description,
      ];

  @override
  void initState() {
    super.initState();

    // Timer.periodic(Duration(milliseconds: _timerLoadPage), (Timer timer) {
    //   if (currentPage < 2) {
    //     currentPage++;
    //   } else {
    //     currentPage = 0;
    //   }
    //
    //   _pageController?.animateToPage(
    //     currentPage,
    //     duration: Duration(milliseconds: _timerChangePage),
    //     curve: Curves.easeIn,
    //   );
    // });
  }

  /// Xử lý khi nhấn nút đăng ký
  void _handleRegisterPressed(BuildContext context) {
    //Navigator.of(context).pushNamed(AppRoute.register);
    urlLauch(
        'https://tpos.vn/register-trial/phan-mem-quan-ly-ban-hang-tpos-p1.html');
  }

  /// Xử lý khi nhấn nút đăng nhập
  void _handleLoginPressed(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoute.login);
  }

  @override
  Widget build(BuildContext context) {
    final double _height = MediaQuery.of(context).size.height;
    final double _width = MediaQuery.of(context).size.width;
    double _sizeImage = 0;

    if (_height * 0.4 < _width * 0.95) {
      _sizeImage = _height * 0.4;
    } else {
      _sizeImage = _width * 0.95;
    }

    final Color loginButtonColor = Platform.isIOS
        ? loginButtonBackgroundColor
        : registerButtonBackgroundColor;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            PageView.builder(
                controller: _pageController,
                onPageChanged: (int index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemCount: _imageBackGrounds.length,
                itemBuilder: (BuildContext context, int index) {
                  return Stack(
                    children: <Widget>[
                      Positioned(
                          top: (18 / 850) * _height,
                          left: 0,
                          right: 0,
                          bottom: 0.5 * _height,
                          child: _backGrounds[index]),
                      Positioned(
                          bottom: 0.5 * _height,
                          left: 0,
                          right: 0,
                          child: Image.asset(_imageBackGrounds[index],
                              width: _sizeImage, height: _sizeImage)),
                      Positioned(
                        top: 0.5 * _height,
                        bottom: 0.32 * _height,
                        left: (20 / 850) * _width,
                        right: (20 / 850) * _width,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            AutoSizeText(
                              titles[index],
                              style: const TextStyle(
                                color: Color(0xFF2C333A),
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: AutoSizeText(
                                  contents[index],
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: (18 / 850) * _height,
                        left: 10,
                        right: 10,
                        child: _PageHeader(
                          onLanguagePressed: () {
                            showLanguageSelect(context);
                          },
                        ),
                      ),
                    ],
                  );
                }),
            Positioned(
              top: 0.65 * _height,
              bottom: 16,
              left: 12,
              right: 12,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_imageBackGrounds.length,
                        (index) => Center(child: _buildDot(index: index))),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          if (Platform.isAndroid)
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: registerButtonBackgroundColor,
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
                                    onPressed: () =>
                                        _handleRegisterPressed(context),
                                    child: Text(
                                      S
                                          .of(context)
                                          .introPage_registerButtonTitle,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 12,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xFFEBEDEF)),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: FlatButton(
                                onPressed: () => _handleLoginPressed(context),
                                child: Text(
                                  S.current.introPage_loginButtonTitle,
                                  style: TextStyle(color: loginButtonColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer _buildDot({int index}) {
    return AnimatedContainer(
      duration: const Duration(microseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 12 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? dotSelectedColor : dotColor,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({Key key, this.onLanguagePressed}) : super(key: key);
  final VoidCallback onLanguagePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              "images/tpos_logo.png",
              width: 110,
              height: 25,
            ),
          ),
        ),
        IconButton(
          onPressed: onLanguagePressed,
          icon: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFDD647A),
            ),
            height: 28,
            child: const Center(
              child: Text(
                "VI",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        )
      ],
    );
  }
}
