import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_datetime.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_drawer.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_expansion_tile.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_panel.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/filter/filter_bloc.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/filter/filter_event.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/filter/filter_state.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/report_order_bloc.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/report_order_event.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/report_order_state.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/company_of_user_list_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/partner_search_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/report_order_detail_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/report_order_employee_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/report_order_overview_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/report_order_partner_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/user_report_staff_list_page.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/src/tpos_apis/models/partner.dart';
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

  DateTime _dateFrom;
  DateTime _dateTo;
  bool _isFilterByDate,
      _isFilterByCompany,
      _isFilterByStaff,
      _isFilterByPartner,
      _isFilterByInvoiceType;

  AppFilterDateModel _filterDateRange;
  Partner _partner = Partner();
  UserCompany _companyOfUser = UserCompany();
  UserReportStaffOrder _userReportStaffOrder = UserReportStaffOrder();
  String _orderType;

  @override
  void initState() {
    _isFilterByDate = false;
    _filterDateRange = getTodayDateFilter();
    _dateFrom = _filterDateRange.fromDate;
    _dateTo = _filterDateRange.toDate;
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
                    unselectedLabelColor: Colors.black54,
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
                  ),
                  ReportOrderDetailPage(
                    bloc: _bloc,
                  ),
                  ReportOrderPartnerPage(
                    bloc: _bloc,
                  ),
                  ReportOrderEmployeePage(
                    bloc: _bloc,
                  )
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
            _isFilterByDate = state.isFilterByDate;
            _dateFrom = state.filterFromDate;
            _dateTo = state.filterToDate;
            _filterDateRange = state.filterDateRange;
            return AppFilterDrawerContainer(
              onRefresh: () {
                _isFilterByInvoiceType = false;
                _isFilterByStaff = false;
                _isFilterByPartner = false;
                _isFilterByCompany = false;
                _isFilterByDate = false;
                handleChangeFilter();
              },
              closeWhenConfirm: true,
              onApply: () {
//        _vm.handleFilter();
//                 _bloc.add(ReportOrderLoaded());
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AppFilterDateTime(
                      isSelected: state.isFilterByDate ?? false,
                      initDateRange: _filterDateRange,
                      onSelectChange: (value) {
                        _isFilterByDate = value;
                        handleChangeFilter();
                      },
                      toDate: _dateTo,
                      fromDate: _dateFrom,
                      dateRangeChanged: (value) {
                        _filterDateRange = value;
                        handleChangeFilter();
                      },
                      onFromDateChanged: (value) {
                        _dateFrom = value;
                        handleChangeFilter();
                      },
                      onToDateChanged: (value) {
                        _dateTo = value;
                        handleChangeFilter();
                      },
                    ),
                    AppFilterPanel(
                      isEnable: true,
                      isSelected: state.isFilterByStaff ?? false,
                      onSelectedChange: (bool value) {
                        _isFilterByStaff = value;
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
                              final UserReportStaffOrder result =
                                  await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return UserReportStaffListPage();
                                  },
                                ),
                              );
                              if (result != null) {
                                _userReportStaffOrder = result;
                                handleChangeFilter();
                              }
                            },
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                      _userReportStaffOrder.text ?? "Người bán",
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
                        _isFilterByCompany = value;
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
                              final UserCompany result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return CompanyOfUserListPage();
                                  },
                                ),
                              );
                              if (result != null) {
                                _companyOfUser = result;
                                handleChangeFilter();
                              }
                            },
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                      _companyOfUser?.text ?? "Chọn công ty",
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
                          _isFilterByInvoiceType = value;
                          handleChangeFilter();
                        },
//            _vm.isFilterByTypeAccountPayment = value,
                        title: const Text("Loại hóa đơn"),
                        children: <Widget>[
                          Wrap(
                            children: List.generate(
                              state.orderTypes.length,
                              (index) => InkWell(
                                  onTap: () {
                                    _orderType =
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
                                                color: _orderType ==
                                                        state.orderTypes[index]
                                                            ["value"]
                                                    ? Colors.white
                                                    : const Color(0xFFF0F1F3),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    color: _orderType ==
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
                                                  color: _orderType ==
                                                          state.orderTypes[
                                                              index]["value"]
                                                      ? const Color(0xFF28A745)
                                                      : const Color(
                                                          0xFF2C333A)),
                                            ))),
                                        Visibility(
                                          visible: _orderType ==
                                              state.orderTypes[index]["value"],
                                          child: Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: ClipPath(
                                              clipper: _MyClipper(),
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
                        _isFilterByPartner = value;
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
                                _partner = result;
                                handleChangeFilter();
                              }
                            },
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                      _partner.name ?? "Chọn Khách hàng",
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
        isFilterByDate: _isFilterByDate,
        filterDateRange: _filterDateRange,
        filterToDate: _dateTo,
        filterFromDate: _dateFrom,
        partner: _partner,
        companyOfUser: _companyOfUser,
        userReportStaffOrder: _userReportStaffOrder,
        isFilterByCompany: _isFilterByCompany,
        isFilterByPartner: _isFilterByPartner,
        isFilterByStaff: _isFilterByStaff,
        isFilterByInvoiceType: _isFilterByInvoiceType,
        orderType: _orderType));
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
                amount.toString(),
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
                            "$amountPosOrder",
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
                            "$amountPosOrder",
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

class _MyClipper extends CustomClipper<Path> {
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
