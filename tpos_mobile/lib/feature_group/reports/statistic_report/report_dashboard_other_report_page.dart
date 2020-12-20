import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_mobile/application/menu/menu_widget.dart';
import 'package:tpos_mobile/application/menu/normal_menu_item_wrap.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';
import 'package:tpos_mobile/resources/app_colors.dart';
import 'package:tpos_mobile/resources/menus.dart';
import 'package:tpos_mobile/services/cache_service.dart';

class ReportDashboardOtherReportPage extends StatefulWidget {
  @override
  _ReportDashboardOtherReportPageState createState() =>
      _ReportDashboardOtherReportPageState();
}

class _ReportDashboardOtherReportPageState
    extends State<ReportDashboardOtherReportPage> {
  List<MenuItem> _reportMenus = <MenuItem>[];
  @override
  void initState() {
    try {
      _reportMenus = applicationMenu
          .where((element) =>
              element.type == MenuGroupType.report && element.visible == true)
          .where(
            (element) =>
                GetIt.instance<CacheService>()
                    .functions
                    .contains(element.permission) ||
                element.permission == null,
          )
          .toList();
    } catch (e) {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.7),
          body: Container(
            margin: const EdgeInsets.only(top: 40, bottom: 40),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.1, sigmaY: 3.1),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: media.size.height),
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 21, bottom: 22),
                                child: NormalMenuItemWrap(
                                  onReorder: (a1, a2) {},
                                  contentPadding: const EdgeInsets.only(
                                    left: 16,
                                    right: 16,
                                    top: 64,
                                    bottom: 16,
                                  ),
                                  children: _reportMenus
                                      .map(
                                        (e) => NormalMenuItem(
                                          hasPermission: true,
                                          canDelete: false,
                                          name: e.name(),
                                          icon: e.icon,
                                          iconColor: e.type.backgroundColor,
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              e.route,
                                            );
                                          },
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                              SizedBox(
                                height: 42,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: AppColors.primary1,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 26, right: 26),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        const Icon(
                                          FontAwesomeIcons.chartBar,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Text(
                                          S.current.report_reportList,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: SizedBox(
                              width: double.infinity,
                              child: FlatButton(
                                color: Colors.white,
                                textColor: Colors.black,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(S.current.close),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
