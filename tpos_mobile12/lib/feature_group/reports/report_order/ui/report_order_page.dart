import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_datetime.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_drawer.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_panel.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/filter/filter_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/filter/filter_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/filter/filter_state.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/report_order_detail_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/report_order_employee_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/report_order_overview_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/report_order_partner_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/user_report_staff_list_page.dart';

import 'package:tpos_mobile/feature_group/sale_online/ui/partner_search_page.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import '../report_order_event.dart';
import 'company_of_user_list_page.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/src/tpos_apis/models/company_of_user.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter.dart';
import 'package:tpos_mobile/src/tpos_apis/models/user_report_staff.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';

import '../report_order_bloc.dart';
import '../report_order_state.dart';

class ReportOrderPage extends StatefulWidget {
  @override
  _ReportOrderPageState createState() => _ReportOrderPageState();
}

class _ReportOrderPageState extends State<ReportOrderPage>
    with TickerProviderStateMixin {
  final _bloc = ReportOrderBloc();
  final _filterBloc = FilterBloc();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TabController _tabController;

  final int _limit = 20;
  final int _skip = 0;
  final Filter _filter = Filter();
  int _count = 1;

  @override
  void initState() {
    _filter.filterDateRange = getTodayDateFilter();
    _filter.dateFrom = _filter.filterDateRange.fromDate;
    _filter.dateTo = _filter.filterDateRange.toDate;
    _filter.userReportStaffOrder = UserReportStaff();
    _filter.companyOfUser = CompanyOfUser();
    _filter.partner = Partner();
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _filterBloc.add(FilterLoaded());
  }

  void _countFilter(FilterLoadSuccess state) {
    if (state.isConfirm) {
      _count = 1;
      if (state.isFilterByInvoiceType != null && state.isFilterByInvoiceType) {
        _count++;
      }
      if (state.isFilterByPartner != null && state.isFilterByPartner) {
        _count++;
      }
      if (state.isFilterByStaff != null && state.isFilterByStaff) {
        _count++;
      }
      if (state.isFilterByCompany != null && state.isFilterByCompany) {
        _count++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocUiProvider<ReportOrderBloc>(
        bloc: _bloc,
        listen: (state) {
          if (state is ReportOrderLoadFailure) {
            showError(
                title: state.title, message: state.content, context: context);
          }
        },
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: const Color(0xFfEBEDEF),
          endDrawer: _buildFilterPanel(),
          appBar: AppBar(
            backgroundColor: const Color(0xFF008E30),

            /// Thống kê hóa đơn
            title: Text(S.current.reportOrder_invoiceStatistics),
            actions: <Widget>[
              BlocBuilder<FilterBloc, FilterState>(
                  cubit: _filterBloc,
                  builder: (context, state) {
                    if (state is FilterLoadSuccess) {
                      _countFilter(state);
                      return InkWell(
                        onTap: () {
                          scaffoldKey.currentState.openEndDrawer();
                        },
                        child: Badge(
                          position: BadgePosition(top: 4, end: -4),
                          padding: const EdgeInsets.all(4),
                          badgeColor: Colors.redAccent,
                          badgeContent: Text(
                            _count.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          child: const Icon(
                            Icons.filter_list,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  }),
              const SizedBox(
                width: 18,
              )
            ],
          ),
          body: Column(
            children: <Widget>[
              Material(
                color: Colors.white,
                child: TabBar(
                    controller: _tabController,
                    indicatorColor: const Color(0xFF28A745),
                    labelColor: const Color(0xFF28A745),
                    unselectedLabelColor: Colors.black54,
                    dragStartBehavior: DragStartBehavior.down,
                    tabs: <Widget>[
                      /// Tổng quan
                      Tab(
                        text: S.current.reportOrder_Overview,
                      ),

                      /// Chi tiết
                      Tab(
                        text: S.current.reportOrder_Detail,
                      ),

                      /// Khách hàng
                      Tab(
                        text: S.current.partner,
                      ),

                      /// Nhân viên
                      Tab(
                        text: S.current.employee,
                      ),
                    ]),
              ),
              Expanded(
                  child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  ReportOrderOverViewPage(
                    bloc: _bloc,
                    filterBloc: _filterBloc,
                    scaffoldKey: scaffoldKey,
                  ),
                  ReportOrderDetailPage(
                    bloc: _bloc,
                    filterBloc: _filterBloc,
                    scaffoldKey: scaffoldKey,
                    filter: _filter,
                  ),
                  ReportOrderPartnerPage(
                      bloc: _bloc,
                      filterBloc: _filterBloc,
                      scaffoldKey: scaffoldKey),
                  ReportOrderEmployeePage(
                      bloc: _bloc,
                      filterBloc: _filterBloc,
                      scaffoldKey: scaffoldKey)
                ],
              )),
            ],
          ),
        ));
  }

  Widget _buildFilterPanel() {
    return BlocBuilder<FilterBloc, FilterState>(
        cubit: _filterBloc,
        builder: (context, state) {
          if (state is FilterLoadSuccess) {
            _filter.dateFrom = state.filterFromDate;
            _filter.dateTo = state.filterToDate;
            _filter.filterDateRange = state.filterDateRange;
            return AppFilterDrawerContainer(
              onRefresh: () {
                _filter.isFilterByInvoiceType = false;
                _filter.isFilterByStaff = false;
                _filter.isFilterByPartner = false;
                _filter.isFilterByCompany = false;
                handleChangeFilter(isConfirm: true);
              },
              closeWhenConfirm: true,
              onApply: () {
                handleChangeFilter(isConfirm: true);
                _bloc.add(ReportOrderFilterSaved(
                    filterFromDate: _filter.dateFrom,
                    filterToDate: _filter.dateTo,
                    isFilterByCompany: _filter.isFilterByCompany ?? false,
                    isFilterByInvoiceType:
                        _filter.isFilterByInvoiceType ?? false,
                    isFilterByPartner: _filter.isFilterByPartner ?? false,
                    isFilterByStaff: _filter.isFilterByStaff ?? false,
                    partner: _filter.partner,
                    companyOfUser: _filter.companyOfUser,
                    userReportStaffOrder: _filter.userReportStaffOrder,
                    orderType: _filter.orderType));
                if (_tabController.index == 0) {
                  _bloc
                      .add(ReportSaleGeneralLoaded(skip: _skip, limit: _limit));
                } else if (_tabController.index == 1) {
                  _bloc
                      .add(ReportOrderDetailLoaded(skip: _skip, limit: _limit));
                } else if (_tabController.index == 2) {
                  _bloc.add(
                      ReportOrderPartnerLoaded(skip: _skip, limit: _limit));
                } else if (_tabController.index == 3) {
                  _bloc.add(ReportOrderStaffLoaded(skip: _skip, limit: _limit));
                }
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AppFilterDateTime(
                      isSelected: true,
                      initDateRange: _filter.filterDateRange,
                      onSelectChange: (value) {},
                      toDate: _filter.dateTo,
                      fromDate: _filter.dateFrom,
                      dateRangeChanged: (value) {
                        _filter.filterDateRange = value;
                        handleChangeFilter();
                      },
                      onFromDateChanged: (value) {
                        _filter.dateFrom = value;
                        handleChangeFilter();
                      },
                      onToDateChanged: (value) {
                        _filter.dateTo = value;
                        handleChangeFilter();
                      },
                    ),
                    AppFilterPanel(
                      isEnable: true,
                      isSelected: state.isFilterByStaff ?? false,
                      onSelectedChange: (bool value) {
                        _filter.isFilterByStaff = value;
                        handleChangeFilter();
                      },
                      title: Text(S.current.employee),
                      children: <Widget>[
                        Container(
                          height: 45,
                          margin: const EdgeInsets.only(
                              left: 32, right: 8, bottom: 12),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey[400]))),
                          child: InkWell(
                            onTap: () async {
                              final UserReportStaff result =
                                  await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return UserReportStaffListPage();
                                  },
                                ),
                              );
                              if (result != null) {
                                _filter.userReportStaffOrder = result;
                                handleChangeFilter();
                              }
                            },
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                      _filter.userReportStaffOrder?.text ??
                                          S.current.employee,
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15)),
                                ),
                                Visibility(
                                  visible: _filter.userReportStaffOrder?.text !=
                                      null,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      _filter.userReportStaffOrder =
                                          UserReportStaff();
                                      handleChangeFilter();
                                    },
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.grey[600],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    AppFilterPanel(
                      isEnable: true,
                      isSelected: state.isFilterByCompany ?? false,
                      onSelectedChange: (bool value) {
                        _filter.isFilterByCompany = value;
                        handleChangeFilter();
                      },
//            _vm.isFilterByTypeAccountPayment = value,
                      /// Công ty
                      title: Text(S.current.company),
                      children: <Widget>[
                        Container(
                          height: 45,
                          margin: const EdgeInsets.only(
                              left: 32, right: 8, bottom: 12),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey[400]))),
                          child: InkWell(
                            onTap: () async {
                              final CompanyOfUser result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return CompanyOfUserListPage();
                                  },
                                ),
                              );
                              if (result != null) {
                                _filter.companyOfUser = result;
                                handleChangeFilter();
                              }
                            },
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                      _filter.companyOfUser?.text ??
                                          S.current.company,
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15)),
                                ),
                                Visibility(
                                  visible: _filter.companyOfUser?.text != null,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      _filter.companyOfUser = CompanyOfUser();
                                      handleChangeFilter();
                                    },
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.grey[600],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    AppFilterPanel(
                        isEnable: true,
                        isSelected: state.isFilterByInvoiceType ?? false,
                        onSelectedChange: (bool value) {
                          _filter.isFilterByInvoiceType = value;
                          handleChangeFilter();
                        },

                        /// Loại hóa đơn
                        title: Text(S.current.reportOrder_invoiceType),
                        children: <Widget>[
                          Wrap(
                            children: List.generate(
                              state.orderTypes.length,
                              (index) => InkWell(
                                  onTap: () {
                                    _filter.orderType =
                                        state.orderTypes[index]["value"];
                                    handleChangeFilter();
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        right: 4, bottom: 8),
                                    width: 120,
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 4),
                                            decoration: BoxDecoration(
                                                color: _filter.orderType ==
                                                        state.orderTypes[index]
                                                            ["value"]
                                                    ? Colors.white
                                                    : const Color(0xFFF0F1F3),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    color: _filter.orderType ==
                                                            state.orderTypes[
                                                                index]["value"]
                                                        ? const Color(
                                                            0xFF28A745)
                                                        : Colors.transparent)),
                                            child: Center(
                                                child: Text(
                                              state.orderTypes[index]["name"],
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: _filter.orderType ==
                                                          state.orderTypes[
                                                              index]["value"]
                                                      ? const Color(0xFF28A745)
                                                      : const Color(
                                                          0xFF2C333A)),
                                            ))),
                                        Visibility(
                                          visible: _filter.orderType ==
                                              state.orderTypes[index]["value"],
                                          child: Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: ClipPath(
                                              clipper: MyClipper(),
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomRight:
                                                                Radius.circular(
                                                                    8))),
                                                width: 20,
                                                height: 20,
                                                child: const Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Icon(
                                                    Icons.check,
                                                    size: 13,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          )
                        ]),
                    AppFilterPanel(
                      isEnable: true,
                      isSelected: state.isFilterByPartner ?? false,
                      onSelectedChange: (bool value) {
                        _filter.isFilterByPartner = value;
                        handleChangeFilter();
                      },
//            _vm.isFilterByTypeAccountPayment = value,
                      /// Khách hàng
                      title: Text(S.current.partner),
                      children: <Widget>[
                        Container(
                          height: 45,
                          margin: const EdgeInsets.only(
                              left: 32, right: 8, bottom: 12),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey[400]))),
                          child: InkWell(
                            onTap: () async {
                              final Partner result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const PartnerSearchPage();
                                  },
                                ),
                              );
                              if (result != null) {
                                _filter.partner = result;
                                handleChangeFilter();
                              }
                            },
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  /// Khách hàng
                                  child: Text(
                                      _filter.partner.name ?? S.current.partner,
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15)),
                                ),
                                Visibility(
                                  visible: _filter.partner.name != null,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      _filter.partner = Partner();
                                      handleChangeFilter();
                                    },
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.grey[600],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        });
  }

  void handleChangeFilter({bool isConfirm = false}) {
    _filterBloc.add(FilterChanged(
        filterDateRange: _filter.filterDateRange,
        filterToDate: _filter.dateTo,
        filterFromDate: _filter.dateFrom,
        partner: _filter.partner,
        companyOfUser: _filter.companyOfUser,
        userReportStaffOrder: _filter.userReportStaffOrder,
        isFilterByCompany: _filter.isFilterByCompany,
        isFilterByPartner: _filter.isFilterByPartner,
        isFilterByStaff: _filter.isFilterByStaff,
        isFilterByInvoiceType: _filter.isFilterByInvoiceType,
        orderType: _filter.orderType,
        isConfirm: isConfirm));
  }
}

class ItemReportGeneral extends StatelessWidget {
  const ItemReportGeneral(
      {this.color,
      this.icon,
      this.title,
      this.amount,
      this.isOverView = true,
      this.amountPosOrder,
      this.amountFastSaleOrder,
      this.textColor});

  final Color color;
  final Color textColor;
  final Widget icon;
  final String title;
  final String amount;
  final bool isOverView;
  final double amountPosOrder;
  final double amountFastSaleOrder;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 8),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: color),
          child: Center(
            child: icon,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  child: Text(
                title,
                style: const TextStyle(color: Color(0xFF6B7280)),
              )),
              const SizedBox(
                height: 4,
              ),
              Text(
                amount,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor),
              ),
              const SizedBox(
                height: 8,
              ),
              Visibility(
                visible: !isOverView,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          /// Điểm bán hàng
                          Text(S.current.menu_posOfSale,
                              style: TextStyle(color: Color(0xFF929DAA))),
                          Text(
                            vietnameseCurrencyFormat(amountPosOrder ?? 0),
                            style: const TextStyle(color: Color(0xFF2C333A)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          /// Bán hàng nhanh
                          Text(S.current.reportOrder_fastSaleOrder,
                              style: const TextStyle(color: Color(0xFF929DAA))),
                          Text(
                            vietnameseCurrencyFormat(amountFastSaleOrder ?? 0),
                            style: const TextStyle(color: Color(0xFF2C333A)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Divider(
                color: Color(0xFFE9EDF2),
                height: 4,
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.height, size.width);
    path.lineTo(size.width, 0);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
