import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:tpos_mobile/application/application/application_bloc.dart';
import 'package:tpos_mobile/application/application/application_event.dart';
import 'package:tpos_mobile/application/home_page/home_page_bloc.dart';
import 'package:tpos_mobile/application/home_page/home_page_event.dart';
import 'package:tpos_mobile/application/home_page/home_page_state.dart';
import 'package:tpos_mobile/application/home_personal_page.dart';
import 'package:tpos_mobile/application/loading/app_loading_page.dart';
import 'package:tpos_mobile/application/menu/menu_page.dart';
import 'package:tpos_mobile/application/notification_page/notification_bloc.dart';
import 'package:tpos_mobile/application/notification_page/notification_event.dart';
import 'package:tpos_mobile/application/notification_page/notification_state.dart';
import 'package:tpos_mobile/application/report_dashboard_page.dart';
import 'package:tpos_mobile/feature_group/reports/statistic_report/report_dashboard_other_report_page.dart';
import 'package:tpos_mobile/resources/app_colors.dart';

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
      _homeBloc ??= BlocProvider.of<HomeBloc>(context);
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
          await Future.delayed(const Duration(seconds: 3));
          context.bloc<NotificationBloc>().add(
                NotificationLoaded(),
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
              return const HomeLoadingScreen();
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
              child: SvgPicture.asset(
                'assets/icon/bottom_navigation_icon_home.svg',
                color: _currentIndex == 0
                    ? AppColors.bottomNavigationSelectedColor
                    : AppColors.bottomNavigationColor,
              ),
            ),
            backgroundColor: Colors.green,
            title: Text(S.current.function),
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: SvgPicture.asset(
                'assets/icon/bottom_navigation_icon_report.svg',
                color: _currentIndex == 1
                    ? AppColors.bottomNavigationSelectedColor
                    : AppColors.bottomNavigationColor,
              ),
            ),
            backgroundColor: Colors.green,
            title: Text(S.current.statistics),
          ),
          BottomNavigationBarItem(
            icon: BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, NotificationState notificationState) {
                final tab = Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: SvgPicture.asset(
                    'assets/icon/bottom_navigation_notification.svg',
                    color: _currentIndex == 2
                        ? AppColors.bottomNavigationSelectedColor
                        : AppColors.bottomNavigationColor,
                  ),
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
            title: Text(
              S.current.notification,
            ),
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: SvgPicture.asset(
                'assets/icon/bottom_navigation_user.svg',
                color: _currentIndex == 3
                    ? AppColors.bottomNavigationSelectedColor
                    : AppColors.bottomNavigationColor,
              ),
            ),
            backgroundColor: Colors.green,
            title: Text(S.current.personal),
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
                borderSide: BorderSide(width: 0, color: Colors.white70)),
            title: Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  Navigator.pop(contextHome);
                },
                child: Icon(
                  Icons.close,
                  color: Colors.grey,
                ),
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SvgPicture.asset(
                        "assets/icon/icon_dialog_main_page.svg"),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Lỗi kết nối",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                      "Không thể kết nối đến máy chủ do những nguyên nhân sau:"),
                  const Text("-Thiết bị của bạn không có kết nối mạng."),
                  const Text(
                      "-Máy chủ không ổn định tại thời điểm hiện tại. Bạn vui lòng thử kiểm tra kết nối mạng và tải lại hoặc liên hệ với Tpos để được hỗ trợ thêm."),
                  const SizedBox(
                    height: 28,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 12,
                            ),
                            CircleAvatar(
                              backgroundColor: const Color(0xFFF8F9FB),
                              child: SvgPicture.asset(
                                "assets/icon/wifi_connection.svg",
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            const Expanded(
                              child: Text(
                                "Xem kết nối wifi",
                                style: TextStyle(
                                    color: Color(0xFF929DAA), fontSize: 14),
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 12,
                            ),
                            CircleAvatar(
                              backgroundColor: const Color(0xFFF8F9FB),
                              child: SvgPicture.asset(
                                "assets/icon/call_person.svg",
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            const Expanded(
                              child: Text(
                                "Liên hệ với TPos",
                                style: TextStyle(
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
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                    label: const Center(
                        child: Text(
                      "Thử lại",
                      style: TextStyle(color: Colors.white),
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
