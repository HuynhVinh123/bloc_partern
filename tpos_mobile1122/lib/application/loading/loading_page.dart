import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_mobile/application/application/aplication_state.dart';
import 'package:tpos_mobile/application/application/application_bloc.dart';
import 'package:tpos_mobile/application/home_page/home_page.dart';
import 'package:tpos_mobile/application/intro_slide/app_intro_page.dart';
import 'package:tpos_mobile/application/loading/app_loading_page.dart';
import 'package:tpos_mobile/application/login/login_page.dart';
import 'package:tpos_mobile/resources/app_route.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicationBloc, ApplicationState>(
      builder: (context, state) {
        if (state is ApplicationLoadSuccess) {
          if (state.isLogin) {
            return HomePage();
          } else if (state.isNeverLogin) {
            return IntroPage();
          } else {
            return LoginPage();
          }
        }
        return const HomeLoadingScreen();
      },
    );
  }
}
