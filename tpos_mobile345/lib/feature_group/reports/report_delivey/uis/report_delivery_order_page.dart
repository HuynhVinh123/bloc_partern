import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_datetime.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_drawer.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_panel.dart';
import 'package:tpos_mobile/feature_group/category/partner/partner_search_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/filter_report_delivery/filter_report_delivery_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/filter_report_delivery/filter_report_delivery_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/filter_report_delivery/filter_report_delivery_state.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/report_delivery_order_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/report_delivery_order_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/report_delivery_order_state.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/uis/delivery_carrier_search_list_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/uis/report_delivery_order_employee_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/uis/report_delivery_order_overview_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/uis/report_delivery_order_partner_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/company_of_user_list_page.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/src/tpos_apis/models/company_of_user.dart';
import 'package:tpos_mobile/src/tpos_apis/models/delivery_carrier.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter_report_delivery.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///  Báo cáo giao hàng
class ReportDeliveryOrderPage extends StatefulWidget {
  @override
  _ReportDeliveryOrderPageState createState() =>
      _ReportDeliveryOrderPageState();
}

class _ReportDeliveryOrderPageState extends State<ReportDeliveryOrderPage>
    with TickerProviderStateMixin {
  final _bloc = ReportDeliveryOrderBloc();
  final _filterBloc = FilterReportDeliveryBloc();
  TabController _tabController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final FilterReportDelivery _filter = FilterReportDelivery();
  int _count = 1;
  final int _limit = 50;
  final int _skip = 0;

  @override
  void initState() {
    super.initState();
    _filter.filterDateRange = getTodayDateFilter();
    _filter.dateFrom = _filter.filterDateRange.fromDate;
    _filter.dateTo = _filter.filterDateRange.toDate;
    _filter.deliveryCarrier = DeliveryCarrier();
    _filter.partner = Partner();
    _filter.companyOfUser = CompanyOfUser();
    _tabController = TabController(length: 3, vsync: this);
    _filterBloc.add(FilterReportDeliveryLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return BlocUiProvider<ReportDeliveryOrderBloc>(
      bloc: _bloc,
      listen: (state) {
        if (state is ReportDeliveryFastSaleOrderLoadFailure) {
          showError(
              title: state.title, message: state.content, context: context);
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFEBEDEF),
        endDrawer: _buildFilterPanel(),
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Material(
              color: Colors.white,
              child: TabBar(
                  controller: _tabController,
                  indicatorColor: const Color(0xFF28A745),
                  labelColor: const Color(0xFF28A745),
                  unselectedLabelColor: Colors.black54,
                  tabs: <Widget>[
                    /// Tổng quan
                    Tab(
                      text: S.current.reportOrder_Overview,
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
              children: <Widget>[
                ReportDeliveryOrderOverViewPage(
                  filterBloc: _filterBloc,
                  bloc: _bloc,
                  scaffoldKey: scaffoldKey,
                  filterReportDelivery: _filter,
                ),
                ReportDeliveryOrderPartnerPage(
                  filterBloc: _filterBloc,
                  bloc: _bloc,
                  scaffoldKey: scaffoldKey,
                ),
                ReportDeliveryOrderEmployeePage(
                  filterBloc: _filterBloc,
                  bloc: _bloc,
                  scaffoldKey: scaffoldKey,
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }

  void handleChangeFilter({bool isConfirm = false}) {
    _filterBloc.add(FilterReportDeliveryChanged(
      filterReportDelivery: _filter,
      isConfirm: isConfirm,
    ));
  }

  Widget _buildAppBar() {
    return AppBar(
      /// Thống kê giao hàng
      title: Text(S.current.reportOrder_deliveryStatistics),
      actions: <Widget>[
        BlocBuilder<FilterReportDeliveryBloc, FilterReportDeliveryState>(
            cubit: _filterBloc,
            builder: (context, state) {
              if (state is FilterReportDeliveryLoadSuccess) {
                _countFilter(state);
                return InkWell(
                  onTap: () {
                    scaffoldKey.currentState.openEndDrawer();
                  },
                  child: Badge(
                    position: const BadgePosition(top: 4, end: -4),
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
    );
  }

  void _countFilter(FilterReportDeliveryLoadSuccess state) {
    if (state.isConfirm) {
      _count = 1;
      if (state.isFilterShipState != null && state.isFilterShipState) {
        _count++;
      }
      if (state.isFilterByPartner != null && state.isFilterByPartner) {
        _count++;
      }
      if (state.isFilterByCompany != null && state.isFilterByCompany) {
        _count++;
      }
      if (state.isFilterDeliveryCarrier != null &&
          state.isFilterDeliveryCarrier) {
        _count++;
      }
      if (state.isFilterDeliveryCarrierType != null &&
          state.isFilterDeliveryCarrierType) {
        _count++;
      }
      if (state.isFilterControlState != null && state.isFilterControlState) {
        _count++;
      }
    }
  }

  Widget _buildFilterPanel() {
    return BlocBuilder<FilterReportDeliveryBloc, FilterReportDeliveryState>(
        cubit: _filterBloc,
        builder: (context, state) {
          if (state is FilterReportDeliveryLoadSuccess) {
            return AppFilterDrawerContainer(
              onRefresh: () {
                _filter.isFilterControlState = false;
                _filter.isFilterDeliveryCarrierType = false;
                _filter.isFilterDeliveryCarrier = false;
                _filter.isFilterByCompany = false;
                _filter.isFilterByPartner = false;
                _filter.isFilterShipState = false;
                handleChangeFilter(isConfirm: true);
              },
              closeWhenConfirm: true,
              onApply: () {
                handleChangeFilter(isConfirm: true);
                _bloc.add(ReportDeliveryFastSaleOrderFilterSaved(
                    filterReportDelivery: _filter));
                if (_tabController.index == 0) {
                  _bloc.add(ReportDeliveryFastSaleOrderLoaded(
                      limit: _limit, skip: _skip));
                } else if (_tabController.index == 1) {
                  _bloc.add(
                      DeliveryReportCustomerLoaded(limit: _limit, skip: _skip));
                } else if (_tabController.index == 2) {
                  _bloc.add(
                      DeliveryReportStaffLoaded(limit: _limit, skip: _skip));
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
                        }),
                    AppFilterPanel(
                      isEnable: true,
                      isSelected: state.isFilterShipState ?? false,
                      onSelectedChange: (bool value) {
                        _filter.isFilterShipState = value;
                        handleChangeFilter();
                      },

                      /// Trạng thái giao hàng
                      title: Text(S.current.reportOrder_deliveryStatus),
                      children: <Widget>[
                        Container(
                          height: 45,
                          margin: const EdgeInsets.only(
                              left: 32, right: 8, bottom: 12),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey[400]))),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isDense: true,
                              hint: Text(S.current.reportOrder_deliveryStatus),
                              value: _filter.shipState,
                              onChanged: (String newValue) {
                                _filter.shipState = newValue;
                                handleChangeFilter();
                              },
                              items: state.shipStates.map((Map map) {
                                return DropdownMenuItem<String>(
                                  value: map["value"],
                                  child: Text(
                                    map["name"],
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.green),
                                    textAlign: TextAlign.right,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        )
                      ],
                    ),
                    AppFilterPanel(
                      isEnable: true,
                      isSelected: state.isFilterControlState ?? false,
                      onSelectedChange: (bool value) {
                        _filter.isFilterControlState = value;
                        handleChangeFilter();
                      },

                      /// Trạng thái đối soát
                      title: Text(S.current.reportOrder_controlStatus),
                      children: <Widget>[
                        Container(
                          height: 45,
                          margin: const EdgeInsets.only(
                              left: 32, right: 8, bottom: 12),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey[400]))),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isDense: true,
                              hint: Text(S.current.reportOrder_controlStatus),
                              value: _filter.stateControl,
                              onChanged: (String newValue) {
                                _filter.stateControl = newValue;
                                handleChangeFilter();
                              },
                              items: state.stateForControls.map((Map map) {
                                return DropdownMenuItem<String>(
                                  value: map["value"],
                                  child: Text(
                                    map["name"],
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.green),
                                    textAlign: TextAlign.right,
                                  ),
                                );
                              }).toList(),
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
                      isSelected: state.isFilterDeliveryCarrier ?? false,
                      onSelectedChange: (bool value) {
                        _filter.isFilterDeliveryCarrier = value;
                        handleChangeFilter();
                      },

                      /// Đối tác giao hàng
                      title: Text(S.current.reportOrder_deliveryPartner),
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
                              final DeliveryCarrier result =
                                  await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return DeliveryCarrierSearchListPage();
                                  },
                                ),
                              );
                              if (result != null) {
                                _filter.deliveryCarrier = result;
                                handleChangeFilter();
                              }
                            },
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                      _filter.deliveryCarrier?.name ??
                                          S.current.reportOrder_deliveryPartner,
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15)),
                                ),
                                Visibility(
                                  visible:
                                      _filter.deliveryCarrier?.name != null,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      _filter.deliveryCarrier =
                                          DeliveryCarrier();
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
                      isSelected: state.isFilterByPartner ?? false,
                      onSelectedChange: (bool value) {
                        _filter.isFilterByPartner = value;
                        handleChangeFilter();
                      },

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
                                  child: Text(
                                      _filter.partner?.name ??
                                          S.current.partner,
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15)),
                                ),
                                Visibility(
                                  visible: _filter.partner?.name != null,
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
                    ),
                    AppFilterPanel(
                      isEnable: true,
                      isSelected: state.isFilterDeliveryCarrierType ?? false,
                      onSelectedChange: (bool value) {
                        _filter.isFilterDeliveryCarrierType = value;
                        handleChangeFilter();
                      },

                      /// Loại đối tác giao hàng"
                      title: Text(S.current.reportOrder_deliveryPartnerType),
                      children: <Widget>[
                        Container(
                          height: 45,
                          margin: const EdgeInsets.only(
                              left: 32, right: 8, bottom: 12),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey[400]))),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isDense: true,
                              hint: Text(
                                  S.current.reportOrder_deliveryPartnerType),
                              value: _filter.deliveryCarrierType,
                              onChanged: (String newValue) {
                                _filter.deliveryCarrierType = newValue;
                                handleChangeFilter();
                              },
                              items: state.deliveryCarrierTypes.map((Map map) {
                                return DropdownMenuItem<String>(
                                  value: map["value"],
                                  child: Text(
                                    map["name"],
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.green),
                                    textAlign: TextAlign.right,
                                  ),
                                );
                              }).toList(),
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
}

class ItemReportDeliveryGeneral extends StatelessWidget {
  const ItemReportDeliveryGeneral(
      {this.color,
      this.icon,
      this.title,
      this.amount,
      this.textColor,
      this.totalInvoice});

  final Color color;
  final Color textColor;
  final Widget icon;
  final String title;
  final String amount;
  final int totalInvoice;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 10, top: 8),
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
              const SizedBox(
                height: 10,
              ),
              Container(
                  child: Text(
                title,
                style: const TextStyle(color: Color(0xFF6B7280)),
              )),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      amount,
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: textColor),
                    ),
                  ),

                  /// Hóa đơn
                  Text(
                    "$totalInvoice ${S.current.reportOrder_Invoice}",
                    style: const TextStyle(color: Color(0xFF929DAA)),
                  )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              const Divider(
                color: Color(0xFFE9EDF2),
                height: 4,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ItemReportDeliveryGeneralDot extends StatelessWidget {
  const ItemReportDeliveryGeneralDot(
      {this.color, this.title, this.amount, this.totalInvoice});

  final Color color;
  final String title;
  final String amount;
  final int totalInvoice;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            const SizedBox(width: 44),
            Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              width: 8,
              height: 8,
            ),
            Container(
                child: Text(
              title,
              style: const TextStyle(color: Color(0xFF6B7280)),
            )),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            const SizedBox(width: 60),
            Expanded(
              child: Text(
                amount,
                style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C333A)),
              ),
            ),

            /// Hóa đơn
            Text(
              "$totalInvoice ${S.current.reportOrder_Invoice}",
              style: const TextStyle(color: Color(0xFF929DAA)),
            )
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 60),
          child: Divider(
            color: Color(0xFFE9EDF2),
            height: 4,
          ),
        ),
      ],
    );
  }
}
