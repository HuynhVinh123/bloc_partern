import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_mobile/application/application/aplication_state.dart';
import 'package:tpos_mobile/application/application/application_bloc.dart';
import 'package:tpos_mobile/application/intro_slide/app_intro_page.dart';
import 'package:tpos_mobile/application/login/login_page.dart';
import 'package:tpos_mobile/resources/app_route.dart';

import 'app_loading_page.dart';

/// Return HomePage base on Application State.
class HomeWrapperPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApplicationBloc, ApplicationState>(
      listener: (context, state) {
        if (state is ApplicationLoadSuccess) {
          if (state.isLogin) {
            Navigator.pushNamed(context, AppRoute.home);
          }
        }
      },
      builder: (context, state) {
        if (state is ApplicationLoadSuccess) {
          if (state.isLogin) {
            return const SizedBox();
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
