import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_datetime.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_drawer.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_panel.dart';
import 'package:tpos_mobile/app_core/template_ui/empty_data_widget.dart';
import 'package:tpos_mobile/feature_group/category/partner/partner_search_page.dart';
import 'package:tpos_mobile/feature_group/fast_sale_order/ui/fast_sale_order_info_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/filter_report_delivery/filter_report_delivery_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/filter_report_delivery/filter_report_delivery_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/filter_report_delivery/filter_report_delivery_state.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/report_delivery_order_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/blocs/report_delivery_order_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_delivey/report_delivery_helpers.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/company_of_user_list_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/empty_data_page.dart';
import 'package:tpos_mobile/src/tpos_apis/models/company_of_user.dart';

import 'package:tpos_mobile/src/tpos_apis/models/filter_report_delivery.dart';
import 'package:tpos_mobile/widgets/loading_indicator.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import '../blocs/report_delivery_order_state.dart';
import 'delivery_carrier_search_list_page.dart';

class ReportDeliveryOrderInvoiceListPage extends StatefulWidget {
  const ReportDeliveryOrderInvoiceListPage(
      {this.bloc,
      this.filterBloc,
      this.reportDeliveryFastSaleOrder,
      this.sumDeliveryReportFastSaleOrder,
      this.filterReportDelivery});

  final ReportDeliveryOrderBloc bloc;
  final FilterReportDeliveryBloc filterBloc;
  final DeliveryOrderReport reportDeliveryFastSaleOrder;
  final SumDeliveryReportFastSaleOrder sumDeliveryReportFastSaleOrder;
  final FilterReportDelivery filterReportDelivery;
  @override
  _ReportDeliveryOrderInvoiceListPageState createState() =>
      _ReportDeliveryOrderInvoiceListPageState();
}

class _ReportDeliveryOrderInvoiceListPageState
    extends State<ReportDeliveryOrderInvoiceListPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int _count = 1;
  final int _limit = 50;
  int _skip = 0;
  FilterReportDelivery _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.filterReportDelivery;
    widget.bloc.add(ReportDeliveryFastSaleOrderInvoiceFromLocalLoaded(
        reportDeliveryFastSaleOrder: widget.reportDeliveryFastSaleOrder,
        sumDeliveryReportFastSaleOrder: widget.sumDeliveryReportFastSaleOrder));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: _buildAppBar(),
        endDrawer: _buildFilterPanel(),
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                _buildFilter(),
                Expanded(child: _buildBody()),
              ],
            ),
            BlocBuilder<ReportDeliveryOrderBloc, ReportDeliveryOrderState>(
                cubit: widget.bloc,
                builder: (context, state) {
                  if (state is ReportDeliveryFastSaleOrderLoading) {
                    return LoadingIndicator();
                  }
                  return const SizedBox();
                })
          ],
        ));
  }

  Widget _buildAppBar() {
    return AppBar(
      /// Danh sách hóa đơn
      title: Text(S.current.reportOrder_Invoices),
      actions: <Widget>[
        BlocBuilder<FilterReportDeliveryBloc, FilterReportDeliveryState>(
            cubit: widget.filterBloc,
            builder: (context, state) {
              if (state is FilterReportDeliveryLoadSuccess) {
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

  Widget _buildBody() {
    return BlocBuilder<ReportDeliveryOrderBloc, ReportDeliveryOrderState>(
        cubit: widget.bloc,
        buildWhen: (prevState, currState) {
          if (currState is ReportDeliveryFastSaleOrderLoadSuccess) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state is ReportDeliveryFastSaleOrderLoadSuccess) {
            return state.reportDeliveryFastSaleOrder.data.isEmpty
                ? EmptyDataPage()
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount:
                        state.reportDeliveryFastSaleOrder.data.length ?? 0,
                    itemBuilder: (context, index) => _buildItem(
                        state.reportDeliveryFastSaleOrder.data[index],
                        state.reportDeliveryFastSaleOrder,
                        state.sumDeliveryReportFastSaleOrder,
                        index),
                  );
          }
          return const SizedBox();
        });
  }

  Widget _buildItem(
      ReportDeliveryOrderDetail item,
      DeliveryOrderReport reportDelivery,
      SumDeliveryReportFastSaleOrder sumDeliveryReport,
      int index) {
    return item.userName == "invoiceTemp"
        ? _buildButtonLoadMore(index, reportDelivery, sumDeliveryReport)
        : InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => FastSaleOrderInfoPage(
                    order: FastSaleOrder(id: item.id),
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              margin: const EdgeInsets.only(right: 12, left: 12, bottom: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(6)),
              child: ListTile(
                title: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        item.partnerDisplayName ?? "",
                        style: const TextStyle(
                            color: Color(0xFF28A745),
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      vietnameseCurrencyFormat(item.amountTotal ?? 0),
                      style: const TextStyle(color: Color(0xFFF25D27)),
                    )
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            item.number ?? "",
                            style: const TextStyle(
                                color: Color(0xFF929DAA), fontSize: 16),
                          ),
                        ),
                        const Text("  |  "),
                        Text(
                          DateFormat("dd/MM/yyyy").format(item.dateInvoice),
                          style: const TextStyle(color: Color(0xFF929DAA)),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: <Widget>[
                        SvgPicture.asset(
                          "assets/icon/ic_count.svg",
                          alignment: Alignment.center,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Flexible(
                          child: Text(
                            vietnameseCurrencyFormat(item.cashOnDelivery ?? 0),
                            style: const TextStyle(color: Color(0xFF2C333A)),
                          ),
                        ),
                        const Text("  |  "),
                        const Icon(
                          FontAwesomeIcons.truck,
                          color: Color(0xFF929daa),
                          size: 13,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(
                              vietnameseCurrencyFormat(
                                  item.customerDeliveryPrice ?? 0),
                              style: const TextStyle(color: Color(0xFF2C333A))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: <Widget>[
                        if (getImageLinkDeliverCarrierPartner(
                                item.carrierDeliveryType) ==
                            "")
                          const SizedBox()
                        else
                          Image.asset(
                            getImageLinkDeliverCarrierPartner(
                                item.carrierDeliveryType),
                            alignment: Alignment.center,
                            width: 35,
                            height: 30,
                            fit: BoxFit.fill,
                          ),
                        Visibility(
                          visible: getImageLinkDeliverCarrierPartner(
                                  item.carrierDeliveryType) !=
                              "",
                          child: const SizedBox(
                            width: 4,
                          ),
                        ),
                        Flexible(child: Text(item.trackingRef ?? "<Chưa có>")),
                        const Text(" / "),
                        Text(item.shipPaymentStatus ?? "")
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: <Widget>[
                        /// Đối soát giao hàng
                        Text("${S.current.reportOrder_deliveryControl}: "),
                        Text(item.showShipStatus,
                            style: const TextStyle(color: Color(0xFF28A745)))
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }

  Widget _buildFilter() {
    return BlocBuilder<FilterReportDeliveryBloc, FilterReportDeliveryState>(
        buildWhen: (prevState, curState) {
          if (curState is FilterReportDeliveryLoadSuccess &&
              curState.isConfirm) {
            return true;
          }
          return false;
        },
        cubit: widget.filterBloc,
        builder: (context, state) {
          if (state is FilterReportDeliveryLoadSuccess) {
            return InkWell(
              onTap: () {
                scaffoldKey.currentState.openEndDrawer();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                height: 40,
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.date_range,
                        size: 18, color: const Color(0xFF6B7280)),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      state.filterDateRange != null
                          ? state.filterDateRange.name == "Tùy chỉnh"
                              ? "${DateFormat("dd/MM/yyyy").format(state.filterFromDate)} - ${DateFormat("dd/MM/yyyy").format(state.filterToDate)}"
                              : state.filterDateRange.name
                          : "Thời gian",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFF6B7280)),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    const Icon(Icons.arrow_drop_down, color: Color(0xFF6B7280))
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        });
  }

  Widget _buildFilterPanel() {
    return BlocBuilder<FilterReportDeliveryBloc, FilterReportDeliveryState>(
        cubit: widget.filterBloc,
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
                widget.bloc.add(ReportDeliveryFastSaleOrderFilterSaved(
                    filterReportDelivery: _filter));
                widget.bloc.add(
                    ReportDeliveryFastSaleOrderLoaded(limit: _limit, skip: 0));
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

  void handleChangeFilter({bool isConfirm = false}) {
    widget.filterBloc.add(FilterReportDeliveryChanged(
        filterReportDelivery: _filter, isConfirm: isConfirm));
  }

  Widget _buildButtonLoadMore(int index, DeliveryOrderReport reportDelivery,
      SumDeliveryReportFastSaleOrder sumDeliveryReport) {
    return BlocBuilder<ReportDeliveryOrderBloc, ReportDeliveryOrderState>(
        cubit: widget.bloc,
        builder: (context, state) {
          if (state is ReportDeliveryFastSaleOrderLoadMoreLoading) {
            return Center(
              child: SpinKitCircle(
                color: Theme.of(context).primaryColor,
              ),
            );
          }
          return Center(
            child: Container(
                margin: const EdgeInsets.only(
                    top: 12, left: 12, right: 12, bottom: 8),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(3)),
                height: 45,
                child: FlatButton(
                  onPressed: () {
                    _skip += _limit;
                    widget.bloc.add(ReportDeliveryFastSaleOrderLoadMoreLoaded(
                        limit: _limit,
                        skip: _skip,
                        reportDeliveryFastSaleOrder: reportDelivery,
                        sumDeliveryReportFastSaleOrder: sumDeliveryReport));
                  },
                  color: Colors.blueGrey,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        /// Tải thêm
                        Text(S.current.loadMore,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16)),
                        const SizedBox(
                          width: 12,
                        ),
                        const Icon(
                          Icons.save_alt,
                          color: Colors.white,
                          size: 18,
                        )
                      ],
                    ),
                  ),
                )),
          );
        });
  }
}
