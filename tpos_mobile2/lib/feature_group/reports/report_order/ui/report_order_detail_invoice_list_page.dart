import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_datetime.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_drawer.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_panel.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/filter/filter_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/filter/filter_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/filter/filter_state.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/empty_data_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/report_order_page.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/user_report_staff_list_page.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/partner_search_page.dart';
import 'package:tpos_mobile/src/tpos_apis/models/company_of_user.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter.dart';
import 'package:tpos_mobile/src/tpos_apis/models/user_report_staff.dart';
import 'package:tpos_mobile/widgets/loading_indicator.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import '../report_order_bloc.dart';
import '../report_order_event.dart';
import '../report_order_state.dart';
import 'company_of_user_list_page.dart';

class ReportOrderDetailInvoiceListPage extends StatefulWidget {
  const ReportOrderDetailInvoiceListPage(
      {this.reportOrderDetails,
      this.bloc,
      this.filterBloc,
      this.filter,
      this.sumReportOrderDetail,
      this.sumReportGeneral,this.countInvoices});

  final List<ReportOrderDetail> reportOrderDetails;
  final ReportOrderBloc bloc;
  final FilterBloc filterBloc;
  final SumDataSale sumReportOrderDetail;
  final SumReportGeneral sumReportGeneral;
  final Filter filter;
  final int countInvoices;

  @override
  _ReportOrderDetailInvoiceListPageState createState() =>
      _ReportOrderDetailInvoiceListPageState();
}

class _ReportOrderDetailInvoiceListPageState
    extends State<ReportOrderDetailInvoiceListPage> {
  final _limit = 20;
  int _skip = 0;
  int _count = 1;
  Filter _filter;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _filter = widget.filter;
    widget.bloc.add(ReportOrderDetailFromLocalLoaded(
        reportOrderDetails: widget.reportOrderDetails,
        sumReportOrderDetail: widget.sumReportOrderDetail,
        sumReportGeneral: widget.sumReportGeneral,countInvoices: widget.countInvoices));
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
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFEBEDEF),
      endDrawer: _buildFilterPanel(),
      appBar: _buildAppBar(),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              _buildFilter(),
              Expanded(child: _buildBody()),
            ],
          ),
          BlocBuilder<ReportOrderBloc, ReportOrderState>(
              cubit: widget.bloc,
              builder: (context, state) {
                if (state is ReportOrderDetailLoading) {
                  return LoadingIndicator();
                }
                return const SizedBox();
              })
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(S.current.reportOrder_Invoices),
      actions: <Widget>[
        BlocBuilder<FilterBloc, FilterState>(
            cubit: widget.filterBloc,
            builder: (context, state) {
              if (state is FilterLoadSuccess) {
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

  Widget _buildFilter() {
    return BlocBuilder<FilterBloc, FilterState>(
        buildWhen: (prevState, curState) {
          if (curState is FilterLoadSuccess && curState.isConfirm) {
            return true;
          }
          return false;
        },
        cubit: widget.filterBloc,
        builder: (context, state) {
          if (state is FilterLoadSuccess) {
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
                        size: 18, color: Color(0xFF6B7280)),
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

  Widget _buildBody() {
    return BlocBuilder<ReportOrderBloc, ReportOrderState>(
        cubit: widget.bloc,
        buildWhen: (prevState, currState) {
          if (currState is ReportOrderDetailLoadSuccess) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state is ReportOrderDetailLoadSuccess) {
            return state.reportOrderDetails.isEmpty ? EmptyDataPage() : ListView.builder(
                padding: const EdgeInsets.only(top: 10),
                itemCount: state.reportOrderDetails.length,
                itemBuilder: (context, index) => _buildItem(
                    state.reportOrderDetails[index],
                    index,
                    state.reportOrderDetails));
          }
          return const SizedBox();
        });
  }

  Widget _buildItem(
      ReportOrderDetail item, int index, List<ReportOrderDetail> items) {
    return item.name == "temp"
        ? _buildButtonLoadMore(index, items)
        : InkWell(
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
                        item.name ?? "",
                        style: const TextStyle(
                            color: Color(0xFF28A745),
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text(
                      vietnameseCurrencyFormat(item.amountTotal),
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            item.userName ?? "",
                            style: const TextStyle(
                                color: Color(0xFF929DAA), fontSize: 17),
                          ),
                        ),
                        const Text("  |  "),
                        Text(
                          item.dateOrder != null
                              ? DateFormat("dd/MM/yyyy HH:ss")
                                  .format(item.dateOrder)
                              : "",
                          style: const TextStyle(color: Color(0xFF929DAA)),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.person,
                          size: 17,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Flexible(
                          child: Text(
                            item.partnerDisplayName ?? "",
                            style: const TextStyle(color: Color(0xFF2C333A)),
                          ),
                        ),
                        const Text("  |  "),
                        SvgPicture.asset(
                          "assets/icon/ic_count.svg",
                          alignment: Alignment.center,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text("${S.current.reportOrder_Debt}: "),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(vietnameseCurrencyFormat(item.residual),
                            style: TextStyle(
                                color: item.residual == 0
                                    ? const Color(0xFF2C333A)
                                    : const Color(0xFFEB3B5B))),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.companyName ?? "",
                      style: const TextStyle(color: Color(0xFF929DAA)),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: <Widget>[
                        if (item.state == "open")
                          SvgPicture.asset(
                            "assets/icon/cart-multicolor-green.svg",
                            alignment: Alignment.center,
                            width: 15,
                            height: 15,
                          )
                        else
                          SvgPicture.asset(
                            "assets/icon/ic_bag.svg",
                            alignment: Alignment.center,
                            width: 15,
                            height: 15,
                          ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          item.showState ?? "",
                          style: const TextStyle(color: Color(0xFF28A745)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }

  Widget _buildButtonLoadMore(int index, List<ReportOrderDetail> items) {
    return BlocBuilder<ReportOrderBloc, ReportOrderState>(
        cubit: widget.bloc,
        builder: (context, state) {
          if (state is ReportOrderDetailLoadMoreLoading) {
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
                    widget.bloc.add(ReportOrderDetailLoadMoreLoaded(
                        skip: _skip,
                        limit: _limit,
                        reportOrderDetails: items,
                        sumReportGeneral: widget.sumReportGeneral,
                        sumReportOrderDetail: widget.sumReportOrderDetail,));
                  },
                  color: Colors.blueGrey,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
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

  Widget _buildFilterPanel() {
    // _bloc.add(ReportOrderLoaded());
    return BlocBuilder<FilterBloc, FilterState>(
        cubit: widget.filterBloc,
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
                widget.bloc.add(ReportOrderFilterSaved(
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

                widget.bloc
                    .add(ReportOrderDetailLoaded(skip: _skip, limit: _limit));
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

                      /// Người bán
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
    widget.filterBloc.add(FilterChanged(
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
