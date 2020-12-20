import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';

import 'package:tpos_mobile/application/application/application_bloc.dart';
import 'package:tpos_mobile/application/application/application_event.dart';
import 'package:tpos_mobile/application/home_page/home_page_bloc.dart';
import 'package:tpos_mobile/application/home_page/home_page_event.dart';
import 'package:tpos_mobile/application/home_page/home_page_state.dart';
import 'package:tpos_mobile/application/home_personal_page.dart';
import 'package:tpos_mobile/application/loading/app_loading_page.dart';
import 'package:tpos_mobile/application/menu/menu_page.dart';
import 'package:tpos_mobile/application/menu_v2/home_page_wrapper.dart';
import 'package:tpos_mobile/application/menu_v2/menu_v2_page.dart';
import 'package:tpos_mobile/application/notification_page/notification_bloc.dart';
import 'package:tpos_mobile/application/notification_page/notification_event.dart';
import 'package:tpos_mobile/application/notification_page/notification_state.dart';
import 'package:tpos_mobile/application/report_dashboard_page.dart';
import 'package:tpos_mobile/helpers/svg_icon.dart';
import 'package:tpos_mobile/resources/app_colors.dart';
import 'package:tpos_mobile/resources/tpos_mobile_icons.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';

import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';
import 'package:tpos_mobile/application/notification_page/notification_page.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import '../notification_popup_dialog_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  HomeBloc _homeBloc;

  bool _popupRead = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _homeBloc.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_homeBloc == null) {
      _homeBloc = BlocProvider.of<HomeBloc>(context);
      _homeBloc.add(HomeLoaded());
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocUiProvider<HomeBloc>(
      bloc: _homeBloc,
      listen: (state) async {
        if (state is HomeLoadFailure) {
          _showLoadingFailureDialog(context);
        } else if (state is HomeRequestLogout) {
          BlocProvider.of<ApplicationBloc>(context).add(ApplicationLogout());
        } else if (state is HomeLoadSuccess) {
          context.read<NotificationBloc>().add(
                NotificationLoaded(waitSecond: 3),
              );
        }
      },
      child: BlocListener<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state is NotificationLoadSuccess) {
            if (state.notificationResult.popup != null && _popupRead == false) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return NotificationPopupDialogPage(
                      notification: state.notificationResult.popup,
                    );
                  },
                ),
              );
              _popupRead = true;
            }
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading || state is HomeUnInitial) {
              return Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Scaffold(
              bottomNavigationBar: _buildBottomNavigationBar(),
              body: _buildBody(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    switch (_currentIndex) {
      case 0:
        if (GetIt.instance<ConfigService>().homePageStyle == "style1") {
          return const HomePageWrapper();
        }
        return MenuPage();

      case 1:
        return ReportDashboardPage();
      case 2:
        return const NotificationPage();
      case 3:
        return HomePersonalPage();
      default:
        return const SizedBox();
    }
  }

  // final List<Widget> _pages = [
  //   MenuPage(),
  //   ReportDashboardPage(),
  //   const NotificationPage(),
  //   HomePersonalPage(),
  // ];

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xff28A745),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: SvgIcon(SvgIcon.homeNavigation,
                  color: _currentIndex == 0
                      ? AppColors.bottomNavigationSelectedColor
                      : AppColors.bottomNavigationColor),
            ),
            backgroundColor: Colors.green,
            label: S.current.function,
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: SvgIcon(SvgIcon.reportNavigation,
                  color: _currentIndex == 1
                      ? AppColors.bottomNavigationSelectedColor
                      : AppColors.bottomNavigationColor),
            ),
            backgroundColor: Colors.green,
            label: S.current.statistics,
          ),
          BottomNavigationBarItem(
            icon: BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, NotificationState notificationState) {
                final tab = Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: SvgIcon(SvgIcon.notificationNavigation,
                      color: _currentIndex == 2
                          ? AppColors.bottomNavigationSelectedColor
                          : AppColors.bottomNavigationColor),
                );
                if (notificationState is NotificationLoadSuccess) {
                  return Badge(
                    showBadge: notificationState.notificationResult.count != 0,
                    badgeContent: Text(
                      notificationState.notificationResult.count.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    position: BadgePosition.topEnd(),
                    alignment: Alignment.bottomRight,
                    child: tab,
                  );
                }
                return tab;
              },
            ),
            backgroundColor: Colors.green,
            label: S.current.notification,
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Icon(TPosIcons.user_fill,
                  color: _currentIndex == 3
                      ? AppColors.bottomNavigationSelectedColor
                      : AppColors.bottomNavigationColor),
            ),
            backgroundColor: Colors.green,
            label: S.current.personal,
          ),
        ]);
  }

  void _showLoadingFailureDialog(BuildContext contextHome) {
    showDialog(
        useRootNavigator: false,
        context: contextHome,
        builder: (context) {
          return AlertDialog(
            titlePadding: const EdgeInsets.only(left: 24, right: 20, top: 12),
            insetPadding: const EdgeInsets.all(12),
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(width: 0, color: Colors.white70)),
            title: Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  Navigator.pop(contextHome);
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.grey,
                ),
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: SvgIcon(
                      SvgIcon.dialogMainPage,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      S.current.homePage_connectError,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text("${S.current.homePage_cannotConnectToServerBecause}:"),
                  Text("-${S.current.network_noInternetConnection}."),
                  Text("-${S.current.homePage_serverIsNotActive}"),
                  const SizedBox(
                    height: 28,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 12,
                            ),
                            CircleAvatar(
                                backgroundColor: Color(0xFFF8F9FB),
                                child: SvgIcon(
                                  SvgIcon.wifiConnection,
                                )),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Text(
                                S.current.homePage_viewConnectWifi,
                                style: const TextStyle(
                                    color: Color(0xFF929DAA), fontSize: 14),
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 12,
                            ),
                            CircleAvatar(
                              backgroundColor: Color(0xFFF8F9FB),
                              child: SvgIcon(
                                SvgIcon.callPerson,
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Text(
                                S.current.homePage_contactToTPos,
                                style: const TextStyle(
                                    color: Color(0xFF929DAA), fontSize: 14),
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            actions: <Widget>[
              Container(
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: const Color(0xFF28A745),
                  ),
                  child: FlatButton.icon(
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                    label: Center(
                        child: Text(
                      S.current.retry,
                      style: const TextStyle(color: Colors.white),
                    )),
                    onPressed: () {
                      Navigator.pop(contextHome);
                      _homeBloc.add(HomeLoaded());
                    },
                  ))
            ],
          );
        });
  }
}

class PageTransition extends StatefulWidget {
  const PageTransition({this.child, Key key}) : super(key: key);
  final Widget child;

  @override
  _PageTransitionState createState() => _PageTransitionState();
}

class _PageTransitionState extends State<PageTransition>
    with TickerProviderStateMixin {
  AnimationController _pageAnimController;
  Animation<double> animation;

  @override
  void initState() {
    _pageAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    animation =
        CurvedAnimation(parent: _pageAnimController, curve: Curves.easeIn);
    _pageAnimController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: animation, child: widget.child);
  }

  @override
  void dispose() {
    _pageAnimController.dispose();
    super.dispose();
  }
}
