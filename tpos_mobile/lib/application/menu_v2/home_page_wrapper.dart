import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_mobile/application/home_page/home_page_bloc.dart';
import 'package:tpos_mobile/application/home_page/home_page_event.dart';
import 'package:tpos_mobile/application/home_page/home_page_state.dart';
import 'package:tpos_mobile/application/menu/menu_alert.dart';
import 'package:tpos_mobile/application/menu_v2/menu_v2_page.dart';

/// Dùng để bọc nội dung home page như là menu_page. Các nội dung thôi báo sẽ hiện ở đây
class HomePageWrapper extends StatefulWidget {
  const HomePageWrapper({Key key, this.child}) : super(key: key);
  final Widget child;

  @override
  _HomePageWrapperState createState() => _HomePageWrapperState();
}

class _HomePageWrapperState extends State<HomePageWrapper> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Expanded(child: MenuV2Page()),
          _buildNotifyMenu(),
        ],
      ),
    );
  }

  Widget _buildNotifyMenu() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (last, current) =>
                current is HomeLoadSuccess || current is HomeLoadFailure,
            builder: (context, state) {
              if (state is HomeLoadSuccess && state.isExprired == true) {
                return MenuAlertExpired(
                  expiredDay: state.expriredTime,
                );
              } else if (state is HomeLoadFailure) {
                return MenuAlertLoadingFailure(
                  message: state.message,
                  onReload: () {
                    BlocProvider.of<HomeBloc>(context).add(
                      HomeLoaded(),
                    );
                  },
                );
              } else {
                return const SizedBox();
              }
            }),
      ],
    );
  }
}
