import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/filter/filter_bloc.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/report_order_bloc.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/report_order_event.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/report_order_state.dart';
import 'package:tpos_mobile/feature_group/sale_online/filter.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';

import '../../../app_core/template_models/app_filter_date_model.dart';
import '../../../app_core/template_ui/app_filter_datetime.dart';
import '../../../app_core/template_ui/app_filter_drawer.dart';
import '../../../app_core/template_ui/app_filter_panel.dart';
import '../../../src/tpos_apis/models/company_of_user.dart';
import '../../../src/tpos_apis/models/partner.dart';
import '../../../src/tpos_apis/models/user_report_staff.dart';
import '../blocs/filter/filter_event.dart';
import '../blocs/filter/filter_state.dart';
import 'company_of_user_list_page.dart';
import 'partner_search_page.dart';
import 'report_order_page.dart';
import 'user_report_staff_list_page.dart';

class ReportOrderDetailInvoiceListPage extends StatefulWidget {
  const ReportOrderDetailInvoiceListPage(
      {this.reportOrderDetails,
      this.bloc,
      this.filterBloc,
this.filter,
      this.sumReportOrderDetail,
      this.sumReportGeneral});

  final List<ReportOrderDetail> reportOrderDetails;
  final ReportOrderBloc bloc;
  final FilterBloc filterBloc;

  final SumReportOrderDetail sumReportOrderDetail;
  final SumReportGeneral sumReportGeneral;
  final Filter filter;

  @override
  _ReportOrderDetailInvoiceListPageState createState() =>
      _ReportOrderDetailInvoiceListPageState();
}

class _ReportOrderDetailInvoiceListPageState
    extends State<ReportOrderDetailInvoiceListPage> {
  int _limit = 20;
  int _skip = 0;
   Filter _filter;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _filter = widget.filter;

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(   key: scaffoldKey,
        backgroundColor: const Color(0xFFEBEDEF),
        endDrawer: _buildFilterPanel(),
        appBar: AppBar(
          title: const Text("Danh sách hóa đơn"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: ()
        {scaffoldKey.currentState.openEndDrawer();
              },
            )
          ],
        ),
        body: _buildBody(),
      )
    ;
  }

  Widget _buildBody() {
    return BlocBuilder<ReportOrderBloc, ReportOrderState>(
        cubit: widget.bloc,
          buildWhen: (prevState, currState) {
        if (currState is ReportOrderDetailLoadSuccess) {
          return true;
        }
        return false;
      }, builder: (context, state) {
        if (state is ReportOrderDetailLoadSuccess) {
          return ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: state.reportOrderDetails.length,
              itemBuilder: (context, index) =>
                  _buildItem(state.reportOrderDetails[index], index));
        }
        return const SizedBox();
      })
    ;
  }

  Widget _buildItem(ReportOrderDetail item, int index) {
    return item.name == "temp"
        ? _buildButtonLoadMore(index)
        : Container(
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
                          color: const Color(0xFF28A745),
                          fontSize: 17,
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
                          item.partnerDisplayName ?? "Chưa có khách hàng",
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
                      const Text("Nợ: "),
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
                    item.companyName ?? "<Chưa có công ty>",
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
          );
  }

  Widget _buildButtonLoadMore(int index) {
    return BlocBuilder<ReportOrderBloc, ReportOrderState>(
      cubit: widget.bloc,
      builder: (context, state) {
        if(state is ReportOrderDetailLoadMoreLoading){
          return Center(
            child: SpinKitCircle(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
        return Center(
          child: Container(
              margin:
                  const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
              height: 45,
              child: FlatButton(
                onPressed: () {
                  _skip += _limit;
                  widget.bloc.add(ReportOrderDetailLoadMoreLoaded(
                      skip: _skip,
                      limit: _limit,
                      reportOrderDetails: widget.reportOrderDetails,
                      sumReportGeneral: widget.sumReportGeneral,
                      sumReportOrderDetail: widget.sumReportOrderDetail));
                },
                color: Colors.blueGrey,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: <Widget>[
                      const Text("Tải tiếp",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
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
      }
    );
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
                handleChangeFilter();

              },
              closeWhenConfirm: true,
              onApply: () {
                widget.bloc.add(ReportOrderFilterSaved(
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
        isFilterByInvoiceType:_filter.isFilterByInvoiceType,
        orderType: _filter.orderType));
  }
}
