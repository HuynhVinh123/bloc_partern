import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/feature_group/reports/customer_deb_report/blocs/account_common_partner_type_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/customer_deb_report/uis/customer_deb_detail_report.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/empty_data_page.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile/widgets/loading_indicator.dart';

class AccountCommonPartnerType extends StatefulWidget {
  /// Giao diện dùng chung cho các tab và danh sách nhà cung cấp
  const AccountCommonPartnerType(
      {this.bloc,
      this.filter,
      this.scaffoldKey,
      this.type,
      this.resultSelection});

  ///Bloc dùng chung
  final AccountCommonPartnerReportBloc bloc;

  ///Bộ lọc
  final Filter filter;

  ///Type =0; Danh sách theo khách hàng, typ=1 danh sách theo nhân viên
  final int type;

  /// điều kiện lọc trên api
  final String resultSelection;
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  _AccountCommonPartnerTypeState createState() =>
      _AccountCommonPartnerTypeState();
}

class _AccountCommonPartnerTypeState extends State<AccountCommonPartnerType> {
  final RefreshController _refreshSaleOrderController =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.bloc.add(AccountCommonPartnerReportLoaded(
        getReportStaffSummaryQuery: GetAccountCommonPartnerReportQuery(
            dateTo: widget.filter.dateTo,
            dateFrom: widget.filter.dateFrom,
            userId: widget.filter.userReportStaffOrder.value,
            partnerId: widget.filter.partner.id.toString(),
            categId: widget.filter.partnerCategory.id.toString(),
            companyId: widget.filter.companyOfUser.value,
            display: widget.filter.display,
            page: 1,
            pageSize: 20,
            resultSelection: widget.resultSelection,
            take: 20),
        type: widget.type));
  }

  Widget _buildItemCustomer(AccountCommonPartnerReport reportStaffSummary) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 11),
            child: Container(
              child: Text(
                reportStaffSummary.partnerDisplayName ?? '',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: Color(0xFF28A745),
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 11),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icon/call_black.svg',
                ),
                const SizedBox(
                  width: 6,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Text(
                    reportStaffSummary.partnerPhone ?? 'Không hiển thị',
                    style: const TextStyle(color: Color(0xFF2c333a)),
                  ),
                ),
                SvgPicture.asset(
                  'assets/icon/facebook_black.svg',
                ),
                const SizedBox(
                  width: 7,
                ),
                Flexible(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Text(
                      reportStaffSummary.partnerFacebookUserId ??
                          'Không hiển thị',
                      style: const TextStyle(color: Color(0xFF2c333a)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            color: const Color(0xFFe9edf2),
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      child: const Text(
                        'Nợ cuối kì: ',
                        style: TextStyle(color: Color(0xFF929daa)),
                      ),
                      onTap: () {
                        displayBottomSheet(context, reportStaffSummary);
                      },
                    ),
                    Text(
                      vietnameseCurrencyFormat(reportStaffSummary.end ?? 0),
                      style: const TextStyle(
                          color: Color(0xFFEB3B5B),
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerDebReportDetailPage(
                            partnerId: reportStaffSummary.partnerId.toString(),
                            filter: widget.filter,
                            resultSelection: 'customer',
                          ),
                        ));
                  },
                  child: const Text(
                    'Chi tiết',
                    style: TextStyle(color: Color(0xFF2395FF)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void displayBottomSheet(
      BuildContext context, AccountCommonPartnerReport reportStaffSummary) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        backgroundColor: Colors.white,
        builder: (ctx) {
          return Container(
            height: MediaQuery.of(context).size.height / 3,
            child: Column(
              children: [
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20, top: 36),
                      child: Text(
                        'Nợ đầu kỳ:',
                        style:
                            TextStyle(color: Color(0xFF2C333A), fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 36),
                      child: Text(
                        vietnameseCurrencyFormat(reportStaffSummary.begin),
                        style: const TextStyle(
                            color: Color(0xFF2C333A), fontSize: 17),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20, top: 36),
                      child: Text(
                        'Thanh toán:',
                        style:
                            TextStyle(color: Color(0xFF2C333A), fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 36),
                      child: Text(
                        vietnameseCurrencyFormat(reportStaffSummary.credit),
                        style: const TextStyle(
                            color: Color(0xFF28A745), fontSize: 17),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20, top: 36),
                      child: Text(
                        'Phát sinh:',
                        style:
                            TextStyle(color: Color(0xFF2C333A), fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 36),
                      child: Text(
                        vietnameseCurrencyFormat(reportStaffSummary.debit),
                        style: const TextStyle(
                            color: Color(0xFF2395FF), fontSize: 17),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20, top: 36),
                      child: Text(
                        'Nợ cuối kì:',
                        style:
                            TextStyle(color: Color(0xFF2C333A), fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 36),
                      child: Text(
                        vietnameseCurrencyFormat(reportStaffSummary.end),
                        style: const TextStyle(
                            color: Color(0xFFEB3B5B), fontSize: 17),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEDEF),
      body: BlocLoadingScreen<AccountCommonPartnerReportBloc>(
        busyStates: const [AccountCommonPartnerReportInitial],
        child: BlocConsumer<AccountCommonPartnerReportBloc,
                AccountCommonPartnerReportState>(
            builder: (context, state) {
              if (state is AccountCommonPartnerReportLoading ||
                  state is AccountCommonPartnerReportLoadNoMore) {
                if (state.listAccountCommonPartnerReportState.isEmpty) {
                  return EmptyDataPage();
                }
                _refreshSaleOrderController.loadComplete();

                return SmartRefresher(
                  controller: _refreshSaleOrderController,
                  enablePullDown: false,
                  enablePullUp: true,
                  header: CustomHeader(
                    builder: (BuildContext context, RefreshStatus mode) {
                      Widget body;
                      if (mode == RefreshStatus.idle) {
                        body = const Text(
                          'Kéo xuống để lấy dữ liệu',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black12,
                          ),
                        );
                      } else if (mode == RefreshStatus.canRefresh) {
                        body = const Text(
                          'Thả ra để lấy lại dữ liệu',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black12,
                          ),
                        );
                      }
                      return Container(
                        height: 50,
                        child: Center(child: body),
                      );
                    },
                  ),
                  onLoading: () async {
                    widget.bloc.add(AccountCommonPartnerReportLoadMore(
                        getReportStaffSummaryQuery:
                            GetAccountCommonPartnerReportQuery(
                                dateTo: widget.filter.dateTo,
                                dateFrom: widget.filter.dateFrom,
                                userId:
                                    widget.filter.userReportStaffOrder.value,
                                companyId: widget.filter.companyOfUser.value,
                                categId:
                                    widget.filter.partnerCategory.id.toString(),
                                partnerId: widget.filter.partner.id.toString(),
                                display: widget.filter.display,
                                page: 1,
                                pageSize: 20,
                                resultSelection: widget.resultSelection,
                                take: 20),
                        type: widget.type));
                  },
                  footer: CustomFooter(
                    builder: (BuildContext context, LoadStatus mode) {
                      Widget body;
                      if (mode == LoadStatus.idle) {
                        body = const Text(
                          'Kéo lên để lấy thêm dữ liệu',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black12,
                          ),
                        );
                      } else if (mode == LoadStatus.loading) {
                        body = LoadingIndicator();
                      } else if (mode == LoadStatus.canLoading) {
                        body = const Text(
                          'Thả ra để lấy lại dữ liệu',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black12,
                          ),
                        );
                      } else {
                        body = const Text(
                          'Không còn dữ liệu',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black12,
                          ),
                        );
                      }
                      return Container(
                        height: 50,
                        child: Center(child: body),
                      );
                    },
                  ),
                  child: ListView.builder(
                      itemCount:
                          state?.listAccountCommonPartnerReportState?.length,
                      itemBuilder: (context, index) {
                        final AccountCommonPartnerReport
                            accountCommonPartnerReport =
                            state.listAccountCommonPartnerReportState[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 5),
                          child: _buildItemCustomer(accountCommonPartnerReport),
                        );
                      }),
                );
              }
              return Container();
            },
            listener: (context, state) {}),
      ),
    );
  }
}
