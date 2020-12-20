import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/feature_group/reports/customer_deb_report/blocs/account_common_partner_type_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/empty_data_page.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/helpers/svg_icon.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';
import 'package:tpos_mobile/widgets/loading_indicator.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';

class CustomerDebReportDetailPage extends StatefulWidget {
  CustomerDebReportDetailPage(
      {this.filter,
      this.scaffoldKey,
      this.type,
      this.resultSelection,
      this.partnerId});

  ///Bộ lọc
  final Filter filter;

  ///Type =0; Danh sách theo khách hàng, typ=1 danh sách theo nhân viên
  final int type;

  /// điều kiện lọc trên api
  final String resultSelection;
  final String partnerId;
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  _CustomerDebReportDetailPageState createState() =>
      _CustomerDebReportDetailPageState();
}

class _CustomerDebReportDetailPageState
    extends State<CustomerDebReportDetailPage> {
  final RefreshController _refreshSaleOrderController =
      RefreshController(initialRefresh: false);
  AccountCommonPartnerReportBloc bloc = AccountCommonPartnerReportBloc();
  @override
  void initState() {
    bloc.add(CustomerDebDetailReportLoaded(
        getReportStaffSummaryQuery: GetAccountCommonPartnerReportQuery(
            dateTo: widget.filter?.dateTo,
            dateFrom: widget.filter?.dateFrom,
            partnerId: widget.partnerId.toString(),
            page: 1,
            pageSize: 10,
            skip: 0,
            resultSelection: widget.resultSelection,
            take: 10),
        type: widget.type));
  }

  Widget _buildItemCustomer(
      AccountCommonPartnerReport accountCommonPartnerReport) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 11),
            child: Text(
              accountCommonPartnerReport.moveName ?? '',
              style: const TextStyle(
                  color: Color(0xFF28A745),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20, top: 11),
                child: SvgIcon(
                  SvgIcon.calender,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6, top: 11),
                child: accountCommonPartnerReport.date != null
                    ? Text(
                        DateFormat('dd/MM/yyyy')
                                .format(accountCommonPartnerReport.date) ??
                            '',
                        style: const TextStyle(
                            color: Color(0xFF2C333A), fontSize: 15),
                      )
                    : const Text(''),
              ),
              const SizedBox(
                width: 18,
              ),
              Container(
                margin: const EdgeInsets.only(left: 13, top: 11),
                height: 12,
                decoration: const BoxDecoration(
                    border: Border(
                  right: BorderSide(
                    //                   <--- left side
                    color: Color(0xFFE5E9EE),
                  ),
                )),
              ),
              const Padding(
                // ignore: prefer_const_constructors
                padding: EdgeInsets.only(left: 9, top: 11),
                child: SvgIcon(
                  SvgIcon.cardCustomer,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 11, left: 7),
                child: Text(
                  // ignore: unnecessary_string_interpolations
                  accountCommonPartnerReport.name ?? '',
                  style:
                      const TextStyle(color: Color(0xFF2C333A), fontSize: 15),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
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
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 11, right: 10),
                  child: Text(
                    '${S.current.endingDebt}: ',
                    style:
                        const TextStyle(color: Color(0xFF929daa), fontSize: 15),
                  ),
                ),
                InkWell(
                  onTap: () {
                    displayBottomSheet(context, accountCommonPartnerReport);
                  },
                  child: Row(
                    children: [
                      Text(
                        vietnameseCurrencyFormat(
                            accountCommonPartnerReport.end ?? 0),
                        style: const TextStyle(
                            color: Color(0xFFEB3B5B),
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFFA7B2BF),
                      ),
                    ],
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
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 36),
                      child: Text(
                        '${S.current.payment}:',
                        style: const TextStyle(
                            color: Color(0xFF2C333A), fontSize: 17),
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
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 36),
                      child: Text(
                        '${S.current.incurred}:',
                        style: const TextStyle(
                            color: Color(0xFF2C333A), fontSize: 17),
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
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 36),
                      child: Text(
                        '${S.current.startingDebt}:',
                        style: const TextStyle(
                            color: Color(0xFF2C333A), fontSize: 17),
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
    return BlocUiProvider<AccountCommonPartnerReportBloc>(
      bloc: bloc,
      listen: (state) {
        if (state is AccountCommonPartnerReportLoadFailure) {
          showError(
              title: state.title, message: state.content, context: context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF008E30),
          // ignore: unnecessary_string_interpolations
          title: Text(
              // ignore: unnecessary_string_interpolations
              '${widget.resultSelection == 'customer'  ? S.current.menu_detailCustomerDeptReport : S.current.menu_detailCustomerDeptReport}'),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: const [
            SvgIcon(
              SvgIcon.printAppbar,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
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
                      bloc.add(CustomerDebDetailReportLoadMore(
                          getReportStaffSummaryQuery:
                              GetAccountCommonPartnerReportQuery(
                                  dateTo: widget?.filter?.dateTo,
                                  dateFrom: widget?.filter?.dateFrom,
                                  userId:
                                      widget.filter.userReportStaffOrder.value,
                                  companyId: widget.filter.companyOfUser.value,
                                  partnerId: widget.partnerId.toString(),
                                  pageSize: 10,
                                  resultSelection: widget.resultSelection,
                                  take: 10,
                                  skip: 10),
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
                            padding: const EdgeInsets.all(6),
                            child:
                                _buildItemCustomer(accountCommonPartnerReport),
                          );
                        }),
                  );
                }
                return Container();
              },
              listener: (context, state) {}),
        ),
      ),
    );
  }
}
