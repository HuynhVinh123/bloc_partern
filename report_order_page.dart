import 'dart:async';

import 'package:flutter/cupertino.dart';
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
import 'package:tpos_mobile/feature_group/sale_online/blocs/filter/filter_bloc.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/filter/filter_event.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/filter/filter_state.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/report_order_bloc.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/report_order_event.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/report_order_state.dart';
import 'package:tpos_mobile/feature_group/sale_online/filter.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/company_of_user_list_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/partner_search_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/report_order_detail_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/report_order_employee_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/report_order_overview_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/report_order_partner_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/user_report_staff_list_page.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/src/tpos_apis/models/company_of_user.dart';
import 'package:tpos_mobile/src/tpos_apis/models/partner.dart';
import 'package:tpos_mobile/src/tpos_apis/models/user_report_staff.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';

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
  // DateTime _dateFrom;
  // DateTime _dateTo;
  // bool _isFilterByCompany,
  //     _isFilterByStaff,
  //     _isFilterByPartner,
  //     _isFilterByInvoiceType;
  //
  // AppFilterDateModel _filterDateRange;
  // Partner _partner = Partner();
  // CompanyOfUser _companyOfUser = CompanyOfUser();
  // UserReportStaff _userReportStaffOrder = UserReportStaff();
  // String _orderType;

  @override
  void initState() {
    _filter.filterDateRange = getTodayDateFilter();
    _filter.dateFrom = _filter.filterDateRange.fromDate;
    _filter.dateTo = _filter.filterDateRange.toDate;
    _filter.userReportStaffOrder = UserReportStaff();
    _filter.companyOfUser =  CompanyOfUser();
    _filter.partner = Partner();
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _filterBloc.add(FilterLoaded());
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
            title: const Text("Thống kế hóa đơn"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  scaffoldKey.currentState.openEndDrawer();
                },
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
                    unselectedLabelColor: Colors.black54,mouseCursor: MouseCursor.uncontrolled ,
                    tabs: const <Widget>[
                      Tab(
                        text: 'Tổng quan',
                      ),
                      Tab(
                        text: 'Chi tiết',
                      ),
                      Tab(
                        text: 'Khách hàng',
                      ),
                      Tab(
                        text: 'Nhân viên',
                      ),
                    ]),
              ),
              Expanded(
                  child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  ReportOrderOverViewPage(
                    bloc: _bloc,
                    filterBloc: _filterBloc,
                    scaffoldKey: scaffoldKey,
                  ),
                  ReportOrderDetailPage(
                      bloc: _bloc,
                      filterBloc: _filterBloc,
                      scaffoldKey: scaffoldKey,filter: _filter,),
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
    // _bloc.add(ReportOrderLoaded());
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
               handleChangeFilter();

              },
              closeWhenConfirm: true,
              onApply: () {
                _bloc.add(ReportOrderFilterSaved(
                    filterFromDate: _filter.dateFrom,
                    filterToDate: _filter.dateTo,
                    isFilterByCompany: _filter.isFilterByCompany ?? false,
                    isFilterByInvoiceType: _filter.isFilterByInvoiceType ?? false,
                    isFilterByPartner: _filter.isFilterByPartner ?? false,
                    isFilterByStaff: _filter.isFilterByStaff ?? false,
                    partner: _filter.partner,
                    companyOfUser: _filter.companyOfUser,
                    userReportStaffOrder:_filter.userReportStaffOrder,
                    orderType:_filter.orderType));
                print(_tabController.index);
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
                  _bloc.add(ReportOrderStaffLoaded());
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
                      title: const Text("Người bán"),
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
                                      _filter.userReportStaffOrder?.text ?? "Người bán",
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15)),
                                ),
//                      Visibility(
//                        visible: _vm.account.name != null,
//                        child: IconButton(
//                          icon: Icon(
//                            Icons.highlight_off,
//                            color: Colors.grey[600],
//                            size: 20,
//                          ),
//                          onPressed: () {
//                            _vm.account = Account();
//                          },
//                        ),
//                      ),
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
                      title: const Text("Công ty"),
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
                                      _filter.companyOfUser?.text ?? "Chọn công ty",
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15)),
                                ),
//                      Visibility(
//                        visible: _vm.account.name != null,
//                        child: IconButton(
//                          icon: Icon(
//                            Icons.highlight_off,
//                            color: Colors.grey[600],
//                            size: 20,
//                          ),
//                          onPressed: () {
//                            _vm.account = Account();
//                          },
//                        ),
//                      ),
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
                        title: const Text("Loại hóa đơn"),
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
                      title: const Text("Khách hàng"),
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
                                  child: Text(
                                      _filter.partner.name ?? "Chọn Khách hàng",
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15)),
                                ),
//                      Visibility(
//                        visible: _vm.account.name != null,
//                        child: IconButton(
//                          icon: Icon(
//                            Icons.highlight_off,
//                            color: Colors.grey[600],
//                            size: 20,
//                          ),
//                          onPressed: () {
//                            _vm.account = Account();
//                          },
//                        ),
//                      ),
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

  void handleChangeFilter() {
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
        isFilterByInvoiceType:_filter.isFilterByInvoiceType,
        orderType: _filter.orderType));
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
                          const Text("Điểm bán hàng",
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
                          const Text("Bán hàng nhanh",
                              style: TextStyle(color: Color(0xFF929DAA))),
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
